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
#include "GetBall.h"

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
	return player_plan(model, runner_id, runner_id);
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
		task = player_plan(model, runner_id, runner_id);
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