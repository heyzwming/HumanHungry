/************************************************************
* 守门员函数函数名：		goalie								*
*															*
* 实现功能： 只限守门员在禁区内防守							*
*															*
* 具体描述： 												*
*															*
*															*
* 返回值：			PlayerTask								*
*															*
* 说明：														*
*															*
************************************************************/

#include "Goalie.h"
#include "GetBall.h"

//判断球是否在禁区内
bool is_inside_penalty(const point2f& p){
	//a为球门左侧点，b为球门右侧点
	const point2f& left = FieldPoint::Penalty_Arc_Center_Left;
	const point2f& right = FieldPoint::Penalty_Arc_Center_Right;

	if (fabs(p.y) < PENALTY_AREA_L / 2)	// 如果球的y轴坐标的绝对值 < 禁区的（靠中间）1/2
		// -605/2 < p.x < -605/2 + 80 
		return p.x < -FIELD_LENGTH_H + PENALTY_AREA_R && p.x > -FIELD_LENGTH_H;	//PENALTY_AREA_R=80  FIELD_LENGTH_H = 605/2
	else if (p.y < 0)		// 禁区 负半部分 靠外1/2  判断条件的意思maybe在禁区外？
		// 球门左侧到球的向量长度 < 
		return (p - left).length() < PENALTY_AREA_R && p.x > -FIELD_LENGTH_H;
	else				// 禁区的 正半部分 靠外1/2
		return (p - right).length() < PENALTY_AREA_R&& p.x > -FIELD_LENGTH_H;
}
  
//id为守门员车号
PlayerTask player_plan(const WorldModel* model, int robot_id){
	//创建PlayerTask对象
	PlayerTask task;
	//执行守门员防守需要的参数，部分参数可以看GetBAll.cpp中注释，相关常量查看constants.h
	const point2f& golie_pos = model->get_our_player_pos(robot_id);
	const point2f& ball = model->get_ball_pos();
	const float dir = model->get_our_player_dir(robot_id);
	const point2f& goal = FieldPoint::Goal_Center_Point;	// 己方球门中心点
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	bool ball_inside_penalty = is_inside_penalty(ball);

	//判断小球在禁区内执行守门员防守
	if (ball_inside_penalty){
		//判断小球在控球嘴上执行挑球
		if ((ball - golie_pos).length() < BALL_SIZE / 2 + MAX_ROBOT_SIZE + 2 && (anglemod(dir - (ball - golie_pos).angle()) < PI / 6)){
			task.kickPower = 127;
			task.needKick = true;
			task.isChipKick = true;
		}
		task.orientate = (ball - golie_pos).angle();
		task.target_pos = ball + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE - 2, task.orientate);
	}
	//小球不在禁区内执行守门员防守
	else
	{
		task.orientate = (ball - goal).angle();
		task.target_pos = goal + Maths::polar2vector(30,task.orientate);
	}
	return task;
}

