/*
使用最小二乘法将球的运行轨迹线性拟合的防守战术

当球进入到后场就需要进行戒备防守

如果 拟合出的球的运动轨迹会 滚出防守区域 则让守门员依旧 去到球门边缘 假装防守

把Goalie.cpp 中的 球是否在禁区内 is_inside_penalty 改成 球是否在后场

*/

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


//#include "Goalie_LMS.h"

#include <string>
#include <iostream>
#include <fstream>
#include <vector>

// Eigen
#include "Eigen/Core"
#include "Eigen/Dense"
#include "Eigen/Geometry"

// Soccor
#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/worldmodel.h"
#include "GetBall.h"
using namespace std;

#define FRAME_NUMBER 8		// 对多少帧的球的坐标进行 线性拟合
#define DEFENCE_POS_X -300


namespace{
	float goalie_penalty_def_buf = 20;
}

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

// TODO: 怎么过滤 线性拟合的 噪声？（射门前的坐标 所 产生的噪声）

#pragma region 获取球前frame帧下的坐标,返回存储坐标的vector<point2f>
/*返回一个存储 球 二维坐标(浮点类型)的vector向量*/
vector<point2f> get_ball_points(const WorldModel* model,int frame){
	// vector<point2f> 以二维（浮点）坐标点为类型的 vector向量   
	// 一个存储球二维浮点型坐标点的数组
	vector<point2f> ball_points;
	ball_points.resize(frame);	// 数组的大小改为个frame元素

	// 迭代 frame 次，将 frame 次获取到的球的坐标存入 ball_points 向量
	for (int i = 0; i < frame; i++){
		// get_ball_pos 获得小球当前图像帧坐标位置
		// 重点：小球的坐标信息都以图像帧为最小单位从视觉机接收并存储，可以把球坐标看成是一个个数组，数组索引是图像帧号，数组元素是坐标信息
		const point2f& temp_points = model->get_ball_pos(i);
		ball_points.push_back(temp_points);
	}
	return ball_points;
}

#pragma endregion

#pragma region LSM 传入坐标向量，返回F [k,b] x=ky+b

Eigen::MatrixXd LSM(const WorldModel* model, vector<point2f> ball_points){
	vector<float> xs;		// 球 的x坐标 集合
	vector<float> ys;

	// 迭代器
	vector<point2f>::iterator it;
	for (it = ball_points.begin(); it != ball_points.end(); it++){
		//xs.push_back(ball_points[i]);
		xs.push_back((*it).X());	//	将 ball_points 中的所有点的x坐标传入xs向量
		ys.push_back((*it).Y());	//  y
	}

	// stage 1 : make matrix

	int len = ys.size();	// y坐标的 向量的行数

	Eigen::MatrixXd Y(len, 2);		// 构造Y矩阵，[y1,1   y2,1   y3,1 ...]
	Eigen::MatrixXd X(len, 1);		// 构造X矩阵，[x1    x2    x3 ...]

	for (int i = 0; i < len; i++)
	{
		Y(i, 0) = ys[i];
		Y(i, 1) = 1;

		X(i, 0) = xs[i];
	}
	Eigen::MatrixXd F(2, 1);		// [k  ,  b]   x = ky + b

	// stage 2 : LSM
	F = (Y.transpose() * Y).inverse() * Y.transpose() * X;
	return F;
}

#pragma endregion

#pragma region 判断球是否在禁区内,bool
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

#pragma region 判断球是否在后场,bool
// 判断球是否在后场
bool is_inside_backcourt(const point2f& ball){
	// 球的y坐标在  -605/2 < ball.y < -180
	if (ball.y < BACK_COURT && ball.y > -FIELD_LENGTH_H)		// 在后场
		return true;
	else
		return false;
}
#pragma endregion

#pragma region 获得对方持球球员编号
//获得对方持球球员编号 
int opp_get_player(const WorldModel* model){

	int opp_player_id = -1;	// 初始化对方持球球员编号为-1

	const bool* exist_id = model->get_opp_exist_id();	// 布尔数组  获得在场球员的编号 
	// TODO: our_goal 可以修改
	const point2f& our_goal = FieldPoint::Goal_Center_Point;
	float dist = 9999;

	// TODO: 思考 如果把离球最近的球员当做持球球员来防守可行吗？？
	// MAX_ROBOTS : 场上最多的球员数
	// 获得对方持球球手编号
	for (int i = 0; i < MAX_ROBOTS; i++){
		if (exist_id[i]){		
			// 距离球的距离最近  且 小于一定值的球员   认为是对方持球球员
			const point2f& player_pos = model->get_opp_player_pos(i);
			// TODO: 把our_goal改成 通过拟合求出的截球守门点
			float goal_opp_dist = (player_pos - our_goal).length();
			if (goal_opp_dist < dist){
				dist = goal_opp_dist;
				opp_player_id = i;
			};
		}
	}
	return opp_player_id;
}
#pragma endregion

#pragma region 计算防守位置
//计算防守位置
point2f def_pos(const WorldModel* model, Eigen::MatrixXd  F){


	/* 守门员初始点位 */
	float stayX = -300;	// 守门初始点x		
	float stayY = 0;	// 

	/* 获得 当前帧ball 和上一帧last_ball 小球坐标 */
	float def_pos_x = DEFENCE_POS_X;
	float def_pos_y = (DEFENCE_POS_X - F(1,0)) / F(0,0);
	
	return point2f(def_pos_x, def_pos_y);
}
#pragma endregion

#pragma region penatly
/*
PlayerTask penaltydef_plan(const WorldModel* model, int robot_id){
	PlayerTask task;

	int opp_kicker = opp_get_player(model);	// 对方点球球员编号
	const point2f& ball = model->get_ball_pos();
	const point2f& our_goal = FieldPoint::Goal_Center_Point;

	if (opp_kicker == -1) { // 没有检测到对方点球球员  直接返回task
		task.target_pos = our_goal + point2f(10, 0);
		task.orientate = (task.target_pos - our_goal).angle();
		cout << "no opp penalty kicker" << endl;
		return task;
	}
	const point2f& penalty_kicker = model->get_opp_player_pos(opp_kicker);	// 获得对方点球球员编号
	float opp_dir = model->get_opp_player_dir(opp_kicker);					// 对方点球球员的角度

	//	task = gotoPos(model, -605 / 2, 0.0, (ball - model->get_our_player_pos(our_penalty_player(model))).angle());	// 4 我方守门员编号
	printf("***********************log**************");
	task.target_pos = def_pos(model, penalty_kicker, opp_dir);		// 计算防守位置
	task.orientate = (ball - task.target_pos).angle();
	return task;
}
*/
#pragma endregion 


PlayerTask player_plan(const WorldModel* model, int robot_id)
{
	PlayerTask task;
	cout << "*******************Hello**********************" << endl;
	//执行守门员防守需要的参数
	const point2f& goalie_pos = model->get_our_player_pos(robot_id);
	// 获得小球当前图像帧坐标位置
	// 重点：小球的坐标信息都以图像帧为最小单位从视觉机接收并存储，可以把球坐标看成是一个个数组，数组索引是图像帧号，数组元素是坐标信息
	const point2f& ball_pos = model->get_ball_pos();
	//获得小球当前帧的上一帧图像坐标信息
	const point2f& last_ball = model->get_ball_pos(1);
	const float player_dir = model->get_our_player_dir(robot_id);

	// TODO：这一行的变量 goal 导致了守门员只会防守球门的中心点，这个goal需要通过持球球员的角度 延伸出的方向向量 来计算
	const point2f& goal = FieldPoint::Goal_Center_Point;	// 己方球门中心点
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;	// 己方球门中心点

	/***********************************************************/

	bool ball_inside_penalty = is_inside_penalty(ball_pos);
	bool ball_inside_backcourt = is_inside_backcourt(ball_pos);

	//获得球当前坐标到上一坐标位置向量的长度
	float ball_moving_dist = (ball_pos - last_ball).length();
	//判断小球是否运动
	bool ball_is_moving = (ball_moving_dist < 0.8) ? false : true;

	/**********************************************************/

	if (ball_inside_penalty){	/* 判断球在禁区 */

		/* 如果球在禁区停止了，把球挑射除去 然后 return task */
		if (!ball_is_moving){
			task.orientate = (ball_pos - goalie_pos).angle();	// 朝向对方球门的方向
			task.target_pos = ball_pos + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE - 2, task.orientate);	//TODO:Problem
			task.kickPower = 127;		// 踢球力度
			task.chipKickPower = 127;	// 挑球力度
			task.needKick = true;		// 踢球执行开关
			task.isChipKick = true;		// 挑球开关
			return task;
		}

		// TODO: 考虑 如果 球没有被球员踢出，而是被球员控住转换方向 ，如何消除这种情况这线性拟合的 噪声误差？ 用 ball_is_moving 来判断
		// 如果球被踢出
		/*球在禁区中 仍在移动*/

		/* 获得 存储球的坐标的向量 */
		vector<point2f> ball_points = get_ball_points(model, FRAME_NUMBER);
		/* 获得球的拟合直线 向量F[k,b] */
		Eigen::MatrixXd F = LSM(model, ball_points);
		/* 计算截球点,传入model和拟合直线 */
		point2f& def_goal = def_pos(model, F);
		/* 如果球的方向偏出球门 */
		int convert = def_goal.Y() > 0 ? 1 : -1;
		// 若球不可能射入球门，则让守门员向球门边缘移动
		if (def_goal.Y() > 35 / 2 || def_goal.Y() < -35 / 2)
			def_goal.set_y(30 / 2 * convert);
		/* 截球 */
		// 如果吸到球  挑射鹅鹅鹅
		// 判断小球在控球嘴上执行挑球（通过距离和方向判断）
		// TODO: BALL_SIZE 是多少？球的实际直径为4.3cm   MAX_ROBOT_SIZE 为8.5cm   具体的值还需要考虑
		if ((ball_pos - goalie_pos).length() < BALL_SIZE / 2 + MAX_ROBOT_SIZE + 2 && (anglemod(player_dir - (ball_pos - goalie_pos).angle()) < PI / 8))
		{
			task.kickPower = 127;		// 踢球力度
			task.chipKickPower = 127;	// 挑球力度
			task.needKick = true;		// 踢球执行开关
			task.isChipKick = true;		// 挑球开关
		}
//		else{ // 没有吸到球  去到截球点
			task.orientate = (ball_pos - goalie_pos).angle();
			task.target_pos = def_goal;
//		}
	}
	else if (ball_inside_backcourt){	/* 判断球在后场 */
		if (ball_is_moving){

			/* 计算防守地点 */


			/* 获得 存储球的坐标的向量 */
			vector<point2f> ball_points = get_ball_points(model, FRAME_NUMBER);
			/* 获得球的拟合直线 向量F[k,b] */
			Eigen::MatrixXd F = LSM(model, ball_points);
			/* 计算截球点,传入model和拟合直线 */
			point2f& def_goal = def_pos(model, F);
			/* 如果球的方向偏出球门 */
			int convert = def_goal.Y() > 0 ? 1 : -1;
			// 若球不可能射入球门，则让守门员向球门边缘移动
			if (def_goal.Y() > 35 || def_goal.Y() < -35)
				def_goal.set_y(30 * convert);

			/*朝向球的方向但是不做任何动作*/

			task.orientate = (ball_pos - goalie_pos).angle();

		}
	}
	else{	/* 球在前中场 */
		task.orientate = (ball_pos - goalie_pos).angle();
		task.target_pos = goal + Maths::polar2vector(20, task.orientate);
	}


	return task;
}
