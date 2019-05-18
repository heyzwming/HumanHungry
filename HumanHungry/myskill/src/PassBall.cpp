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

// 可以拓展出 Pass2Kicker   Pass2Rece  Pass2Tier
// 下一步整合，可以把GetBall.cpp整合进来
// 测试完平射传球可以开发出挑射传球

#include "PassBall.h"
using namespace std;

#define DEBUG 1

// 判断是否可以传球
bool is_ready_pass(const point2f& ball ,const point2f& passer, const point2f& receiver){
	// 接球球员到球的矢量角度
	float receiver_to_ball = (ball - receiver).angle();
	// 球到传球球员的矢量角度
	float ball_to_passer= (passer - ball).angle();
	
	// 两个矢量角度之差小于某个值，判断是否可以传球
	bool pass = fabs(receiver_to_ball - ball_to_passer) < PI / 8;
#if DEBUG

	cout << "------------接球球员到球的角度：" << receiver_to_ball << "----------------" << endl;
	cout << "------------球到传球球员的角度：" << ball_to_passer << "-----------------" << endl;

	if (pass)
		cout << "===================================================可以传球===================================================" << endl;
	else
		cout << "===================================================不可以传球===================================================" << endl;
#endif
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
	const point2f& ball_pos = model->get_ball_pos();
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;

	float ball_to_our_goal = (FieldPoint::Goal_Center_Point - ball_pos).angle();
	float rece_to_ball = (ball_pos - rece_pos).angle();
	point2f receive_head = rece_pos + Maths::polar2vector(head_len, rece_msg.player.orientation);
	float pass_dir = (receive_head - ball_pos).angle();	// 传球方向  球指向接球球员的头


	// TODO: 控球的距离判断条件 参数get_ball_threshold 和 角度判断条件
	//判断球是否被球员控住，从两个参数着手：1.判断ball到车的距离是否小于某个值，2.车头方向和车到球矢量角度之差值是否小于某个值
	bool get_ball = (ball_pos - excute_pos).length() < get_ball_threshold  && (fabs(anglemod(excute_dir - (ball_pos - excute_pos).angle())) < PI / 6);

	cout << "-----------------------传球球员离球的距离：" << (ball_pos - excute_pos).length() << "---------------" << endl;
	cout << "-----------------------传球球员的朝向与传球球员到球的角度 差：" << fabs( anglemod(excute_dir - (ball_pos - excute_pos).angle())) << "---------------" << endl;

#if DEBUG
	if (get_ball)
		cout << "===================================================球已经被球员控住===================================================" << endl;
	else
		cout << "===================================================球还没有被球员控住===================================================" << endl;
#endif

	//如果reveiver_id和runner_id是同一车，则直接射门
	if (reveiver_id == runner_id){
		cout << "===================================================两参数相同，直接射门===================================================" << endl;
		if (get_ball){		// 如果球被控住
			//执行平击踢球，力度为最大127
			task.kickPower = 127;
			//踢球开关
			task.needKick = true;
			//挑球开关
			task.isChipKick = false;
			cout << "===================================================球被控住，执行射门动作===================================================" << endl;
		}else{		// 没控住球 执行拿球，并指向对方球门，对方球门到球矢量的角度
			float opp_goal_to_ball = (ball_pos - opp_goal).angle();
			task.needCb = true;
			// TODO：fast_pass 传球的小助跑
			task.target_pos = ball_pos + Maths::polar2vector(fast_pass, opp_goal_to_ball);
			task.orientate = (opp_goal - ball_pos).angle();

			cout << "===================================================球没被控住，执行拿球动作===================================================" << endl;

			return task;
		}
	}

	//判断并执行传球
 	if (is_ready_pass(ball_pos,excute_pos,rece_pos) ){	// 准备好传球了

		cout << "===================================================准备好传球了===================================================" << endl;

		if (get_ball){		// 如果拿到了球，设置传球的属性
			task.kickPower = 50;
			task.needKick = true;
			task.isChipKick = false;
			cout << "===================================================拿到球了 开始传球！！===================================================" << endl;
		}
		task.target_pos = ball_pos + Maths::polar2vector(fast_pass, rece_to_ball);
		}else{		// 没有准备好传球，则改变位置		目标位置改为  球的坐标 + 极坐标（球的半径 + 球员半径，接球球员指向球的方向  ）转成的二维向量坐标
		cout << "===================================================还没有准备好传球！,执行拿球===================================================" << endl;
		task.target_pos = ball_pos + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE +2, rece_to_ball);
		}
	task.orientate = pass_dir;		//pass_dir = (receive_head - ball).angle();
	//flag = 1表示小车加速度*2
	task.flag = 1;
	return task;
}


