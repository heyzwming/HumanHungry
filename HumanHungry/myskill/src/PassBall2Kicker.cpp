/************************************************************
* �������������� PassBall									*
*															*
* ʵ�ֹ��ܣ� ���� or ����										*
*															*
* ���������� 												*
*															*
*															*
* ����ֵ��			PlayerTask								*
*															*
* ˵����														*
*															*
************************************************************/

// ������չ�� Pass2Kicker   Pass2Rece  Pass2Tier
// ��һ�����ϣ����԰�GetBall.cpp���Ͻ���
// ������ƽ�䴫����Կ��������䴫��

#include "PassBall2Kicker.h"
#include "GetBall.h"
using namespace std;

#define DEBUG 1

// �ж��Ƿ���Դ���
bool is_ready_pass(const point2f& ball, const point2f& passer, const point2f& receiver){
	// ������Ա�����ʸ���Ƕ�
	float receiver_to_ball = (ball - receiver).angle();
	// �򵽴�����Ա��ʸ���Ƕ�
	float ball_to_passer = (passer - ball).angle();

	// ����ʸ���Ƕ�֮��С��ĳ��ֵ���ж��Ƿ���Դ���
	bool pass = fabs(receiver_to_ball - ball_to_passer) < PI / 8;
#if DEBUG

	cout << "------------������Ա����ĽǶȣ�" << receiver_to_ball << "----------------" << endl;
	cout << "------------�򵽴�����Ա�ĽǶȣ�" << ball_to_passer << "-----------------" << endl;

	if (pass)
		cout << "===================================================���Դ���===================================================" << endl;
	else
		cout << "===================================================�����Դ���===================================================" << endl;
#endif
	return pass;
}
// runner_id ������Ա���� reveiver_id ������Ա����
PlayerTask player_plan(const WorldModel* model, int runner_id){
	PlayerTask task;

	//��ȡreveiver_id��Ա���Ӿ���Ϣ
	const PlayerVision& rece_msg = model->get_our_player(KICKER_ID);
	//��ȡrunner_id��Ա���Ӿ���Ϣ
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
	float pass_dir = (receive_head - ball_pos).angle();	// ������  ��ָ�������Ա��ͷ


	// TODO: ����ľ����ж����� ����get_ball_threshold �� �Ƕ��ж�����
	//�ж����Ƿ���Ա��ס���������������֣�1.�ж�ball�����ľ����Ƿ�С��ĳ��ֵ��2.��ͷ����ͳ�����ʸ���Ƕ�֮��ֵ�Ƿ�С��ĳ��ֵ
	bool get_ball = (ball_pos - excute_pos).length() < get_ball_threshold && (fabs(anglemod(excute_dir - (ball_pos - excute_pos).angle())) < PI / 6);

	cout << "-----------------------������Ա����ľ��룺" << (ball_pos - excute_pos).length() << "---------------" << endl;
	cout << "-----------------------������Ա�ĳ����봫����Ա����ĽǶ� �" << fabs(anglemod(excute_dir - (ball_pos - excute_pos).angle())) << "---------------" << endl;

#if DEBUG
	if (get_ball)
		cout << "===================================================���Ѿ�����Ա��ס===================================================" << endl;
	else
		cout << "===================================================��û�б���Ա��ס===================================================" << endl;
#endif

	//���reveiver_id��runner_id��ͬһ������ֱ������
	if (KICKER_ID == runner_id){
		cout << "===================================================��������ͬ��ֱ������===================================================" << endl;
		if (get_ball){		// ����򱻿�ס
			task.orientate = (opp_goal - excute_pos).angle();
			//ִ��ƽ����������Ϊ���127
			task.kickPower = 127;
			//���򿪹�
			task.needKick = true;
			//���򿪹�
			task.isChipKick = false;
			cout << "===================================================�򱻿�ס��ִ�����Ŷ���===================================================" << endl;
			return task;
		}
		else{		// û��ס�� ִ�����򣬲�ָ��Է����ţ��Է����ŵ���ʸ���ĽǶ�
			float opp_goal_to_ball = (ball_pos - opp_goal).angle();
			task.needCb = true;
			// TODO��fast_pass �����С����
			task.target_pos = ball_pos + Maths::polar2vector(fast_pass, opp_goal_to_ball);
			task.orientate = (opp_goal - ball_pos).angle();

			cout << "===================================================��û����ס��ִ��������===================================================" << endl;

			return task;
		}
	}

	//�жϲ�ִ�д���
	if (is_ready_pass(ball_pos, excute_pos, rece_pos)){	// ׼���ô�����

		cout << "===================================================׼���ô�����===================================================" << endl;

		if (get_ball){		// ����õ��������ô��������
			task.kickPower = 50;
			task.needKick = true;
			task.isChipKick = false;
			cout << "===================================================�õ����� ��ʼ���򣡣�===================================================" << endl;
		}
		task.target_pos = ball_pos + Maths::polar2vector(fast_pass, rece_to_ball);
	}
	else{		// û��׼���ô�����ı�λ��		Ŀ��λ�ø�Ϊ  ������� + �����꣨��İ뾶 + ��Ա�뾶��������Աָ����ķ���  ��ת�ɵĶ�ά��������
		cout << "===================================================��û��׼���ô���,ִ������===================================================" << endl;
		task.target_pos = ball_pos + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + 2, rece_to_ball);
	}
	task.orientate = pass_dir;		//pass_dir = (receive_head - ball).angle();
	//flag = 1��ʾС�����ٶ�*2
	task.flag = 1;
	return task;
}


