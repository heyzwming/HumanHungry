
// �������Ա����
// �費��ҪGetBall�����������˺�����...
// ���Խ������ܺ�Ч��
// ��������boolֵ������ô�ã�close_receiver   head_toward_ball    ball_moveto_head

#include "ReceiveBallFromGoalie.h"
#include "GetBall.h"

#define DEBUG 1

PlayerTask player_plan(const WorldModel* model, int runner_id){
	PlayerTask task;

	//������Ҫ�Ĳ���
	const point2f& ball_pos = model->get_ball_pos();
	const point2f& ball_vel = model->get_ball_vel();											// ��ó�����Ա����Ϣ 
	const point2f& receiver_pos = model->get_our_player_pos(runner_id);						// ��ý�����Ա��λ�� 
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	const float& receiver_dir = model->get_our_player_dir(runner_id);					// �����˶�Ա�ĳ��� 
	point2f reciver_head = receiver_pos + Maths::polar2vector(ROBOT_HEAD, receiver_dir);	// ������Ա��ͷ������

	bool close_receiver = (receiver_pos - ball_pos).length() < 80;
	bool head_toward_ball = false;
	bool ball_moveto_head = false;

	head_toward_ball = fabs(anglemod((ball_pos - reciver_head).angle() - receiver_dir)) < PI / 8;
	ball_moveto_head = fabs(anglemod((reciver_head - ball_pos).angle() - ball_vel.angle())) < PI / 8;
	float angle = ball_vel.angle();

	//	cout << "--------------����˶��Ƕȣ�" << angle << "------------------" << endl;

#if DUBUG
	if (close_receiver)
		cout << "=======================================���Ѿ��ӽ�������Ա�ˣ���==========================" << endl;
	else
		cout << "=======================================������Ա����Զ��=======================" << endl;

	if (head_toward_ball)
		cout << "=======================================��Ա��ͷ��������============================" << endl;
	else
		cout << "=======================================��Ա����û�г�������==============================" << endl;

	if (ball_moveto_head)
		cout << "=======================================���������Ա�ƶ�====================" << endl;
	else
		cout << "=======================================��û���������Ա�ƶ�====================" << endl;
#endif

	/********************************���������ľ���С��30  ȥgetball********************************/
	if (close_receiver){
		task = get_ball_plan(model, runner_id, GOALIE_ID);
		return task;
	}


	//line_perp_across(ball_pos, ball_vel.angle(), receiver_pos), ���� receiver_pos��ball_posΪ��㣬ball_vel.angle()Ϊб�ʵ�ֱ��������ĵ�
	point2f task_point = Maths::line_perp_across(ball_pos, ball_vel.angle(), receiver_pos);

	cout << "--------------------------����㣺" << task_point << "-----------------------" << endl;

	task.needCb = true;
	task.orientate = (ball_pos - receiver_pos).angle();
	task.target_pos = receiver_pos;

	/*
	if (close_receiver&&!head_toward_ball&&!ball_moveto_head){
	GetBall get_ball;
	task = get_ball.plan(runner_id, runner_id);
	return task;
	}
	*/

	return task;
}