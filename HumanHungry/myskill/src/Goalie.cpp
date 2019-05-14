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

/*
防守情况分析：
1、前中场传球
2、前中场射门
3、后场传球
4、后场射门
5、角球传球
6、后场任意球防守
7、点球防守
*/

/*
需要：
1、持球球员的编号
2、持球球员的角度

*/



#include "Goalie.h"
#include "GetBall.h"

#pragma region 判断球是否在禁区内
// 判断球是否在禁区内
bool is_inside_penalty(const point2f& ball){
	// left为球门左半弧的圆心（-605/2，-35/2），right为球门右半弧的圆心（-605/2，35/2）
	const point2f& left = FieldPoint::Penalty_Arc_Center_Left;
	const point2f& right = FieldPoint::Penalty_Arc_Center_Right;

	// 球在球门前的禁区的长度为35的直线上 -35/2 < p.y < 35/2
	if (fabs(ball.y) < PENALTY_AREA_L / 2)		// 在禁区矩形区域内
			// -605/2 < p.x < -605/2 + 80 
		return ball.x < -FIELD_LENGTH_H + PENALTY_AREA_R && ball.x > -FIELD_LENGTH_H;	//PENALTY_AREA_R=80  FIELD_LENGTH_H = 605/2
	else if (ball.y < PENALTY_AREA_L / 2)		// 禁区 负半部分 
		// 球到球门负半侧1/4弧的圆心 的距离 < 80 且 球的x坐标 > (-605/2)
		return (ball - left).length() < PENALTY_AREA_R && ball.x > -FIELD_LENGTH_H;
	else									// 禁区的 正半部分 
		return (ball - right).length() < PENALTY_AREA_R && ball.x > -FIELD_LENGTH_H;
}
#pragma endregion
  

#pragma region 判断球是否在后场
// 判断球是否在后场内
bool is_inside_backcourt(const point2f& ball){
	// 球的y坐标在  -605/2 < ball.y < -180
	if (ball.y < BACK_COURT && ball.y > -FIELD_LENGTH_H)		// 在后场
		return true;
	else 
		return false;
}

#pragma endregion




// id为守门员车号
PlayerTask player_plan(const WorldModel* model, int robot_id){
	//创建PlayerTask对象
	PlayerTask task;

	//执行守门员防守需要的参数
	const point2f& goalie_pos = model->get_our_player_pos(robot_id);
	const point2f& ball_pos = model->get_ball_pos();
	const float player_dir = model->get_our_player_dir(robot_id);

	// TODO：这一行的变量 goal 导致了守门员只会防守球门的中心点，这个goal需要通过持球球员的角度 延伸出的方向向量 来计算
	const point2f& goal = FieldPoint::Goal_Center_Point;	// 己方球门中心点
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;

	/********************************************************/

	bool ball_inside_penalty = is_inside_penalty(ball_pos);

	// 判断小球在禁区内执行守门员防守
	if (ball_inside_penalty){
		//判断小球在控球嘴上执行挑球（通过距离和方向判断）
		if ((ball_pos - goalie_pos).length() < BALL_SIZE / 2 + MAX_ROBOT_SIZE + 2 && (anglemod(player_dir - (ball_pos - goalie_pos).angle()) < PI / 6)){
			task.kickPower = 127;
			task.needKick = true;
			task.isChipKick = true;
		}
		task.orientate = (ball_pos - goalie_pos).angle();
		task.target_pos = ball_pos + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE - 2, task.orientate);
	}
	// 小球不在禁区内执行守门员防守
	else{
		task.orientate = (ball_pos - goal).angle();
		task.target_pos = goal + Maths::polar2vector(20,task.orientate);
	}
	return task;
}

