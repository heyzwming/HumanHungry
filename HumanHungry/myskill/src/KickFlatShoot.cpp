/*
平射dll库:这个库只负责当lua层要求某球员射门的时候所执行的射门库，所以在库中仍要对守门员的防守站位和角度进行分析，因为lua层很有可能会面对不得不射门的状况。

平射的多种情况：
1、对方球门中 没有守门员
2、守门员和射门球员在同侧
3、守门员和射门球员在异侧
4、守门员在球门中间区域
5、守门员的多种状态：1）在球门内面朝球的方向（角度约为[-pi/4,pi/4]）
				   2）在球门边缘卡住球门，角度约为[-pi/2,-5pi/6] & [5pi/6,pi/2]


解决问题	1、opp_goal 和射门方向 的计算问题
		2、对方守门员的站位问题
		3、射门前的动作


本质上：进攻的多种姿势和状态
*/

#include "KickFlatShoot.h"
#include "GetBall.h"

#define DEBUG 1		// 为1时 为debug模式

// 调用GetBall的相关函数,朝向对方球门拿到球
PlayerTask do_chase_ball(const WorldModel* model, int runner_id){

	// get_ball_plan 朝向某个角色拿球
	// 第一个参数 runner_id : 函数执行者 / 接球球员
	// 第二个参数 receiver_id : 传球 球员
	// 当 两个参数相同 朝向球门接球
	return get_ball_plan(model, runner_id, runner_id);
}

/*
获得球员位置和朝向，球的位置，
打开吸球开关，
判断球是否被球员控制住，如果控制住则直接射门。

控球的判断方法：小球到球员的距离是否小于某个值； 球员朝向球 的矢量角度 是否和 球员朝向 的矢量角度之差的绝对值是否小于某个值
*/

// 球员停止运动 如果小球在球员脚上表示球员已经控到了球，则执行射门
PlayerTask do_wait_touch(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& player_pos	=	model->get_our_player_pos(runner_id);
	//const point2f& get_our_player_pos(int id)const;
	const point2f& ball_pos		=	model->get_ball_pos();
	const float&   player_dir	=	model->get_our_player_dir(runner_id);

	// 设置task中的吸球开关为true，小车吸球
	task.needCb					=	true;

	// 判断球是否被球员控制住
	// TODO: 如何判断球被球员控制住？
	// 二个判断条件：小球到车的距离是否小于某个值 同时 车到球的矢量角度是否和车头的矢量角度之差的绝对值是否小于某个值
	if ((ball_pos - player_pos).length() < BALL_SIZE / 2 + MAX_ROBOT_SIZE + 5 && (anglemod(player_dir - (ball_pos - player_pos).angle()) < PI / 6)){
		cout << "************************Ball is got by player*************************" << endl;
		// 设置task中的踢球参数：
		// kickPower	踢球力量，区别于挑球力度 chipKickPower
		// needKick		踢球开关
		// isChipKick	挑球开关
		task.kickPower = 127;	
		task.needKick = true;
		task.isChipKick = false;
	}
	return task;
}

/*
获得球员位置 和 朝向，
获得球的位置 和 球员到球的向量的角度，
判断球员有没有朝向球来的方向，如果没有则让球员朝向球来的方向 

停球
*/
PlayerTask do_stop_ball(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& player_pos	= model->get_our_player_pos(runner_id);
	const point2f& ball_pos		= model->get_ball_pos();
	const float&   player_dir	= model->get_our_player_dir(runner_id);
	const float&   player_ball_dir	= (fabs(anglemod(player_dir - (ball_pos - player_pos).angle())));	  // 球员的朝向 与 球员到球的方向 的角度差

	// 判断球员是否朝向球，球员的朝向角度 - 球员位置指向球位置的向量角度  小于一定的值
	// TODO: 球员是否面向着球（角度差）的判断方法中,这个角度差是否可以调整，这个值越小，停球越准，耗时越长
	bool  player_oriente_ball = player_ball_dir < PI / 6;

	//如果球没有被球员控住，则让球员朝向球的方向
	if (!player_oriente_ball){
		task.target_pos = player_pos;	// 呆在原地 等待球过来
		task.orientate = (ball_pos - player_pos).angle();	// 朝向球来的方向
	}
	//如果球员朝向了球来的方向，needCb吸球开关吸球
	else{
		task.needCb = true;
	}
	return task;
}

// 拿球
PlayerTask do_turn_and_shoot(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& player_pos = model->get_our_player_pos(runner_id);
	const point2f& ball_pos = model->get_ball_pos();
	const point2f& opp = -FieldPoint::Goal_Center_Point;

	// 如果球到球员的距离小于15 则前去接球
	// TODO: 这里的参数15值得探讨
	if ((ball_pos - player_pos).length() < 15){
		task.target_pos = ball_pos + Maths::polar2vector(15, (player_pos - ball_pos).angle());	// 与球距离15的地方接球
		task.orientate = (ball_pos - player_pos).angle();
	}
	// 否则 调用 GetBall类的相关方法去拿球
	else
	{
		task = get_ball_plan(model, runner_id, runner_id);
	}
	return task;
}

//调整车位置方向，到  对方球门指向球的向量的 方向位置
PlayerTask do_adjust_dir(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& ball_pos = model->get_ball_pos();
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;	// opp_goal ： 对方球门的二维坐标
	const point2f& player_pos = model->get_our_player_pos(runner_id);
	// 背朝球  球的位置 + （对方球门中心到球的位置的矢量方向 20 单位长度）
	const point2f& back2ball_p = ball_pos + Maths::polar2vector(20, (ball_pos - opp_goal).angle());

	task.target_pos = back2ball_p;
	task.orientate = (opp_goal - ball_pos).angle();
	return task;
}

//射门
PlayerTask do_shoot(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;	// opp_goal 对方球门中心
	const point2f& ball_pos = model->get_ball_pos();
	const point2f& player_pos = model->get_our_player_pos(runner_id);
	const float& player_dir = model->get_our_player_dir(runner_id);

	// 布尔类型变量 get_ball  拿到球
	// 球到球员的距离小于 拿到球的阈值(宏定义16)-2.5  &&  球员角度与球角度差 的绝对值 小于一定的值  为1
	bool get_ball = (ball_pos - player_pos).length() < get_ball_threshold - 2.5 && (fabs(anglemod(player_dir - (ball_pos - player_pos).angle())) < PI / 6);

	// 如果拿到球了 准备射门
	if (get_ball){
		task.kickPower = 127;
		task.needKick = true;
		task.isChipKick = false;
	}

	// 对方球门 到 球的向量 的角度
	float opp_goal_to_ball = (ball_pos - opp_goal).angle();

	// TODO：fast_shoot 的意义
	task.target_pos = ball_pos + Maths::polar2vector(fast_shoot, opp_goal_to_ball);
	task.orientate = (opp_goal - ball_pos).angle();
	task.flag = 1;		// flag为1小车加速度*2
	return task;
}

/*
对射门前的一些状态进行判断，并决定是否射门
*/

PlayerTask player_plan(const WorldModel* model, int robot_id){
	cout << "******************************int flat shoot skill plan******************************" << endl;
	PlayerTask task;

	bool ball_moving_to_head;

	//射门需要用到的参数
	const point2f& player_pos = model->get_our_player_pos(robot_id);	// 球员位置
	const point2f& ball_pos = model->get_ball_pos();				// 球的位置

	const point2f& last_ball_pos = model->get_ball_pos(1);			// 获得上一帧球的位置
	const float player_dir = model->get_our_player_dir(robot_id);		// 球员角度
	const point2f& opp_pos = -FieldPoint::Goal_Center_Point;			// 对方球门

	//对方球门位置与射门球员位置矢量方向角 与 射门球员朝向角之差
	float player2opp_playerdir_angle = anglemod((opp_pos - player_pos).angle() - player_dir);
	//球与射门球员位置矢量方向角 与 射门球员朝向角之差
	float player2ball_playerdir_angle = anglemod((ball_pos - player_pos).angle() - player_dir);

	// 对方球门与射门球员位置矢量方向角 与 射门球员朝向角向角之差 的绝对值 小于某个值时为true，
	// 判断射门球员是否朝向着对方球门
	bool toward_oppgoal = fabs(player2opp_playerdir_angle) < PI / 4;
	// 球与射门球员位置矢量方向角 与 射门球员朝向角之差 的绝对值 小于某个值时为true
	// 判断球是否在射门球员前方
	bool ball_front_head = fabs(player2ball_playerdir_angle) < PI / 3;

	// 球当前帧位置和上一帧位置差，
	// 球位移量
	point2f vector_s = ball_pos - last_ball_pos;
	// 球员右侧位置
	point2f head_right = player_pos + Maths::polar2vector(Center_To_Mouth, anglemod(player_dir + PI / 6));
	// 球员左侧位置
	point2f head_left = player_pos + Maths::polar2vector(Center_To_Mouth, anglemod(player_dir - PI / 6));
	//车头中间位置
	point2f head_middle = player_pos + Maths::polar2vector(7, player_dir);
	//车头右侧位置到球位移矢量
	point2f vector_a = head_right - ball_pos;
	//车头左侧位置到球位移矢量
	point2f vector_b = head_left - ball_pos;
	//车头中间位置到球位移矢量
	point2f vector_c = head_middle - ball_pos;

	bool wait_touch, stop_ball;
	bool wait_touch_condition_a, wait_touch_condition_b;



	// 如果 球与上一帧的位移差 小于视觉误差 Vision_ERROR（2）
	if (vector_s.length() < Vision_ERROR){
		ball_moving_to_head = false;		// 判定为球并没有移动/球没有向球员移动
	}
	else	// 球移动了
	{
		// dot 点积
		// 求 球到球员头中方向的矢量 和 球运动方向的角度 的夹角    acos 反余弦的值 返回角度
		float angle_sc = acos(dot(vector_c, vector_s) / (vector_c.length() *vector_s.length()));
		// 判断球是否朝球员头移动
		ball_moving_to_head = angle_sc < PI / 6 && angle_sc > -PI / 6;
	}






	//射门条件a:球是否在射门球员朝向方向，并且球员朝向对方球门
	wait_touch_condition_a = ball_front_head && toward_oppgoal;
	//射门条件b:满足条件a的同时是否满足球在球员朝向方向并朝球员运动
	wait_touch_condition_b = ball_moving_to_head && wait_touch_condition_a;
	//停球判断布尔变量
	stop_ball = (ball_front_head && ball_moving_to_head && !toward_oppgoal);
	//等球判断布尔变量
	wait_touch = wait_touch_condition_b;

	//ShootMethods枚举变量
	ShootMethods method;
	if (wait_touch)//等球判断，WaitTouch方法
		method = WaitTouch;
	else if (stop_ball)//停球判断, StopBall方法
		method = StopBall;
	else if (!toward_oppgoal)//没有朝向对方球门判断，AdjustDir方法
		method = AdjustDir;
	else if ((ball_pos - player_pos).length() < get_ball_threshold + 5 && (anglemod(player_dir - (ball_pos - player_pos).angle()) < PI / 6))//判断球在车头吸球嘴位置,ShootBall方法
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
		task = do_stop_ball(model, robot_id);
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

