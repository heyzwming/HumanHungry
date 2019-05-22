/************************************************************
* ��ͨ���غ����������� NormalDef								*
*															*
* ʵ�ֹ��ܣ� �򵥵��������赲����								*
*															*
* ���������� 												*
*															*
*															*
* ����ֵ��			PlayerTask								*
*															*
* ˵����														*
*															*
************************************************************/

// TODO: Arc  ����

#include "PersonalDef.h"

PlayerTask player_plan(const WorldModel* model, int robot_id){
	//����PlayerTask����task��task������һ�����񷽷�����
	PlayerTask task;

	/***********************************������ȡ*******************************************************/
	const point2f& goal = FieldPoint::Goal_Center_Point;
	const point2f& arc_center_right = FieldPoint::Penalty_Arc_Center_Right;		// (605/2 ,  35/2)���һ��ߵ�Բ��
	const point2f& arc_center_left = FieldPoint::Penalty_Arc_Center_Left;		// (605/2 , -35/2)�����ߵ�Բ��
	const point2f& rectangle_left = FieldPoint::Penalty_Rectangle_Left;			// (-605/2 + 80 , -35/2 )���ľ������߽�
	const point2f& rectangle_right = FieldPoint::Penalty_Rectangle_Right;		// (-605/2 + 80 ,  35/2 )
	const point2f& ball_pos = model->get_ball_pos();


	//areaΪö�ٱ��������ݲ�ͬ��ballλ�ã����ò�ͬ��ö��ֵ
	/***********************************�����y��ֳ��������� [-200,-35/2] [-35/2,35/2] [35/2,200]*************************/
	PenaltyArea area;
	if (ball_pos.y > arc_center_right.y)		// ���y���� �� �һ���Բ�ĵ��ұ�
		area = RightArc;
	else if (ball_pos.y < arc_center_left.y)	// ����Բ�ĵ����
		area = LeftArc;
	else
		area = MiddleRectangle;

	cout << "---------------���x����" << ball_pos.x << "       ���y����" << ball_pos.y << "-------------" << endl;

	//switch���ݲ�ͬ��areaֵ�����ò�ͬ��task
	switch (area)
	{
	case RightArc:
		//����С���ĳ���Ǽ�Ŀ���
		task.orientate = (ball_pos - goal).angle();
		// goal �ҷ��������ĵ�
		task.target_pos = goal + Maths::polar2vector(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R / 2, task.orientate);	// �������ұ߽�80 + �������˰뾶9 + �������ұ߽�80/2

		cout << "*****************************RightArc�Ҳ໡��**********************************" << endl;
		cout << "-----------------------------�����˳���" << task.orientate << "---------------------" << endl;
		cout << "-----------------------------�����˵�Ŀ�ĵ�" << task.target_pos << "-------------------" << endl;
		cout << "-----------------------------ö������area" << area << "-----------------------" << endl;
		cout << "-----------------------------" << "" << "" << endl;


		break;

		//TODO: ��һ�εĴ���ǳ���ʹ�ü�ֵ���� ���Է��� ����켣���������ǽ��������ľ�������
	case MiddleRectangle:
		task.orientate = (ball_pos - goal).angle();

		//across_point(p1, p2, p3, p4)��������p1p2�߶κ�p3p4�߶εĽ���
		task.target_pos = Maths::across_point(rectangle_left, rectangle_right, ball_pos, goal);		// ��� �ҷ��������ľ��β��� �� ����������������  �Ľ��㡣����goalʵ�λ��迼������Ϊ�Է���һ������׼�����������ţ� Ҫͨ����ĵ�ǰ֡����һ֡��λ��������

		cout << "*****************************MiddleRectangle�г���������*****************************" << endl;
		cout << "-----------------------------�����˳���" << task.orientate << "---------------------" << endl;
		cout << "-----------------------------�����˵�Ŀ�ĵ�" << task.target_pos << "-------------------" << endl;
		cout << "-----------------------------ö������area" << area << "-----------------------" << endl;
		cout << "-----------------------------" << "" << "" << endl;

		break;
	case LeftArc:
		task.orientate = (ball_pos - goal).angle();
		task.target_pos = goal + Maths::polar2vector(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R / 2, task.orientate);
		break;
	default:
		break;
	}

	return task;
}