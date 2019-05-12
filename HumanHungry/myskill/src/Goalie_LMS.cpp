/*
ʹ����С���˷���������й켣������ϵķ���ս��

������뵽�󳡾���Ҫ���н䱸����

��� ��ϳ�������˶��켣�� ������������ ��������Ա���� ȥ�����ű�Ե ��װ����

��Goalie.cpp �е� ���Ƿ��ڽ����� is_inside_penalty �ĳ� ���Ƿ��ں�

*/

/*
�������������
1��ǰ�г�����
2��ǰ�г�����
3���󳡴���
4��������
5��������
6�������������
7���������
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

#define FRAME_NUMBER 8		// �Զ���֡������������ �������


extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);


#pragma region ��ȡ��ǰnumber֡�µ�����,���ش洢�����vector<point2f>
/*����һ���洢 �� ��ά����(��������)��vector����*/
vector<point2f> get_ball_points(const WorldModel* model,int number){
	// vector<point2f> �Զ�ά�����㣩�����Ϊ���͵� vector����   
	// һ���洢���ά����������������
	vector<point2f> ball_points;
	ball_points.resize(number);	// ����Ĵ�С��Ϊ8��Ԫ��

	// ���� number �Σ��� number �λ�ȡ�������������� ball_points ����
	for (int i = 0; i < number; i++){
		const point2f& temp_points = model->get_ball_pos(i);
		ball_points.push_back(temp_points);
	}
	return ball_points;
}

#pragma endregion


/*������������������F [k,b]*/
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

	// ��ȡһ��֡���µ��������
	vector<point2f> ball_points = get_ball_points(model,FRAME_NUMBER);

	vector<float> xs;		// �� ��x���� ����
	vector<float> ys;

	// ������
	vector<point2f>::iterator it;
	for (it = ball_points.begin(); it != ball_points.end(); it++){
		//xs.push_back(ball_points[i]);
		xs.push_back((*it).X());	//	�� ball_points �е����е��x���괫��xs����
		ys.push_back((*it).Y());	//  y
	}

	// stage 2 : make matrix

	int len = xs.size();	// x����� ����������

	Eigen::MatrixXd X(len, 2);		// ����X����[x1,1   x2,1   x3,1 ...]
	Eigen::MatrixXd Y(len, 1);		// ����Y����[y1    y2    y3 ...]

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
	// �������λ�ã�����λ��Ԥ�Ʒ����� x = -290


	return task;
}
