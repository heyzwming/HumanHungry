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


extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);


#pragma region 获取球前number帧下的坐标,返回存储坐标的vector<point2f>
/*返回一个存储 球 二维坐标(浮点类型)的vector向量*/
vector<point2f> get_ball_points(const WorldModel* model,int number){
	// vector<point2f> 以二维（浮点）坐标点为类型的 vector向量   
	// 一个存储球二维浮点型坐标点的数组
	vector<point2f> ball_points;
	ball_points.resize(number);	// 数组的大小改为8个元素

	// 迭代 number 次，将 number 次获取到的球的坐标存入 ball_points 向量
	for (int i = 0; i < number; i++){
		const point2f& temp_points = model->get_ball_pos(i);
		ball_points.push_back(temp_points);
	}
	return ball_points;
}

#pragma endregion


/*传入坐标向量，返回F [k,b]*/
#pragma region LSM

Eigen::MatrixXd LSM(){

	return F;
}

#pragma endregion




PlayerTask player_plan(const WorldModel* model, int robot_id)
{
	PlayerTask task;
	cout << "**********************Hello************************" << endl;

	// stage 1 : import data

	// 获取一定帧数下的球的坐标
	vector<point2f> ball_points = get_ball_points(model,FRAME_NUMBER);

	vector<float> xs;		// 球 的x坐标 集合
	vector<float> ys;

	// 迭代器
	vector<point2f>::iterator it;
	for (it = ball_points.begin(); it != ball_points.end(); it++){
		//xs.push_back(ball_points[i]);
		xs.push_back((*it).X());	//	将 ball_points 中的所有点的x坐标传入xs向量
		ys.push_back((*it).Y());	//  y
	}

	// stage 2 : make matrix

	int len = xs.size();	// x坐标的 向量的行数

	Eigen::MatrixXd X(len, 2);		// 构造X矩阵，[x1,1   x2,1   x3,1 ...]
	Eigen::MatrixXd Y(len, 1);		// 构造Y矩阵，[y1    y2    y3 ...]

	for (int i = 0; i < len; i++)
	{
		X(i, 0) = xs[i];
		X(i, 1) = 1.;

		Y(i, 0) = ys[i];
	}

	// stage 3 : LMS

	Eigen::MatrixXd F(2, 1);		// [k  ,  b]   y = kx + b
	F = (X.transpose() * X).inverse() * X.transpose() * Y;
	cout << "F" << endl;
	cout << F << endl;

	// stage 4 : defence position
	// 计算防守位置，防守位置预计放置于 x = -290


	return task;
}
