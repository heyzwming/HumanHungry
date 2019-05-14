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

/*
��Ҫ��
1��������Ա�ı��
2��������Ա�ĽǶ�

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
#define DEFENCE_POS_X -300


namespace{
	float goalie_penalty_def_buf = 20;
}

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

// TODO: ��ô���� ������ϵ� ������������ǰ������ �� ������������

#pragma region ��ȡ��ǰframe֡�µ�����,���ش洢�����vector<point2f>
/*����һ���洢 �� ��ά����(��������)��vector����*/
vector<point2f> get_ball_points(const WorldModel* model,int frame){
	// vector<point2f> �Զ�ά�����㣩�����Ϊ���͵� vector����   
	// һ���洢���ά����������������
	vector<point2f> ball_points;
	ball_points.resize(frame);	// ����Ĵ�С��Ϊ��frameԪ��

	// ���� frame �Σ��� frame �λ�ȡ�������������� ball_points ����
	for (int i = 0; i < frame; i++){
		// get_ball_pos ���С��ǰͼ��֡����λ��
		// �ص㣺С���������Ϣ����ͼ��֡Ϊ��С��λ���Ӿ������ղ��洢�����԰������꿴����һ�������飬����������ͼ��֡�ţ�����Ԫ����������Ϣ
		const point2f& temp_points = model->get_ball_pos(i);
		ball_points.push_back(temp_points);
	}
	return ball_points;
}

#pragma endregion

#pragma region LSM ������������������F [k,b] x=ky+b

Eigen::MatrixXd LSM(const WorldModel* model, vector<point2f> ball_points){
	vector<float> xs;		// �� ��x���� ����
	vector<float> ys;

	// ������
	vector<point2f>::iterator it;
	for (it = ball_points.begin(); it != ball_points.end(); it++){
		//xs.push_back(ball_points[i]);
		xs.push_back((*it).X());	//	�� ball_points �е����е��x���괫��xs����
		ys.push_back((*it).Y());	//  y
	}

	// stage 1 : make matrix

	int len = ys.size();	// y����� ����������

	Eigen::MatrixXd Y(len, 2);		// ����Y����[y1,1   y2,1   y3,1 ...]
	Eigen::MatrixXd X(len, 1);		// ����X����[x1    x2    x3 ...]

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

#pragma region �ж����Ƿ��ڽ�����,bool
// �ж����Ƿ��ڽ�����
bool is_inside_penalty(const point2f& ball){
	// leftΪ������뻡��Բ�ģ�-605/2��-35/2����rightΪ�����Ұ뻡��Բ�ģ�-605/2��35/2��
	const point2f& left = FieldPoint::Penalty_Arc_Center_Left;
	const point2f& right = FieldPoint::Penalty_Arc_Center_Right;

	// ��������ǰ�Ľ����ĳ���Ϊ35��ֱ���� -35/2 < p.y < 35/2
	if (fabs(ball.y) < PENALTY_AREA_L / 2)		// �ڽ�������������
		// -605/2 < p.x < -605/2 + 80 
		return ball.x < -FIELD_LENGTH_H + PENALTY_AREA_R && ball.x > -FIELD_LENGTH_H;	//PENALTY_AREA_R=80  FIELD_LENGTH_H = 605/2
	else if (ball.y < PENALTY_AREA_L / 2)		// ���� ���벿�� 
		// �����Ÿ����1/4����Բ�� �ľ��� < 80 �� ���x���� > (-605/2)
		return (ball - left).length() < PENALTY_AREA_R && ball.x > -FIELD_LENGTH_H;
	else									// ������ ���벿�� 
		return (ball - right).length() < PENALTY_AREA_R && ball.x > -FIELD_LENGTH_H;
}
#pragma endregion

#pragma region �ж����Ƿ��ں�,bool
// �ж����Ƿ��ں�
bool is_inside_backcourt(const point2f& ball){
	// ���y������  -605/2 < ball.y < -180
	if (ball.y < BACK_COURT && ball.y > -FIELD_LENGTH_H)		// �ں�
		return true;
	else
		return false;
}
#pragma endregion

#pragma region ��öԷ�������Ա���
//��öԷ�������Ա��� 
int opp_get_player(const WorldModel* model){

	int opp_player_id = -1;	// ��ʼ���Է�������Ա���Ϊ-1

	const bool* exist_id = model->get_opp_exist_id();	// ��������  ����ڳ���Ա�ı�� 
	// TODO: our_goal �����޸�
	const point2f& our_goal = FieldPoint::Goal_Center_Point;
	float dist = 9999;

	// TODO: ˼�� ����������������Ա����������Ա�����ؿ����𣿣�
	// MAX_ROBOTS : ����������Ա��
	// ��öԷ��������ֱ��
	for (int i = 0; i < MAX_ROBOTS; i++){
		if (exist_id[i]){		
			// ������ľ������  �� С��һ��ֵ����Ա   ��Ϊ�ǶԷ�������Ա
			const point2f& player_pos = model->get_opp_player_pos(i);
			// TODO: ��our_goal�ĳ� ͨ���������Ľ������ŵ�
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

#pragma region �������λ��
//�������λ��
point2f def_pos(const WorldModel* model, Eigen::MatrixXd  F){


	/* ����Ա��ʼ��λ */
	float stayX = -300;	// ���ų�ʼ��x		
	float stayY = 0;	// 

	/* ��� ��ǰ֡ball ����һ֡last_ball С������ */
	float def_pos_x = DEFENCE_POS_X;
	float def_pos_y = (DEFENCE_POS_X - F(1,0)) / F(0,0);
	
	return point2f(def_pos_x, def_pos_y);
}
#pragma endregion

#pragma region penatly
/*
PlayerTask penaltydef_plan(const WorldModel* model, int robot_id){
	PlayerTask task;

	int opp_kicker = opp_get_player(model);	// �Է�������Ա���
	const point2f& ball = model->get_ball_pos();
	const point2f& our_goal = FieldPoint::Goal_Center_Point;

	if (opp_kicker == -1) { // û�м�⵽�Է�������Ա  ֱ�ӷ���task
		task.target_pos = our_goal + point2f(10, 0);
		task.orientate = (task.target_pos - our_goal).angle();
		cout << "no opp penalty kicker" << endl;
		return task;
	}
	const point2f& penalty_kicker = model->get_opp_player_pos(opp_kicker);	// ��öԷ�������Ա���
	float opp_dir = model->get_opp_player_dir(opp_kicker);					// �Է�������Ա�ĽǶ�

	//	task = gotoPos(model, -605 / 2, 0.0, (ball - model->get_our_player_pos(our_penalty_player(model))).angle());	// 4 �ҷ�����Ա���
	printf("***********************log**************");
	task.target_pos = def_pos(model, penalty_kicker, opp_dir);		// �������λ��
	task.orientate = (ball - task.target_pos).angle();
	return task;
}
*/
#pragma endregion 


PlayerTask player_plan(const WorldModel* model, int robot_id)
{
	PlayerTask task;
	cout << "*******************Hello**********************" << endl;
	//ִ������Ա������Ҫ�Ĳ���
	const point2f& goalie_pos = model->get_our_player_pos(robot_id);
	// ���С��ǰͼ��֡����λ��
	// �ص㣺С���������Ϣ����ͼ��֡Ϊ��С��λ���Ӿ������ղ��洢�����԰������꿴����һ�������飬����������ͼ��֡�ţ�����Ԫ����������Ϣ
	const point2f& ball_pos = model->get_ball_pos();
	//���С��ǰ֡����һ֡ͼ��������Ϣ
	const point2f& last_ball = model->get_ball_pos(1);
	const float player_dir = model->get_our_player_dir(robot_id);

	// TODO����һ�еı��� goal ����������Աֻ��������ŵ����ĵ㣬���goal��Ҫͨ��������Ա�ĽǶ� ������ķ������� ������
	const point2f& goal = FieldPoint::Goal_Center_Point;	// �����������ĵ�
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;	// �����������ĵ�

	/***********************************************************/

	bool ball_inside_penalty = is_inside_penalty(ball_pos);
	bool ball_inside_backcourt = is_inside_backcourt(ball_pos);

	//�����ǰ���굽��һ����λ�������ĳ���
	float ball_moving_dist = (ball_pos - last_ball).length();
	//�ж�С���Ƿ��˶�
	bool ball_is_moving = (ball_moving_dist < 0.8) ? false : true;

	/**********************************************************/

	if (ball_inside_penalty){	/* �ж����ڽ��� */

		/* ������ڽ���ֹͣ�ˣ����������ȥ Ȼ�� return task */
		if (!ball_is_moving){
			task.orientate = (ball_pos - goalie_pos).angle();	// ����Է����ŵķ���
			task.target_pos = ball_pos + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE - 2, task.orientate);	//TODO:Problem
			task.kickPower = 127;		// ��������
			task.chipKickPower = 127;	// ��������
			task.needKick = true;		// ����ִ�п���
			task.isChipKick = true;		// ���򿪹�
			return task;
		}

		// TODO: ���� ��� ��û�б���Ա�߳������Ǳ���Ա��סת������ ������������������������ϵ� ������ �� ball_is_moving ���ж�
		// ������߳�
		/*���ڽ����� �����ƶ�*/

		/* ��� �洢������������ */
		vector<point2f> ball_points = get_ball_points(model, FRAME_NUMBER);
		/* ���������ֱ�� ����F[k,b] */
		Eigen::MatrixXd F = LSM(model, ball_points);
		/* ��������,����model�����ֱ�� */
		point2f& def_goal = def_pos(model, F);
		/* �����ķ���ƫ������ */
		int convert = def_goal.Y() > 0 ? 1 : -1;
		// ���򲻿����������ţ���������Ա�����ű�Ե�ƶ�
		if (def_goal.Y() > 35 / 2 || def_goal.Y() < -35 / 2)
			def_goal.set_y(30 / 2 * convert);
		/* ���� */
		// ���������  �������
		// �ж�С���ڿ�������ִ������ͨ������ͷ����жϣ�
		// TODO: BALL_SIZE �Ƕ��٣����ʵ��ֱ��Ϊ4.3cm   MAX_ROBOT_SIZE Ϊ8.5cm   �����ֵ����Ҫ����
		if ((ball_pos - goalie_pos).length() < BALL_SIZE / 2 + MAX_ROBOT_SIZE + 2 && (anglemod(player_dir - (ball_pos - goalie_pos).angle()) < PI / 8))
		{
			task.kickPower = 127;		// ��������
			task.chipKickPower = 127;	// ��������
			task.needKick = true;		// ����ִ�п���
			task.isChipKick = true;		// ���򿪹�
		}
//		else{ // û��������  ȥ�������
			task.orientate = (ball_pos - goalie_pos).angle();
			task.target_pos = def_goal;
//		}
	}
	else if (ball_inside_backcourt){	/* �ж����ں� */
		if (ball_is_moving){

			/* ������صص� */


			/* ��� �洢������������ */
			vector<point2f> ball_points = get_ball_points(model, FRAME_NUMBER);
			/* ���������ֱ�� ����F[k,b] */
			Eigen::MatrixXd F = LSM(model, ball_points);
			/* ��������,����model�����ֱ�� */
			point2f& def_goal = def_pos(model, F);
			/* �����ķ���ƫ������ */
			int convert = def_goal.Y() > 0 ? 1 : -1;
			// ���򲻿����������ţ���������Ա�����ű�Ե�ƶ�
			if (def_goal.Y() > 35 || def_goal.Y() < -35)
				def_goal.set_y(30 * convert);

			/*������ķ����ǲ����κζ���*/

			task.orientate = (ball_pos - goalie_pos).angle();

		}
	}
	else{	/* ����ǰ�г� */
		task.orientate = (ball_pos - goalie_pos).angle();
		task.target_pos = goal + Maths::polar2vector(20, task.orientate);
	}


	return task;
}
