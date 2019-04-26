/************************************************************
* 接传球函数名： ReceiveBall						*
*															*
* 实现功能： 判断发点球方向，进行点球防守						*
*															*
* 具体描述： 通过对球的这一帧和前一帧的位置变化计算判断防守位置	*
*															*
*															*
* 返回值：			PlayerTask								*
*															*
* 说明：														*
*															*
************************************************************/

#include "ReceiveBall.h"
#include "utils/maths.h"
#include "utils/WorldModel.h"
//#include "rolematch/MunkresMatch.h"

#define BALL_VISION_ERROR 2.5

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int runner_id);

PlayerTask player_plan(const WorldModel* model, int runner_id){
	PlayerTask task;

	//接球需要的参数
	const point2f& ball = model->get_ball_pos();
	const point2f& vel = model->get_ball_vel();											// 获得场上球员的速度信息 
	const point2f& receiver = model->get_our_player_pos(runner_id);						// 获得接球球员的位置 
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	const float& receiver_dir = model->get_our_player_dir(runner_id);					// 接球运动员的朝向 
	point2f reciver_head = receiver + Maths::polar2vector(ROBOT_HEAD , receiver_dir);	// 接球球员的头部坐标

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
	
	/*
	if (close_receiver&&!head_toward_ball&&!ball_moveto_head){
		GetBall get_ball;
		task = get_ball.plan(runner_id, runner_id);
		return task;
	}
	*/

	return task;
}