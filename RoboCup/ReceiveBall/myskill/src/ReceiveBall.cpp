#include "ReceiveBall.h"
#include "utils/maths.h"
//#include "GetBall.h"
//#include "PassBall.h"
#include "utils/WorldModel.h"
//#include "def.h"
//#include "rolematch/MunkresMatch.h"
#define BALL_VISION_ERROR 2.5
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int runner_id);
/*ReceiveBall::ReceiveBall()
{
}

ReceiveBall::~ReceiveBall()
{
}*/


PlayerTask player_plan(const WorldModel* model, int runner_id){
	PlayerTask task;
//	WorldModel worldModel;
	//接球需要的参数
	const point2f& ball = model->get_ball_pos();
	const point2f& vel = model->get_ball_vel();
	const point2f& receiver = model->get_our_player_pos(runner_id);
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	const float& receiver_dir = model->get_our_player_dir(runner_id);
	point2f reciver_head = receiver + Maths::polar2vector(ROBOT_HEAD , receiver_dir);
	bool close_receiver = (receiver - ball).length() < 50;
	bool head_toward_ball = false;
	bool ball_moveto_head = false;
	
	head_toward_ball = fabs(anglemod((ball - reciver_head).angle() - receiver_dir)) < 5 * PI / 12;
	ball_moveto_head = fabs(anglemod((reciver_head - ball).angle() - vel.angle())) < PI / 6;
	float angle = vel.angle();
	//line_perp_across(ball, vel.angle(), receiver), 计算 receiver到ball为起点，vel.angle()为斜率的直线上最近的点
	point2f task_point = Maths::line_perp_across(ball, vel.angle(), receiver);
	task.orientate = (opp_goal - receiver).angle();
	task.target_pos = task_point;
	
	/*if (close_receiver&&!head_toward_ball&&!ball_moveto_head){
		GetBall get_ball;
		task = get_ball.plan(runner_id, runner_id);
		return task;
	}*/

	return task;
}