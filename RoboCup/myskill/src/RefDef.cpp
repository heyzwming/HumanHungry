/************************************************************
* 常规防守函数名： ReceiveBall								*
*															*
* 实现功能： 前锋和中场的常规防守战术							*
*															*
* 具体描述：													*
*															*
*															*
* 返回值：			PlayerTask								*
*															*
* 说明：														*
*															*
************************************************************/

#include "RefDef.h"
//#include "utils/singleton.h"

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int id, string role);
enum BallArea
{
	Left,
	Middle,
	Right
};

PlayerTask player_plan(const WorldModel* model, int id, string role){	// role 传入的参数  执行该.dll的角色名
	PlayerTask task;
	//防守需要的参数
	const point2f& goal_center = FieldPoint::Goal_Center_Point;
	const point2f& arc_center_right = FieldPoint::Penalty_Arc_Center_Right;
	const point2f& arc_center_left = FieldPoint::Penalty_Arc_Center_Left;
	const point2f& ball = model->get_ball_pos();
	const point2f& ref_player = model->get_our_player_pos(id);
	const point2f& opp_goal = -goal_center;
	
	const float ref_dir = model->get_our_player_dir(id);
	const float ball_to_goal_dir = (goal_center - ball).angle();
	
	const Vehicle* opp_tem = model->get_opp_team();
	
	const bool* exist_id = model->get_opp_exist_id();
	
	// TODO: 如果后面改成了 < 号 那这个dist的初始值应该设为很大
	//float dist = 0;
	float dist = 9999;

	int opp_hold_ball_player =-1;		// 对方拿球球员
	
	//在for循环中找出拿球的对方球员车号 赋值给opp_hold_ball_player
	for (int i = 0; i < MAX_ROBOTS; i++){	
		if (exist_id[i]){		// 该号码球员存在
			const point2f& opp_player_pos = model->get_opp_player_pos(i);
			if ((opp_player_pos - opp_goal).length() < PENALTY_AREA_R)	// 如果对方球员的位置 到 对方球门的距离 小于 禁区半径PENALTY_AREA_R 80	   即跳过对方守门员
				continue;
			else	// 该球员不是守门员
			{	
				float player_ball_dist = (ball - opp_player_pos).length();	// 球和对方球员的距离
				// 如果对方球员与球的距离 大于 dist（初始为0） 则更新dist和opp_hold_ball_player（球员号码）
				// TODO: 这里应该是<号吧？  当球和球员的距离小于dist 这时候才更新dist和持球球员的编号
				//if (player_ball_dist > dist){
				if (player_ball_dist < dist){
					dist = player_ball_dist;
					opp_hold_ball_player = i;
				}		
			}
		}
	}

	if (opp_hold_ball_player == -1) cout << " warning no opp robots receive ball" << endl;
	
	// 对方拿球球员的坐标
	const point2f& opp_hold_ball_player_pos = model->get_opp_player_pos(opp_hold_ball_player);
	//得到对方拿球小车到我球门角度
	float opp_receive_goal = (goal_center - opp_hold_ball_player_pos).angle();

	BallArea area;	// left  middle  right	左半场 中半场 右半场

	if (ball.y + 2  > arc_center_right.y)
		area = Right;
	else if (ball.y + 2 < arc_center_left.y)
		area = Left;
	else
		area = Middle;

	bool have_enough_dist = false;
	float dist_threshold = MAX_ROBOT_SIZE + PENALTY_AREA_R;	// threshold 阈值

	switch (area)
	{
	case Left:
		// arc_center_left  己方 禁区 左侧弧线的底线
		// 如果 球到己方球门底线的距离-Stop_Dist  大于了一个阈值 则 认为有足够的距离
		if ((ball - arc_center_left).length() - RuleParam::Stop_Dist > dist_threshold)
			have_enough_dist = true;
		break;
	case Middle:
		if ((ball - goal_center).length() - RuleParam::Stop_Dist > dist_threshold)
			have_enough_dist = true;
		break;
	case Right:
		if ((ball - arc_center_right).length() - RuleParam::Stop_Dist > dist_threshold)
			have_enough_dist = true;
		break;
	default:
		break;
	}

	//前锋Kicker的防守，卡住对方拿球小车射门方向
	if (role == "Kicker"){		// 前锋Kicker的防守战术
		// 目标点为 对方拿球球员 + 极坐标（Stop_Dist*2 (即50 * 2) ，对方拿球球员到我方球门角度 ）转二维向量
		task.target_pos = opp_hold_ball_player_pos + Maths::polar2vector(RuleParam::Stop_Dist*2, opp_receive_goal);
		task.orientate = anglemod(opp_receive_goal + PI);
	}
	
	//中场Receiver的防守，卡住小球射门方向
	else if (role == "Receiver"){		// 中场球员Receiver的防守战术
		if (have_enough_dist){	// 如果仍然有充足的距离，
			task.target_pos = ball + Maths::polar2vector(RuleParam::Stop_Dist, ball_to_goal_dir);
			task.orientate = anglemod(ball_to_goal_dir + PI);
		}else{			// 没有充足的距离了
			float goal_to_ball_dir = (ball - goal_center).angle();
			task.target_pos = goal_center + Maths::polar2vector(95,goal_to_ball_dir);
			task.orientate = goal_to_ball_dir;
		}
	}else{	// role 既不是 Kicker 也不是 Receiver
		// TODO: ??
		task.target_pos = ref_player;
		task.orientate = ref_dir;
		cout << "not have" << role << "algorithm!!!!!!!!!" << endl;
	}
	return task;
}