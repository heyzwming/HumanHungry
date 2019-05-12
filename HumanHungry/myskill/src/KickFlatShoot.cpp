/*
ƽ��dll��:�����ֻ����lua��Ҫ��ĳ��Ա���ŵ�ʱ����ִ�е����ſ⣬�����ڿ�����Ҫ������Ա�ķ���վλ�ͽǶȽ��з�������Ϊlua����п��ܻ���Բ��ò����ŵ�״����

ƽ��Ķ��������
1���Է������� û������Ա
2������Ա��������Ա��ͬ��
3������Ա��������Ա�����
4������Ա�������м�����
5������Ա�Ķ���״̬��1�����������泯��ķ��򣨽Ƕ�ԼΪ[-pi/4,pi/4]��
				   2�������ű�Ե��ס���ţ��Ƕ�ԼΪ[-pi/2,-5pi/6] & [5pi/6,pi/2]


�������	1��opp_goal �����ŷ��� �ļ�������
		2���Է�����Ա��վλ����
		3������ǰ�Ķ���


�����ϣ������Ķ������ƺ�״̬
*/

#include "KickFlatShoot.h"
#include "GetBall.h"

#define DEBUG 1		// Ϊ1ʱ Ϊdebugģʽ

// ����GetBall����غ���,����Է������õ���
PlayerTask do_chase_ball(const WorldModel* model, int runner_id){

	// get_ball_plan ����ĳ����ɫ����
	// ��һ������ runner_id : ����ִ���� / ������Ա
	// �ڶ������� receiver_id : ���� ��Ա
	// �� ����������ͬ �������Ž���
	return get_ball_plan(model, runner_id, runner_id);
}

/*
�����Աλ�úͳ������λ�ã�
�����򿪹أ�
�ж����Ƿ���Ա����ס���������ס��ֱ�����š�

������жϷ�����С����Ա�ľ����Ƿ�С��ĳ��ֵ�� ��Ա������ ��ʸ���Ƕ� �Ƿ�� ��Ա���� ��ʸ���Ƕ�֮��ľ���ֵ�Ƿ�С��ĳ��ֵ
*/

// ��Աֹͣ�˶� ���С������Ա���ϱ�ʾ��Ա�Ѿ��ص�������ִ������
PlayerTask do_wait_touch(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& player_pos	=	model->get_our_player_pos(runner_id);
	//const point2f& get_our_player_pos(int id)const;
	const point2f& ball_pos		=	model->get_ball_pos();
	const float&   player_dir	=	model->get_our_player_dir(runner_id);

	// ����task�е����򿪹�Ϊtrue��С������
	task.needCb					=	true;

	// �ж����Ƿ���Ա����ס
	// TODO: ����ж�����Ա����ס��
	// �����ж�������С�򵽳��ľ����Ƿ�С��ĳ��ֵ ͬʱ �������ʸ���Ƕ��Ƿ�ͳ�ͷ��ʸ���Ƕ�֮��ľ���ֵ�Ƿ�С��ĳ��ֵ
	if ((ball_pos - player_pos).length() < BALL_SIZE / 2 + MAX_ROBOT_SIZE + 5 && (anglemod(player_dir - (ball_pos - player_pos).angle()) < PI / 6)){
		cout << "************************Ball is got by player*************************" << endl;
		// ����task�е����������
		// kickPower	������������������������ chipKickPower
		// needKick		���򿪹�
		// isChipKick	���򿪹�
		task.kickPower = 127;	
		task.needKick = true;
		task.isChipKick = false;
	}
	return task;
}

/*
�����Աλ�� �� ����
������λ�� �� ��Ա����������ĽǶȣ�
�ж���Ա��û�г��������ķ������û��������Ա���������ķ��� 

ͣ��
*/
PlayerTask do_stop_ball(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& player_pos	= model->get_our_player_pos(runner_id);
	const point2f& ball_pos		= model->get_ball_pos();
	const float&   player_dir	= model->get_our_player_dir(runner_id);
	const float&   player_ball_dir	= (fabs(anglemod(player_dir - (ball_pos - player_pos).angle())));	  // ��Ա�ĳ��� �� ��Ա����ķ��� �ĽǶȲ�

	// �ж���Ա�Ƿ�������Ա�ĳ���Ƕ� - ��Աλ��ָ����λ�õ������Ƕ�  С��һ����ֵ
	// TODO: ��Ա�Ƿ��������򣨽ǶȲ���жϷ�����,����ǶȲ��Ƿ���Ե��������ֵԽС��ͣ��Խ׼����ʱԽ��
	bool  player_oriente_ball = player_ball_dir < PI / 6;

	//�����û�б���Ա��ס��������Ա������ķ���
	if (!player_oriente_ball){
		task.target_pos = player_pos;	// ����ԭ�� �ȴ������
		task.orientate = (ball_pos - player_pos).angle();	// ���������ķ���
	}
	//�����Ա�����������ķ���needCb���򿪹�����
	else{
		task.needCb = true;
	}
	return task;
}

// ����
PlayerTask do_turn_and_shoot(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& player_pos = model->get_our_player_pos(runner_id);
	const point2f& ball_pos = model->get_ball_pos();
	const point2f& opp = -FieldPoint::Goal_Center_Point;

	// �������Ա�ľ���С��15 ��ǰȥ����
	// TODO: ����Ĳ���15ֵ��̽��
	if ((ball_pos - player_pos).length() < 15){
		task.target_pos = ball_pos + Maths::polar2vector(15, (player_pos - ball_pos).angle());	// �������15�ĵط�����
		task.orientate = (ball_pos - player_pos).angle();
	}
	// ���� ���� GetBall�����ط���ȥ����
	else
	{
		task = get_ball_plan(model, runner_id, runner_id);
	}
	return task;
}

//������λ�÷��򣬵�  �Է�����ָ����������� ����λ��
PlayerTask do_adjust_dir(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& ball_pos = model->get_ball_pos();
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;	// opp_goal �� �Է����ŵĶ�ά����
	const point2f& player_pos = model->get_our_player_pos(runner_id);
	// ������  ���λ�� + ���Է��������ĵ����λ�õ�ʸ������ 20 ��λ���ȣ�
	const point2f& back2ball_p = ball_pos + Maths::polar2vector(20, (ball_pos - opp_goal).angle());

	task.target_pos = back2ball_p;
	task.orientate = (opp_goal - ball_pos).angle();
	return task;
}

//����
PlayerTask do_shoot(const WorldModel* model, int runner_id){
	PlayerTask task;

	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;	// opp_goal �Է���������
	const point2f& ball_pos = model->get_ball_pos();
	const point2f& player_pos = model->get_our_player_pos(runner_id);
	const float& player_dir = model->get_our_player_dir(runner_id);

	// �������ͱ��� get_ball  �õ���
	// ����Ա�ľ���С�� �õ������ֵ(�궨��16)-2.5  &&  ��Ա�Ƕ�����ǶȲ� �ľ���ֵ С��һ����ֵ  Ϊ1
	bool get_ball = (ball_pos - player_pos).length() < get_ball_threshold - 2.5 && (fabs(anglemod(player_dir - (ball_pos - player_pos).angle())) < PI / 6);

	// ����õ����� ׼������
	if (get_ball){
		task.kickPower = 127;
		task.needKick = true;
		task.isChipKick = false;
	}

	// �Է����� �� ������� �ĽǶ�
	float opp_goal_to_ball = (ball_pos - opp_goal).angle();

	// TODO��fast_shoot ������
	task.target_pos = ball_pos + Maths::polar2vector(fast_shoot, opp_goal_to_ball);
	task.orientate = (opp_goal - ball_pos).angle();
	task.flag = 1;		// flagΪ1С�����ٶ�*2
	return task;
}

/*
������ǰ��һЩ״̬�����жϣ��������Ƿ�����
*/

PlayerTask player_plan(const WorldModel* model, int robot_id){
	cout << "******************************int flat shoot skill plan******************************" << endl;
	PlayerTask task;

	bool ball_moving_to_head;

	//������Ҫ�õ��Ĳ���
	const point2f& player_pos = model->get_our_player_pos(robot_id);	// ��Աλ��
	const point2f& ball_pos = model->get_ball_pos();				// ���λ��

	const point2f& last_ball_pos = model->get_ball_pos(1);			// �����һ֡���λ��
	const float player_dir = model->get_our_player_dir(robot_id);		// ��Ա�Ƕ�
	const point2f& opp_pos = -FieldPoint::Goal_Center_Point;			// �Է�����

	//�Է�����λ����������Աλ��ʸ������� �� ������Ա�����֮��
	float player2opp_playerdir_angle = anglemod((opp_pos - player_pos).angle() - player_dir);
	//����������Աλ��ʸ������� �� ������Ա�����֮��
	float player2ball_playerdir_angle = anglemod((ball_pos - player_pos).angle() - player_dir);

	// �Է�������������Աλ��ʸ������� �� ������Ա��������֮�� �ľ���ֵ С��ĳ��ֵʱΪtrue��
	// �ж�������Ա�Ƿ����ŶԷ�����
	bool toward_oppgoal = fabs(player2opp_playerdir_angle) < PI / 4;
	// ����������Աλ��ʸ������� �� ������Ա�����֮�� �ľ���ֵ С��ĳ��ֵʱΪtrue
	// �ж����Ƿ���������Աǰ��
	bool ball_front_head = fabs(player2ball_playerdir_angle) < PI / 3;

	// ��ǰ֡λ�ú���һ֡λ�ò
	// ��λ����
	point2f vector_s = ball_pos - last_ball_pos;
	// ��Ա�Ҳ�λ��
	point2f head_right = player_pos + Maths::polar2vector(Center_To_Mouth, anglemod(player_dir + PI / 6));
	// ��Ա���λ��
	point2f head_left = player_pos + Maths::polar2vector(Center_To_Mouth, anglemod(player_dir - PI / 6));
	//��ͷ�м�λ��
	point2f head_middle = player_pos + Maths::polar2vector(7, player_dir);
	//��ͷ�Ҳ�λ�õ���λ��ʸ��
	point2f vector_a = head_right - ball_pos;
	//��ͷ���λ�õ���λ��ʸ��
	point2f vector_b = head_left - ball_pos;
	//��ͷ�м�λ�õ���λ��ʸ��
	point2f vector_c = head_middle - ball_pos;

	bool wait_touch, stop_ball;
	bool wait_touch_condition_a, wait_touch_condition_b;



	// ��� ������һ֡��λ�Ʋ� С���Ӿ���� Vision_ERROR��2��
	if (vector_s.length() < Vision_ERROR){
		ball_moving_to_head = false;		// �ж�Ϊ��û���ƶ�/��û������Ա�ƶ�
	}
	else	// ���ƶ���
	{
		// dot ���
		// �� ����Աͷ�з����ʸ�� �� ���˶�����ĽǶ� �ļн�    acos �����ҵ�ֵ ���ؽǶ�
		float angle_sc = acos(dot(vector_c, vector_s) / (vector_c.length() *vector_s.length()));
		// �ж����Ƿ���Աͷ�ƶ�
		ball_moving_to_head = angle_sc < PI / 6 && angle_sc > -PI / 6;
	}






	//��������a:���Ƿ���������Ա�����򣬲�����Ա����Է�����
	wait_touch_condition_a = ball_front_head && toward_oppgoal;
	//��������b:��������a��ͬʱ�Ƿ�����������Ա�����򲢳���Ա�˶�
	wait_touch_condition_b = ball_moving_to_head && wait_touch_condition_a;
	//ͣ���жϲ�������
	stop_ball = (ball_front_head && ball_moving_to_head && !toward_oppgoal);
	//�����жϲ�������
	wait_touch = wait_touch_condition_b;

	//ShootMethodsö�ٱ���
	ShootMethods method;
	if (wait_touch)//�����жϣ�WaitTouch����
		method = WaitTouch;
	else if (stop_ball)//ͣ���ж�, StopBall����
		method = StopBall;
	else if (!toward_oppgoal)//û�г���Է������жϣ�AdjustDir����
		method = AdjustDir;
	else if ((ball_pos - player_pos).length() < get_ball_threshold + 5 && (anglemod(player_dir - (ball_pos - player_pos).angle()) < PI / 6))//�ж����ڳ�ͷ������λ��,ShootBall����
		method = ShootBall;
	else
		method = ChaseBall;//���򷽷�

	// �ɵ�ǰ��ģʽö��method ִ����Ӧ�ķ���
	switch (method)
	{
	case None:
		break;
	case ChaseBall:
		task = do_chase_ball(model, robot_id);
		break;
	case WaitTouch:
		task = do_wait_touch(model, robot_id);
		break;
	case StopBall:
		task = do_stop_ball(model, robot_id);
		break;
	case AdjustDir:
		task = do_adjust_dir(model, robot_id);
		break;
	case ShootBall:
		task = do_shoot(model, robot_id);
		break;
	default:
		break;
	}
	cout << "out shoot skill" << endl;
	return task;
}

