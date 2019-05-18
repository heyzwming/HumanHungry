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

// 朝向传球队员接球
// 需不需要GetBall拿球？有了求叉乘函数了...
// 测试接球性能和效率
// 考虑三个bool值变量怎么用：close_receiver   head_toward_ball    ball_moveto_head

#include "ReceiveBall.h"
#include "GetBall.h"

#define DEBUG 1

PlayerTask player_plan(const WorldModel* model, int runner_id){
	PlayerTask task;

	//接球需要的参数
	const point2f& ball_pos = model->get_ball_pos();
	const point2f& ball_vel = model->get_ball_vel();											// 获得场上球员的信息 
	const point2f& receiver_pos = model->get_our_player_pos(runner_id);						// 获得接球球员的位置 
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	const float& receiver_dir = model->get_our_player_dir(runner_id);					// 接球运动员的朝向 
	point2f reciver_head = receiver_pos + Maths::polar2vector(ROBOT_HEAD , receiver_dir);	// 接球球员的头部坐标

	bool close_receiver = (receiver_pos - ball_pos).length() < 80;
	bool head_toward_ball = false;
	bool ball_moveto_head = false;
	
	head_toward_ball = fabs(anglemod((ball_pos - reciver_head).angle() - receiver_dir)) < PI / 8;
	ball_moveto_head = fabs(anglemod((reciver_head - ball_pos).angle() - ball_vel.angle())) < PI / 8;
	float angle = ball_vel.angle();

//	cout << "--------------球的运动角度：" << angle << "------------------" << endl;

#if DUBUG
	if (close_receiver)
		cout << "=======================================球已经接近接球球员了！！==========================" << endl;
	else
		cout << "=======================================球离球员还很远！======================="<< endl;

	if (head_toward_ball)
		cout << "=======================================球员的头朝向着球============================" << endl;
	else
		cout << "=======================================球员的球没有朝向着球==============================" << endl;

	if (ball_moveto_head)
		cout << "=======================================球向接球球员移动====================" << endl;
	else
		cout << "=======================================球没有向接球球员移动====================" << endl;
#endif

	/********************************如果车离球的距离小于30  去getball********************************/
	if (close_receiver){
		task = get_ball_plan(model, runner_id, KICKER_ID);
		return task;
	}


	//line_perp_across(ball_pos, ball_vel.angle(), receiver_pos), 计算 receiver_pos到ball_pos为起点，ball_vel.angle()为斜率的直线上最近的点
	point2f task_point = Maths::line_perp_across(ball_pos, ball_vel.angle(), receiver_pos);

	cout << "--------------------------任务点：" << task_point << "-----------------------" << endl;

	task.needCb = true;
	task.orientate = (ball_pos - receiver_pos).angle();
	task.target_pos = receiver_pos;
	
	/*
	if (close_receiver&&!head_toward_ball&&!ball_moveto_head){
		GetBall get_ball;
		task = get_ball.plan(runner_id, runner_id);
		return task;
	}
	*/

	return task;
}