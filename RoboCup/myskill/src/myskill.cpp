
/************************************
									*
1.机器人运动到球一定半径范围停止		*
2.以球为圆心做圆周运动调整射门角度		*
3.当射门角度合适的时候，慢慢上前，射门	*
									*
************************************/

/*
可以通过修改目标点的方式修改skill，即shootball -> passball。
*/

#include "myskill.h"
#include "utils/maths.h"
//用户注意；接口需要如下声明
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

enum ball_near  //PenaltyArea
{

	outOfOrbit,
	onOrbit,
	shoot
	/*RightArc_behind,
	RightArc_front,
	MiddleRectangle_behind,
	MiddleRectangle_front,
	LeftArc_behind,
	LeftArc_front,*/
};


PlayerTask player_plan(const WorldModel* model, int robot_id){
	PlayerTask task;
	bool isPasstoReceiver = false;//true->pass false->shoot
	int receiver;		// 传球行为的接球球员
	// 遍历我方6名球员
	// 寻找一名在场的球员（除守门员和本传球球员外）
	for (int i = 0; i < 6; i++){
		if (i == robot_id || i == model->get_our_goalie()) // 当遍历到执行本skill的球员或者我方守门员的时候，跳过本次循环
			continue;
		if (model->get_our_exist_id()[i])		// 找到一个可以传球的球员
			receiver = i;				// 接球球员
	}
	const point2f& receiver_pos = model->get_our_player_pos(receiver);	// 接球球员的位置坐标
	point2f& opp_goal = -FieldPoint::Goal_Center_Point;	// 对方球门中心点
	if (isPasstoReceiver)	// 是否传球给 传球行为的接球球员
							//  true -> 传球  false -> 直接射门
		opp_goal = receiver_pos;

	const float pi = 3.1415926;
	const float& circleR = 30;		// 沿着球外 半径为30的圆 移动/调整方向  球周围的安全区域
	const float& DetAngle = 0.6;	// ？

	const point2f& goal = FieldPoint::Goal_Center_Point;	// 目标点->对方球门中心
	const point2f& ball = model->get_ball_pos();	
	const point2f& kicker = model->get_our_player_pos(robot_id);
	
	const float& dir = model->get_our_player_dir(robot_id);
	ball_near orbit;	// orbit 轨道、范围 	枚举类型	outOfOrbit  |  onOrbit  |  shoot
	
	// 球的坐标+ 极坐标转换成二维向量（长度circleR=30，方向(ball-opp_goal).angle() 由对方球门指向球的向量的角度）
	// 在 球外半径为30的轨道上 的 射门准备点 = 球的坐标 + 沿目标点（对方球门中心）指向球的方向 长度为30的矢量（并用vector2polar讲极坐标值转换成二维向量值）
	point2f shootPosOnOrbit = ball + Maths::vector2polar(circleR,(ball-opp_goal).angle());

	// TODO: 没理解这句内容
	// 射门方向 = | 球指向kicker的角度 - 对方球门中心指向球的角度 |
	float toShootDir = fabs((kicker - ball).angle() - (ball - opp_goal).angle());   //(kicker - shootPosOnOrbit).length();
	float toBallDist = (kicker - ball).length();		// kicker离球的距离
	float toOppGoalDir = (opp_goal - kicker).angle();		// 沿kicker指向目标点的 角度
	float toBallDir = (ball - kicker).angle();

	/*
	思考两个问题

	1.怎么能绕着正确的方向走到P2点（一直绕着正确的方向）
	2.怎么绕着弧线而不是直线走到P2（绕着黑色圆弧，而不是黄色直线示意图）

	第一个问题留给你们思考，我代码里面有写
	第二个问题，我们要考虑一下，我们的伺服周期
	1/60秒的伺服周期，每秒执行60次skill的状态机判断，不停地生成新的targetpos，最后使得targetpos执行出来的结果是一个圆弧
	
	*/

	// = 球的位置 + 沿 球指向kicker的方向 球的安全半径距离30 的二维坐标
	// kicker 在安全轨迹上的 踢球准备点  
	point2f robotBallAcrossCirclePoint = ball + Maths::vector2polar(circleR, (kicker - ball).angle());

	// = 球的坐标 + 沿 目标点到球的位置 的方向 球的安全半径距离30 的二维坐标
	point2f AntishootPosOnOrbit = ball + Maths::vector2polar(circleR, (opp_goal - ball).angle());

	// 沿球到kicker方向的 向量
	point2f BallToRobot = kicker - ball;

	// 状态机的状态判断
	// 对当前的kicker的区域（安全轨道外 轨道上 轨道内（射门））进行判断
	if (toBallDist >circleR + 10)	// 如果kicker到球的距离 > 安全距离30 + 10
		orbit = outOfOrbit;
	else if (toShootDir > 1)	// 如果球到kicker的向量和目标点到球的向量的角度差大于1  则 说明kicker到达了圆形轨道
		orbit = onOrbit;
	// TODO: else 的匹配问题
		 else	// 否则（角度差 < 1） 射门
			orbit = shoot;
	
	// 是否拿到了球
	bool getBall = toBallDist < 10;
	float diffdir_onorbit = 0;				// ？
	float b2r = BallToRobot.angle();		// 角度量
	float o2b = (ball - opp_goal).angle();	// 角度量
	bool add;

	// 状态机 状态转换
	switch (orbit)
	{
		case outOfOrbit:		// 在球的安全轨道外
			task.target_pos = robotBallAcrossCirclePoint;	// 移动目标点为球的安全轨道
			task.orientate = toOppGoalDir;		// 球员 始终朝向目标点
			break;
		case onOrbit:	// 在安全轨道上
			// 调整 在 轨道上的位置
			/*
			
			每次让机器人拓展一个小圆弧 慢慢从 刚进入到安全轨道的点 一步一步按弧线走到 射门 的准备点


			
			*/

			// 个人觉得这里应该考虑的是b2r和o2b的角度的正负  当b2r 和 o2b都是正的时候相乘为正
			if (b2r * o2b >0){
				if (b2r > 0){
					if (b2r > o2b)
						add = false;
					else
						add = true;
				}
				else{
					if (b2r > o2b)
						add = false;
					else
						add = true;
				}
			}
			else{
				if (b2r > 0)
					add = true;
				else
					add = false;
			}


			if (add){	
				//+
				task.target_pos = ball + Maths::vector2polar(circleR, BallToRobot.angle() + DetAngle);
				task.orientate = toOppGoalDir;
			}
			else{
				//-
				task.target_pos = ball + Maths::vector2polar(circleR, BallToRobot.angle() - DetAngle);
				task.orientate = toOppGoalDir;
			}
			break;

		case shoot: 
			task.target_pos = ball + Maths::vector2polar(5, (ball - opp_goal).angle());
			task.orientate = toOppGoalDir;
			task.needKick = true;
			task.flag = 1;
				
			if (toBallDist < 10 && fabs(model->get_our_player_dir(robot_id) - task.orientate) < 0.15){
				if (isPasstoReceiver)
					task.kickPower = 60;
				else
					task.kickPower = 127;
			}			
			break;
	}
	return task;
}
