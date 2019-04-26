/********************************************************************  
*																	*
*  射门函数函数名：			Shoot									*
*  实现功能：		射门，朝向位置是按照场上球门的位置做相应的逻辑获得的	*
*																	*
*																	*
*  返回参数			无												*
*																	*
********************************************************************/

#include "shoot.h"
#include "utils/maths.h"
#include <math.h>
#include "utils/WorldModel.h"

#define Center_To_Mouth 8
#define Vision_ERROR 2
#define fast_shoot 1

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

namespace{
	bool isSimulation = false;
	float param = 1;
}




/***************GetBall部分*****************/


double spiral_buff = 8.0;
double get_ball_buf = -4;
double do_spiral_dist = 30;
double do_spiral_buff = 0;
double around_ball_dist = 30;
double vision_error = 3;
bool isSimulation = false;
int do_spiral_max_cnt = 70;
#define frame_rate  60.0
float away_ball_dist_x = 20;//这个值越大 拿球越平滑

/*
GetBall::GetBall()
{
WorldModel worldModel;
isSimulation = model->get_simulation();
isSimulation ? get_ball_buf = -4 : get_ball_buf = 5;
isSimulation ? away_ball_dist_x = 20 : away_ball_dist_x = 40;
}

GetBall::~GetBall()
{
}

*/


//判断朝向对方球门角度范围，如果大于-90度小于90度，返回true
bool toward_opp_goal(float dir){
	return (dir < PI / 2 && dir>-PI / 2);
}

float ball_x_angle(const WorldModel* model){
	WorldModel worldModel;
	vector<point2f> ball_points;
	ball_points.resize(8);
	for (int i = 0; i < 8; i++){
		const point2f& temp_points = model->get_ball_pos(i);
		ball_points.push_back(temp_points);
	}
	return Maths::least_squares(ball_points);
}
//robot_id为拿球小车车号，receiver_id为接球小车车号
PlayerTask GetBall_plan(const WorldModel* model, int robot_id, int receiver_id){
	//创建PlayerTask对象
	PlayerTask task;
	WorldModel worldModel;
	//以下为执行拿球需要的参数，相关常量查看constaants.h
	//获得小球当前图像帧坐标位置，重点：小球的坐标信息都以图像帧为最小单位从视觉机接收并存储，可以把球坐标看成是一个个数组，数组索引是图像帧号，数组元素是坐标信息
	const point2f& ball = model->get_ball_pos();
	//获得小球当前帧的上一帧图像坐标信息
	const point2f& last_ball = model->get_ball_pos(1);
	//获得我方receiver_id小车坐标位置信息
	const point2f& receive_ball_player = model->get_our_player_pos(receiver_id);
	//获得我方robot_id小车坐标信息
	const point2f& get_ball_player = model->get_our_player_pos(robot_id);
	//敌方球门中点
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	//我方receier_id小车朝向信息，注意：小车朝向为车头垂直方向与场地x轴正方向逆时针夹角
	const float rece_dir = model->get_our_player_dir(receiver_id);
	//获得以receive_ball_player为原点的极坐标，ROBOY_HEAD为极坐标length,rece_dir为极坐标angle
	const point2f& rece_head_pos = receive_ball_player + Maths::polar2vector(ROBOT_HEAD, rece_dir);
	//获得我方robot_id小车朝向信息
	const float dir = model->get_our_player_dir(robot_id);
	//获得receive_ball_player到ball向量的角度，注意：所有角度计算为向量与场地x轴正方向逆时针夹角
	float receive2ball = (ball - receive_ball_player).angle();
	//获得对方球门到球的向量角度
	float opp_goal2ball = (ball - opp_goal).angle();
	//获得ball到对方球门的向量角度
	float ball2opp_goal = (opp_goal - ball).angle();
	//获得对方球门到球的向量长度
	float ball_away_goal = (ball - opp_goal).length();
	//获得球到get_ball_player的向量长度
	float player_away_ball = (get_ball_player - ball).length();
	//获得对方球门到get_ball_player的长度
	float player_away_goal = (get_ball_player - opp_goal).length();
	//获得球当前坐标到上一坐标位置向量的长度
	float ball_moving_dist = (ball - last_ball).length();
	//判断dir与对方球门的角度关系，看toward_opp_goal函数
	bool is_toward_opp_goal = toward_opp_goal(dir);
	//判断小车是否在球与对方球门之间
	bool ball_behind_player = ball_away_goal + BALL_SIZE + MAX_ROBOT_SIZE> player_away_goal;
	//判断小球是否运动
	bool ball_moving = (ball_moving_dist < 0.8) ? false : true;
	//判断get_ball_player小车到ball向量角绝对值是否小于75度
	bool player_toward_ball = fabs((ball - get_ball_player).angle() - dir) < (PI / 2 - PI / 12) ? true : false;
	bool direct_get_ball = !ball_moving;
	bool across_ball;
	bool ball_move2target;
	float ball_moving_dir = (ball - last_ball).angle();
	point2f ball_with_vel = ball + Maths::polar2vector(ball_moving_dist, ball_moving_dir);
	if (!ball_moving)
		//小球位移为当前位置
		ball_with_vel = ball;
	float ball_to_player = (get_ball_player - ball_with_vel).angle();
	//球车方向和小车方向的夹角，其中球车方向为小球与小车中心点的矢量方向、小车方向为垂直车头方向
	float ball_player_dir_angle = (ball - get_ball_player).angle() - dir;
	//判断小球是否在吸球嘴附近
	bool ball_beside_player_mouth = (ball - get_ball_player).length() < 14 && fabs(ball_player_dir_angle) > PI / 4 && fabs(ball_player_dir_angle)<PI / 2;
	if (receiver_id == robot_id){
		//判断x轴方向get_ball_Player小车与球的位置关系，小车在球上侧，返回true	
		bool ball_x_boundary_right = (ball.x - 2) < get_ball_player.x ? true : false;
		//判断y轴方向get_ball_player小车与球的位置关系，小车在球左侧，返回true
		bool ball_y_boundary_right = (ball.y - 2) < get_ball_player.y ? true : false;
		//判断小球与get_ball_player车的位置关系执行拿球
		if (!ball_x_boundary_right){
			//给robot_id小车设置任务中的目标点坐标，就是让小车跑到某个点，该点以ball_with_vel为极坐标原点
			task.target_pos = ball_with_vel + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + get_ball_buf, opp_goal2ball);
		}
		else
		{
			if (ball_y_boundary_right)
				//给robot_id小车设置任务中的目标点坐标，直接设置x,y
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y + 35);
			else
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y - 35);

		}
		task.orientate = (opp_goal - ball).angle();
	}
	else
	{   //判断球与get_ball_palyer、receive_ball_player之间的位置关系，如果x轴方向球在两车下侧，得到true
		bool all_on_ball_x_boundary_left = (ball.x - 2) < get_ball_player.x && (ball.x - 2) < receive_ball_player.x;
		//如果x轴方向球在两车上侧，得到true
		bool all_on_ball_x_boundary_right = (ball.x - 2) > get_ball_player.x && (ball.x - 2) > receive_ball_player.x;
		//判断y轴方向get_ball_player小车与球的位置关系，小车在球左侧，得到true
		bool executer_onball_y_boundary_right = (ball.y - 2) < get_ball_player.y ? true : false;
		//判断小球与拿球车、接球车之间的位置关系执行拿球
		if (all_on_ball_x_boundary_right){
			if (executer_onball_y_boundary_right)
				//设置task任务目标点坐标
				task.target_pos.set(ball_with_vel.x + away_ball_dist_x, ball_with_vel.y + 35);
			else
				task.target_pos.set(ball_with_vel.x + away_ball_dist_x, ball_with_vel.y - 35);

		}
		else if (all_on_ball_x_boundary_left)
		{
			if (executer_onball_y_boundary_right)
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y + 35);
			else
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y - 35);

		}
		else
		{

			task.target_pos = ball_with_vel + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + get_ball_buf, receive2ball);
		}
		task.orientate = (rece_head_pos - ball).angle();
	}
	//判断小球在拿球车吸球嘴附近执行拿球
	if (ball_beside_player_mouth){
		//
		task.target_pos = ball + Maths::polar2vector(20, anglemod(dir + PI));
	}
	return task;

}


/********************************/




//bool ball_moving_to_head;

/*

//Shoot类构造函数，初始化ball_moving_to_head值为false
Shoot::Shoot()
{
ball_moving_to_head = false;
}

Shoot::~Shoot()
{
}
*/

// 追逐球
// 调用GetBall类的相关方法来 拿到球
// TODO: 不理解为什么do_chase_ball 要朝向球门接球？
// TODO: 转向对GetBall类的分析
PlayerTask do_chase_ball(const WorldModel* model,int runner_id){
	// GetBall 朝向某个角色拿球
	// 第一个参数 runner_id : 函数执行者 / 接球 球员
	// 第二个参数 receiver_id : 传球 球员
	//GetBall get_ball;
	// 当 两个参数相同 朝向球门接球
	return GetBall_plan(model, runner_id, runner_id);
}

// 先停车如果小球在车头吸球嘴上，就射门
PlayerTask do_wait_touch(const WorldModel* model, int runner_id){
	PlayerTask task;


	const point2f& pos = model->get_our_player_pos(runner_id);
	//const point2f& get_our_player_pos(int id)const;
	const point2f& ball = model->get_ball_pos();
	const float& player_dir = model->get_our_player_dir(runner_id);
	
	// 创建一个HaltRobot对象halt，halt.plan方法返回一个PlayerTask任务对象task
	// 停止机器人
	// TODO: 找不到HaltRobot停止机器人的任务   暂时不使用急停功能
	//HaltRobot halt;
	//task.RobotHalt(runner_id);

	//task = halt.plan(runner_id);

	// 设置task中的吸球开关为true，小车吸球
	task.needCb = true;
	
	// 判断球是否在小车车头吸球嘴上
	// 二个判断条件：小球到车的距离是否小于某个值；车到球的矢量角度是否和车头的矢量角度之差的绝对值是否小于某个值
	if ((ball - pos).length() < BALL_SIZE / 2 + MAX_ROBOT_SIZE + 5 && (anglemod(player_dir - (ball - pos).angle()) < PI / 6)){
	
		// 设置task中的踢球参数：
		// kickPower	踢球力量
		// needKick		平踢球开关
		// isChipKick	挑球开关
		task.kickPower = 127;
		task.needKick = true;
		task.isChipKick = false;
	}
	
	return task;
}

// 接球 吸球
PlayerTask do_stop_ball_and_shoot(const WorldModel* model, int runner_id){
	PlayerTask task;
//	WorldModel worldModel;

	const point2f& pos = model->get_our_player_pos(runner_id);
	const point2f& ball = model->get_ball_pos();
	const float& dir = model->get_our_player_dir(runner_id);
	const float& dir_ball = (fabs(anglemod(dir - (ball - pos).angle())));

	//判断球是否在车头吸球嘴上
	bool  orienta_ball = (fabs(anglemod(dir - (ball - pos).angle()))) < PI / 6;

	//如果球不在车头吸球嘴上，车不动，车头朝向球
	if (!orienta_ball){
		task.target_pos = pos;
		task.orientate = (ball - pos).angle();
	}
	//如果球在车头吸球嘴上，needCb吸球开关吸球
	else
	{
	//	HaltRobot halt;
	//	task = halt.plan(runner_id);
		task.needCb = true;
	}
	return task;
}

// 拿球
PlayerTask do_turn_and_shoot(const WorldModel* model, int runner_id){
	PlayerTask task;
//	WorldModel worldModel;

	const point2f& pos = model->get_our_player_pos(runner_id);
	const point2f& ball = model->get_ball_pos();
	//TODO: 重载运算符“-”号的作用
	const point2f& opp = -FieldPoint::Goal_Center_Point;

	// 如果球到球员的距离小于15 则前去接球
	if ((ball - pos).length() < 15){
		// 该方法实现的是  将极坐标转为二维向量，
		// 传入参数 ： 极坐标的长度与角度  
		// 返回值 ： 二维向量的x和y
		task.target_pos = ball + Maths::polar2vector(15,(pos- ball).angle());
		task.orientate = (ball - pos).angle();
	}
	// 否则 调用 GetBall类的相关方法去拿球
	else 
	{
		//GetBall get_ball;
		task = GetBall_plan(model, runner_id, runner_id);
	}
	/*else
	{
		task.target_pos = ball + Maths::polar2vector(11,(ball - opp).angle());
		task.orientate = (opp - ball).angle();
	}*/
	return task;
}

//调整车位置方向，到  对方球门指向球的向量的 方向位置
PlayerTask do_adjust_dir(const WorldModel* model, int runner_id){
	PlayerTask task;
//	WorldModel worldModel;

	const point2f& ball = model->get_ball_pos();
	// opp_goal ： 对方球门的二维坐标
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	const point2f& player = model->get_our_player_pos(runner_id);
	// TODO: back2ball_p 为目标 位置   赋值号右边的意思？
	const point2f& back2ball_p = ball + Maths::polar2vector(20, (ball - opp_goal).angle());

	task.target_pos = back2ball_p;
	task.orientate = (opp_goal - ball).angle();
	return task;
}

//射门
PlayerTask do_shoot(const WorldModel* model, int runner_id){
//	WorldModel worldModel;
	PlayerTask task;

	// opp_goal 对方球门中心
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	const point2f& ball = model->get_ball_pos();
	const point2f& player = model->get_our_player_pos(runner_id);
	const float& dir = model->get_our_player_dir(runner_id);

	// 布尔类型变量 get_ball  拿到球
	// 球到球员的距离小于 拿到球的阈值(宏定义16)-2.5  &&  球员角度与球角度差 的绝对值 小于一定的值  为1
	bool get_ball = (ball - player).length() < get_ball_threshold - 2.5 && (fabs(anglemod(dir - (ball - player).angle())) < PI / 6);

	// 如果拿到球了 准备射门
	if (get_ball){
		task.kickPower = 127;
		task.needKick = true;
		task.isChipKick = false;
	}

	// 对方球门 到 球的向量 的角度
	float opp_goal_to_ball = (ball - opp_goal).angle();

	// TODO：fast_shoot 的意义
	task.target_pos = ball + Maths::polar2vector(fast_shoot, opp_goal_to_ball);
	task.orientate = (opp_goal - ball).angle();
	task.flag = 1;
	return task;
}

PlayerTask player_plan(const WorldModel* model, int robot_id){
	cout << "int shoot skill" << endl;

	PlayerTask task;
	WorldModel worldModel;

	bool ball_moving_to_head;

	//射门需要用到的参数
	const point2f& kick_pos = model->get_our_player_pos(robot_id);	// 球员位置
	const point2f& ball = model->get_ball_pos();				// 球的位置

	const point2f& last_ball = model->get_ball_pos(1);			// 获得上一帧球的位置
	const float kicker_dir = model->get_our_player_dir(robot_id);		// 球员角度
	const point2f& opp = -FieldPoint::Goal_Center_Point;			// 对方球门

	// TODO: 两个朝向角之差的意义

	//对方球门位置与射门球员位置矢量方向角 与 射门球员朝向角之差
	float kick2opp_kickdir_angle = anglemod((opp - kick_pos).angle() - kicker_dir);
	//球与射门球员位置矢量方向角 与 射门球员朝向角之差
	float kick2ball_kickdir_angle = anglemod((ball - kick_pos).angle() - kicker_dir);

	//对方球门与射门球员位置矢量方向角 与 射门球员朝向角向角之差 的绝对值 小于某个值时为true，即判断射门球员是否朝向着对方球门
	bool toward_oppgoal = fabs(kick2opp_kickdir_angle) < PI / 4;
	//球与射门球员位置矢量方向角 与 射门球员朝向角之差 的绝对值 小于某个值时为true，即判断球是否在射门球员前方
	bool ball_front_head = fabs(kick2ball_kickdir_angle) < PI / 3;

	//球当前帧位置和上一帧位置差，即球位移量
	point2f vector_s = ball - last_ball;
	//车头右侧位置
	point2f head_right = kick_pos + Maths::polar2vector(Center_To_Mouth,anglemod(kicker_dir + PI/6));
	//车头左侧位置
	point2f head_left = kick_pos + Maths::polar2vector(Center_To_Mouth, anglemod(kicker_dir - PI / 6));
	//车头中间位置
	point2f head_middle = kick_pos + Maths::polar2vector(7, kicker_dir);
	//车头右侧位置到球位移矢量
	point2f vector_a =  head_right - ball ;
	//车头左侧位置到球位移矢量
	point2f vector_b =  head_left - ball;
	//车头中间位置到球位移矢量
	point2f vector_c = head_middle - ball;

	bool wait_touch, stop_ball;
	bool wait_touch_condition_a, wait_touch_condition_b;

	// 如果 球与上一帧的位移差 小于 Vision_ERROR（2）
	if (vector_s.length() < Vision_ERROR){
		//判断球是否朝球员头移动
		ball_moving_to_head = false;
	}
	else
	{
		//求 球员头中间位置到球位移矢量 vector_c 和 球与上一帧的位移量 vector_s之间的夹角
		float angle_sc = acos(dot(vector_c, vector_s) / (vector_c.length() *vector_s.length()));
		//判断球是否朝球员头移动
		ball_moving_to_head = angle_sc < PI/6 && angle_sc > -PI/6;
	}

	//射门条件a:球是否在射门车车头方向，并且车头朝向对方球门
	wait_touch_condition_a = ball_front_head&& toward_oppgoal;
	//射门条件b:满足条件a的同时是否满足球在车头方向并朝车头运动
	wait_touch_condition_b = ball_moving_to_head && wait_touch_condition_a;
	//停球判断布尔变量
	stop_ball = (ball_front_head &&ball_moving_to_head&&!toward_oppgoal);
	//等球判断布尔变量
	wait_touch =  wait_touch_condition_b;

	//ShootMethods枚举变量
	ShootMethods method;
	if (wait_touch)//等球判断，WaitTouch方法
		method = WaitTouch;
	else if (stop_ball)//停球判断, StopBall方法
		method = StopBall;
	else if (!toward_oppgoal)//没有朝向对方球门判断，AdjustDir方法
		method = AdjustDir;
	else if ((ball - kick_pos).length() < get_ball_threshold+5 && (anglemod(kicker_dir - (ball - kick_pos).angle()) < PI / 6))//判断球在车头吸球嘴位置,ShootBall方法
		method = ShootBall;
	else
		method = ChaseBall;//拿球方法

	// 由当前的模式枚举method 执行相应的方法
	switch (method)
	{
	case None:
		break;
	case ChaseBall:
		task = do_chase_ball(model, robot_id);
		break;
	case WaitTouch:
		task = do_wait_touch(model, robot_id);
		break;
	case StopBall:
		task = do_stop_ball_and_shoot(model, robot_id);
		break;
	case AdjustDir:
		task = do_adjust_dir(model, robot_id);
		break;
	case ShootBall:
		task = do_shoot(model, robot_id);
		break;
	default:
		break;
	}
	cout << "out shoot skill" << endl;
	return task;
}