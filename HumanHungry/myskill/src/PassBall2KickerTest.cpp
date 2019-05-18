#include "PassBall2KickerTest.h"
#include "GetBall.h"

#define frame_rate  60.0

#define DEBUG 1

//robot_id为拿球小车车号，KICKER_ID为朝向球员编号
PlayerTask player_plan(const WorldModel* model, int robot_id){
	//创建PlayerTask对象
	PlayerTask task;

	cout << "===================================================参数整定：===================================================" << endl;
	cout << "-----------getballbuf:" << get_ball_buf << "-------------" << endl;
	cout << "-----------awayballdist_x:" << away_ball_dist_x << "-------------" << endl;
	cout << "-----------awayballdist_y:" << away_ball_dist_y << "-------------" << endl;

	// 获得小球当前图像帧坐标位置
	// 重点：小球的坐标信息都以图像帧为最小单位从视觉机接收并存储，可以把球坐标看成是一个个数组，数组索引是图像帧号，数组元素是坐标信息
	const point2f& ball_pos = model->get_ball_pos();

	//获得小球当前帧的上一帧图像坐标信息
	const point2f& last_ball = model->get_ball_pos(1);

	// 注意！get_ball_vel()    

	//获得我方KICKER_ID小车坐标位置信息
	const point2f& receive_player_pos = model->get_our_player_pos(KICKER_ID);

	//获得我方robot_id小车坐标信息
	const point2f& get_ball_player = model->get_our_player_pos(robot_id);

	//敌方球门中点
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;

	//我方receier_id小车朝向信息，
	const float rece_dir = model->get_our_player_dir(KICKER_ID);

	//获得以receive_player_pos为原点的极坐标，ROBOY_HEAD为极坐标length,rece_dir为极坐标angle
	//TODO: ROBOT_HEAD 参数
	const point2f& rece_head_pos = receive_player_pos + Maths::polar2vector(ROBOT_HEAD, rece_dir);

	//获得我方robot_id小车朝向信息
	const float dir = model->get_our_player_dir(robot_id);

	//获得receive_player_pos到ball向量的角度，注意：所有角度计算为向量与场地x轴正方向逆时针夹角
	float receive2ball = (ball_pos - receive_player_pos).angle();

	//获得对方球门到球的向量角度
	float opp_goal2ball = (ball_pos - opp_goal).angle();

	//获得ball到对方球门的向量角度
	float ball2opp_goal = (opp_goal - ball_pos).angle();

	//获得对方球门到球的向量长度
	float ball_away_goal = (ball_pos - opp_goal).length();

	//获得球到get_ball_player的向量长度
	float player_away_ball = (get_ball_player - ball_pos).length();

	//获得对方球门到get_ball_player的长度
	float player_away_goal = (get_ball_player - opp_goal).length();

	//获得球当前坐标到上一坐标位置向量的长度
	float ball_moving_dist = (ball_pos - last_ball).length();


	//判断dir与对方球门的角度关系，看toward_opp_goal函数
	bool is_toward_opp_goal = toward_opp_goal(dir);
	//判断小车是否在球与对方球门之间
	bool ball_behind_player = ball_away_goal + BALL_SIZE + MAX_ROBOT_SIZE > player_away_goal;
	//判断小球是否运动
	bool ball_moving = (ball_moving_dist < 0.8) ? false : true;
	//判断get_ball_player小车到ball向量角绝对值是否小于75度
	bool player_toward_ball = fabs((ball_pos - get_ball_player).angle() - dir) < (PI / 2 - PI / 12) ? true : false;
	bool direct_get_ball = !ball_moving;
	bool across_ball;
	bool ball_move2target;
	float ball_moving_dir = (ball_pos - last_ball).angle();

	// 小球在当前帧与上一帧的位移  =  球的位置 + 极坐标（球当前帧和上一帧的移动距离，移动方向）转成的二维向量坐标
	point2f ball_with_vel = ball_pos + Maths::polar2vector(ball_moving_dist, ball_moving_dir);

	cout << "--------------球是否在移动:" << ball_moving << " ---------------------" << endl;


	if (!ball_moving){	// 小球没有移动
		cout << "===================================================球没有在移动！！！===================================================" << endl;

		//小球的位移为当前位置
		ball_with_vel = ball_pos;
	}

	//  小球位移后的坐标 指向 robot_id 球员坐标 的向量的角度
	// 这个 变量 没有被用到？？？
	// float ball_to_player_dir = (get_ball_player - ball_with_vel).angle();

	//球车方向(ball - get_ball_player).angle()和小车方向dir的夹角，
	//其中球车方向为小球与小车中心点的矢量方向、小车方向为垂直车头方向
	float ball_player_dir_angle = (ball_pos - get_ball_player).angle() - dir;

	//判断小球是否在吸球嘴附近
	bool ball_beside_player_mouth = (ball_pos - get_ball_player).length() < get_ball_threshold && fabs(ball_player_dir_angle) > 0 && fabs(ball_player_dir_angle) < PI / 6;

	bool is_get_ball = (ball_pos - get_ball_player).length() < 12;

	cout << "--------------拿球球员编号" << get_ball_player << " ---------------------" << endl;
	cout << "--------------球的位置" << ball_pos << " ---------------------" << endl;
	//	cout << "--------------球的上一帧位置" << last_ball << " ---------------------" << endl;
	cout << "--------------持球球员角度" << ball_player_dir_angle << " ---------------------" << endl;

	cout << "------------判断球在吸嘴附近" << ball_beside_player_mouth << " ---------------------" << endl;
	cout << "=================================================== 球的位置到持球球员的距离小于持球阈值，拿球球员角度 pi/6 > dir > 0 ===================================================" << endl;

	if (KICKER_ID == robot_id){	// 如果传入的两个参数相同，则朝向球门GetBall拿球
		cout << "=================================================== 朝向球门拿球 ===================================================" << endl;
		//判断x轴方向get_ball_Player小车与球的位置关系，小车在球上侧，返回true	
		// 换一个说法： 球员比球更接近对方球门 则返回true
		bool ball_x_boundary_right = (ball_pos.x - 2) < get_ball_player.x ? true : false;
		//判断y轴方向get_ball_player小车与球的位置关系，球在robot_id球员的左侧，返回true
		bool ball_y_boundary_right = (ball_pos.y - 2) < get_ball_player.y ? true : false;
#if DEBUG
		if (ball_x_boundary_right)
			cout << "=================================================== x轴方向 球员 比 球 更接近对方球门 ===================================================" << endl;
		else
			cout << "=================================================== x轴方向 球 比 球员 更接近对方球门 ===================================================" << endl;

		if (ball_y_boundary_right)
			cout << "=================================================== y轴方向 球在球员 左侧 ===================================================" << endl;
		else
			cout << "=================================================== y轴方向 球在球员 右侧 ===================================================" << endl;
#endif

		//判断小球与get_ball_player车的位置关系执行拿球
		if (!ball_x_boundary_right){	// 如果球比球员更接近对方球门
			//给robot_id小车设置任务中的目标点坐标，就是让小车跑到某个点，该点以ball_with_vel为极坐标原点  
			// get_ball_buf  拿球缓冲距离
			// 拿球点为：球的位移+沿着 对方球门指向球 方向 球的半径+球员半径 + 拿球缓冲区 长度的位置
			cout << "===================================================球比球员更接近对方球门===================================================" << endl;
			// 到达，从对方球门指向球 的方向 （BALL_SIZE / 2 + MAX_ROBOT_SIZE + get_ball_buf）距离的位置
			//task.needCb = true;
			task.target_pos = ball_with_vel + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + get_ball_buf, opp_goal2ball);

			//			cout << "-----------------------------球员当前位置：" << get_ball_player << "---------------------" << endl;
			cout << "-----------------------------球员移动目的地：" << task.target_pos << "---------------------" << endl;
		}
		else{							// 球员比球更接近对方球门
			cout << "===================================================球员比球更接近对方球门===================================================" << endl;
			if (ball_y_boundary_right){	// 球在球员左边
				//给robot_id小车设置任务中的目标点坐标，直接设置x,y
				// x: 球的位移的x轴 - away_ball_dist_x  TODO: 原因？这个值越大，拿球越平滑
				// TODO: 当球员比球更接近对方球门时拿球的地点计算。
				cout << "===================================================球在球员 左边===================================================" << endl;
				//task.needCb = true;
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y + away_ball_dist_y);		// set 设置位置
			}
			else{						// 球在球员右边
				cout << "===================================================球在球员 右边===================================================" << endl;
				//task.needCb = true;
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y - away_ball_dist_y);
			}
		}
		//task.needCb = true;
		task.orientate = (opp_goal - ball_pos).angle(); // 方向为 球到对方球门的向量的方向
	}
	else				// GetBall球员朝向传球球员 接球
		/**************************************************************************************************/
	{
		cout << "===================================================朝向传球球员接球===================================================" << endl;
		// TODO: 这一句和下面一句不是累赘嘛？
		//判断球与get_ball_palyer、receive_player_pos之间的位置关系，如果x轴方向球在两车下侧，得到true
		bool all_on_ball_x_boundary_left = (ball_pos.x - 2) < get_ball_player.x && (ball_pos.x - 2) < receive_player_pos.x;
		//如果x轴方向球在两车上侧，得到true
		bool all_on_ball_x_boundary_right = (ball_pos.x - 2) > get_ball_player.x && (ball_pos.x - 2) > receive_player_pos.x;

		//判断y轴方向get_ball_player小车与球的位置关系，小车在球右侧，得到true
		bool executer_onball_y_boundary_right = (ball_pos.y - 2) < get_ball_player.y ? true : false;

#if DEBUG
		if (all_on_ball_x_boundary_left)
			cout << "===================================================x轴 方向 球在两车下侧===================================================" << endl;

		if (all_on_ball_x_boundary_right)
			cout << "===================================================x轴 方向 球在两车上侧===================================================" << endl;

		if (!all_on_ball_x_boundary_right && !all_on_ball_x_boundary_left)
			cout << "===================================================x轴 方向 球在两车之间===================================================" << endl;

		if (executer_onball_y_boundary_right)
			cout << "===================================================y轴方向 拿球球员 在球右侧===================================================" << endl;
		else
			cout << "===================================================y轴方向 拿球球员 在球左侧===================================================" << endl;

#endif

		//判断小球与拿球车、接球车之间的位置关系执行拿球
		if (all_on_ball_x_boundary_right){	// x轴方向 球比两球员离对方球门更近
			cout << "===================================================x轴方向 球比两球员离对方球门更近===================================================" << endl;
			if (executer_onball_y_boundary_right){	// y轴方向 球员在球左侧
				//设置task任务目标点坐标
				task.target_pos.set(ball_with_vel.x + away_ball_dist_x, ball_with_vel.y + away_ball_dist_y);
				cout << "===================================================y轴方向 球员在球的左侧===================================================" << endl;
			}
			else{
				task.target_pos.set(ball_with_vel.x + away_ball_dist_x, ball_with_vel.y - away_ball_dist_y);
				cout << "===================================================y轴方向 球员在球的右侧===================================================" << endl;
			}

		}
		else if (all_on_ball_x_boundary_left){	// 两球员离球门更近
			cout << "===================================================两球员离球门更近===================================================" << endl;
			if (executer_onball_y_boundary_right){		// 球员在球的左侧
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y + away_ball_dist_y);
				cout << "===================================================y轴方向 球员在球的右侧===================================================" << endl;
			}
			else{
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y - away_ball_dist_y);
				cout << "===================================================y轴方向 球员在球的右侧===================================================" << endl;
			}

		}
		else{		// 球在两个球员之间
			task.target_pos = ball_with_vel + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + get_ball_buf, receive2ball);
			cout << "===================================================球在两球员之间===================================================" << endl;
		}
		task.orientate = (receive_player_pos - ball_pos).angle();
	}
	/**************************************************************************************************/
	if (ball_beside_player_mouth){
		//执行拿球
		cout << "===================================================球在GetBall球员的吸球嘴附近，执行拿球!!===================================================" << endl;
		task.needCb = true;	// 吸球
		cout << "===================================================开启吸球===================================================" << endl;

		task.target_pos = ball_pos + Maths::polar2vector(9.5, anglemod(dir + PI));
		//		cout << "-------------------------------" << "拿球球员移动目的点" << task.target_pos << "------------------------------------" << endl;
	}

	if (is_get_ball){
		// 踢球
		task.isChipKick = false;
		task.isPass = true;
		task.kickPower = 80;
		task.needKick = true;
		//task.needCb = false;
	}


	return task;

}
