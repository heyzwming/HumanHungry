/************************************************************
* 传球函数函数名： PassBall									*
*															*
* 实现功能： 传球 or 射门										*
*															*
* 具体描述： 												*
*															*
*															*
* 返回值：			PlayerTask								*
*															*
* 说明：														*
*															*
************************************************************/

#include "PassBall.h"
#include "utils/maths.h"
#include "utils/constants.h"
#include "utils/worldmodel.h"
//#include "ParamReader.h"
#include <iostream>
using namespace std;

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int runner_id, int reveiver_id);

#define fast_pass 3
float head_len = 7.0;

namespace{
	bool isSimulation = false;
	float param = 2;
}

// 判断是否可以传球
bool is_ready_pass(const point2f& ball ,const point2f& passer, const point2f& receiver){
	// 接球球员到球的矢量角度
	float receiver_to_ball = (ball - receiver).angle();
	// 球到传球球员的矢量角度
	float ball_to_passer= (passer - ball).angle();
	
	// 两个矢量角度之差小于某个值，判断是否可以传球
	bool pass = fabs(receiver_to_ball - ball_to_passer) < 0.5;
	return pass;
}
// runner_id 传球球员号码 reveiver_id 接球球员号码
PlayerTask player_plan(const WorldModel* model, int runner_id, int reveiver_id){
	PlayerTask task;

	//获取reveiver_id球员的视觉信息
	const PlayerVision& rece_msg = model->get_our_player(reveiver_id);
	//获取runner_id球员的视觉信息
	const PlayerVision& excute_msg = model->get_our_player(runner_id);

	float rece_dir = rece_msg.player.orientation;
	float excute_dir = excute_msg.player.orientation;
 	const point2f& rece_pos = rece_msg.player.pos;
	const point2f& excute_pos = excute_msg.player.pos;
	const point2f& ball = model->get_ball_pos();
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	float ball_to_our_goal = (FieldPoint::Goal_Center_Point - ball).angle();
	float rece_to_ball = (ball - rece_pos).angle();
	point2f receive_head = rece_pos + Maths::polar2vector(head_len, rece_msg.player.orientation);
	float pass_dir = (receive_head - ball).angle();	// 传球方向  球指向接球球员的头

	//判断球是否在小车控球嘴上，从两个参数着手：1.判断ball到车的距离是否小于某个值，2.车头方向和车到球矢量角度之差值是否小于某个值
	bool get_ball = (ball - excute_pos).length() < get_ball_threshold-1.5  && (fabs(anglemod(excute_dir - (ball - excute_pos).angle())) < PI / 6);

	//如果reveiver_id和runner_id是同一车，则直接射门
	if (reveiver_id == runner_id){
		if (get_ball){		// 如果球被控住
			//执行平击踢球，力度为最大127
			task.kickPower = 127;
			//踢球开关
			task.needKick = true;
			//挑球开关
			task.isChipKick = false;
		}else{		// 没控住球 执行拿球，并指向对方球门，对方球门到球矢量的角度
			float opp_goal_to_ball = (ball - opp_goal).angle();
			task.target_pos = ball + Maths::polar2vector(fast_pass, opp_goal_to_ball);
			task.orientate = (opp_goal - ball).angle();
			return task;
		}
		//执行拿球，并指向对方球门，对方球门到球矢量的角度
		/*
		float opp_goal_to_ball = (ball - opp_goal).angle();
		task.target_pos = ball + Maths::polar2vector(fast_pass, opp_goal_to_ball);
		task.orientate = (opp_goal - ball).angle();
		return task;	
		*/
	}

	//判断并执行传球
 	if (is_ready_pass(ball,excute_pos,rece_pos) ){	// 准备好传球了
		if (get_ball){		// 如果拿到了球，设置传球的属性
			task.kickPower = 50;
			task.needKick = true;
			task.isChipKick = false;
		}
		task.target_pos = ball + Maths::polar2vector(fast_pass, rece_to_ball);
		//printf("kicke ball\n");
		}
		else{		// 没有准备好传球，则改变位置		目标位置改为  球的坐标 + 极坐标（球的半径 + 球员半径，接球球员指向球的方向  ）转成的二维向量坐标
		task.target_pos = ball + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE +12, rece_to_ball);
		}
	task.orientate = pass_dir;		//pass_dir = (receive_head - ball).angle();
	//flag = 1表示小车加速度*2
	task.flag = 1;
	return task;
	
	
}


