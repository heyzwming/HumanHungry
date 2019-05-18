#include "PassBall2KickerTest.h"
#include "GetBall.h"

#define frame_rate  60.0

#define DEBUG 1

//robot_idΪ����С�����ţ�KICKER_IDΪ������Ա���
PlayerTask player_plan(const WorldModel* model, int robot_id){
	//����PlayerTask����
	PlayerTask task;

	cout << "===================================================����������===================================================" << endl;
	cout << "-----------getballbuf:" << get_ball_buf << "-------------" << endl;
	cout << "-----------awayballdist_x:" << away_ball_dist_x << "-------------" << endl;
	cout << "-----------awayballdist_y:" << away_ball_dist_y << "-------------" << endl;

	// ���С��ǰͼ��֡����λ��
	// �ص㣺С���������Ϣ����ͼ��֡Ϊ��С��λ���Ӿ������ղ��洢�����԰������꿴����һ�������飬����������ͼ��֡�ţ�����Ԫ����������Ϣ
	const point2f& ball_pos = model->get_ball_pos();

	//���С��ǰ֡����һ֡ͼ��������Ϣ
	const point2f& last_ball = model->get_ball_pos(1);

	// ע�⣡get_ball_vel()    

	//����ҷ�KICKER_IDС������λ����Ϣ
	const point2f& receive_player_pos = model->get_our_player_pos(KICKER_ID);

	//����ҷ�robot_idС��������Ϣ
	const point2f& get_ball_player = model->get_our_player_pos(robot_id);

	//�з������е�
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;

	//�ҷ�receier_idС��������Ϣ��
	const float rece_dir = model->get_our_player_dir(KICKER_ID);

	//�����receive_player_posΪԭ��ļ����꣬ROBOY_HEADΪ������length,rece_dirΪ������angle
	//TODO: ROBOT_HEAD ����
	const point2f& rece_head_pos = receive_player_pos + Maths::polar2vector(ROBOT_HEAD, rece_dir);

	//����ҷ�robot_idС��������Ϣ
	const float dir = model->get_our_player_dir(robot_id);

	//���receive_player_pos��ball�����ĽǶȣ�ע�⣺���нǶȼ���Ϊ�����볡��x����������ʱ��н�
	float receive2ball = (ball_pos - receive_player_pos).angle();

	//��öԷ����ŵ���������Ƕ�
	float opp_goal2ball = (ball_pos - opp_goal).angle();

	//���ball���Է����ŵ������Ƕ�
	float ball2opp_goal = (opp_goal - ball_pos).angle();

	//��öԷ����ŵ������������
	float ball_away_goal = (ball_pos - opp_goal).length();

	//�����get_ball_player����������
	float player_away_ball = (get_ball_player - ball_pos).length();

	//��öԷ����ŵ�get_ball_player�ĳ���
	float player_away_goal = (get_ball_player - opp_goal).length();

	//�����ǰ���굽��һ����λ�������ĳ���
	float ball_moving_dist = (ball_pos - last_ball).length();


	//�ж�dir��Է����ŵĽǶȹ�ϵ����toward_opp_goal����
	bool is_toward_opp_goal = toward_opp_goal(dir);
	//�ж�С���Ƿ�������Է�����֮��
	bool ball_behind_player = ball_away_goal + BALL_SIZE + MAX_ROBOT_SIZE > player_away_goal;
	//�ж�С���Ƿ��˶�
	bool ball_moving = (ball_moving_dist < 0.8) ? false : true;
	//�ж�get_ball_playerС����ball�����Ǿ���ֵ�Ƿ�С��75��
	bool player_toward_ball = fabs((ball_pos - get_ball_player).angle() - dir) < (PI / 2 - PI / 12) ? true : false;
	bool direct_get_ball = !ball_moving;
	bool across_ball;
	bool ball_move2target;
	float ball_moving_dir = (ball_pos - last_ball).angle();

	// С���ڵ�ǰ֡����һ֡��λ��  =  ���λ�� + �����꣨��ǰ֡����һ֡���ƶ����룬�ƶ�����ת�ɵĶ�ά��������
	point2f ball_with_vel = ball_pos + Maths::polar2vector(ball_moving_dist, ball_moving_dir);

	cout << "--------------���Ƿ����ƶ�:" << ball_moving << " ---------------------" << endl;


	if (!ball_moving){	// С��û���ƶ�
		cout << "===================================================��û�����ƶ�������===================================================" << endl;

		//С���λ��Ϊ��ǰλ��
		ball_with_vel = ball_pos;
	}

	//  С��λ�ƺ������ ָ�� robot_id ��Ա���� �������ĽǶ�
	// ��� ���� û�б��õ�������
	// float ball_to_player_dir = (get_ball_player - ball_with_vel).angle();

	//�򳵷���(ball - get_ball_player).angle()��С������dir�ļнǣ�
	//�����򳵷���ΪС����С�����ĵ��ʸ������С������Ϊ��ֱ��ͷ����
	float ball_player_dir_angle = (ball_pos - get_ball_player).angle() - dir;

	//�ж�С���Ƿ��������츽��
	bool ball_beside_player_mouth = (ball_pos - get_ball_player).length() < get_ball_threshold && fabs(ball_player_dir_angle) > 0 && fabs(ball_player_dir_angle) < PI / 6;

	bool is_get_ball = (ball_pos - get_ball_player).length() < 12;

	cout << "--------------������Ա���" << get_ball_player << " ---------------------" << endl;
	cout << "--------------���λ��" << ball_pos << " ---------------------" << endl;
	//	cout << "--------------�����һ֡λ��" << last_ball << " ---------------------" << endl;
	cout << "--------------������Ա�Ƕ�" << ball_player_dir_angle << " ---------------------" << endl;

	cout << "------------�ж��������츽��" << ball_beside_player_mouth << " ---------------------" << endl;
	cout << "=================================================== ���λ�õ�������Ա�ľ���С�ڳ�����ֵ��������Ա�Ƕ� pi/6 > dir > 0 ===================================================" << endl;

	if (KICKER_ID == robot_id){	// ������������������ͬ����������GetBall����
		cout << "=================================================== ������������ ===================================================" << endl;
		//�ж�x�᷽��get_ball_PlayerС�������λ�ù�ϵ��С�������ϲ࣬����true	
		// ��һ��˵���� ��Ա������ӽ��Է����� �򷵻�true
		bool ball_x_boundary_right = (ball_pos.x - 2) < get_ball_player.x ? true : false;
		//�ж�y�᷽��get_ball_playerС�������λ�ù�ϵ������robot_id��Ա����࣬����true
		bool ball_y_boundary_right = (ball_pos.y - 2) < get_ball_player.y ? true : false;
#if DEBUG
		if (ball_x_boundary_right)
			cout << "=================================================== x�᷽�� ��Ա �� �� ���ӽ��Է����� ===================================================" << endl;
		else
			cout << "=================================================== x�᷽�� �� �� ��Ա ���ӽ��Է����� ===================================================" << endl;

		if (ball_y_boundary_right)
			cout << "=================================================== y�᷽�� ������Ա ��� ===================================================" << endl;
		else
			cout << "=================================================== y�᷽�� ������Ա �Ҳ� ===================================================" << endl;
#endif

		//�ж�С����get_ball_player����λ�ù�ϵִ������
		if (!ball_x_boundary_right){	// ��������Ա���ӽ��Է�����
			//��robot_idС�����������е�Ŀ������꣬������С���ܵ�ĳ���㣬�õ���ball_with_velΪ������ԭ��  
			// get_ball_buf  ���򻺳����
			// �����Ϊ�����λ��+���� �Է�����ָ���� ���� ��İ뾶+��Ա�뾶 + ���򻺳��� ���ȵ�λ��
			cout << "===================================================�����Ա���ӽ��Է�����===================================================" << endl;
			// ����ӶԷ�����ָ���� �ķ��� ��BALL_SIZE / 2 + MAX_ROBOT_SIZE + get_ball_buf�������λ��
			//task.needCb = true;
			task.target_pos = ball_with_vel + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + get_ball_buf, opp_goal2ball);

			//			cout << "-----------------------------��Ա��ǰλ�ã�" << get_ball_player << "---------------------" << endl;
			cout << "-----------------------------��Ա�ƶ�Ŀ�ĵأ�" << task.target_pos << "---------------------" << endl;
		}
		else{							// ��Ա������ӽ��Է�����
			cout << "===================================================��Ա������ӽ��Է�����===================================================" << endl;
			if (ball_y_boundary_right){	// ������Ա���
				//��robot_idС�����������е�Ŀ������ֱ꣬������x,y
				// x: ���λ�Ƶ�x�� - away_ball_dist_x  TODO: ԭ�����ֵԽ������Խƽ��
				// TODO: ����Ա������ӽ��Է�����ʱ����ĵص���㡣
				cout << "===================================================������Ա ���===================================================" << endl;
				//task.needCb = true;
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y + away_ball_dist_y);		// set ����λ��
			}
			else{						// ������Ա�ұ�
				cout << "===================================================������Ա �ұ�===================================================" << endl;
				//task.needCb = true;
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y - away_ball_dist_y);
			}
		}
		//task.needCb = true;
		task.orientate = (opp_goal - ball_pos).angle(); // ����Ϊ �򵽶Է����ŵ������ķ���
	}
	else				// GetBall��Ա��������Ա ����
		/**************************************************************************************************/
	{
		cout << "===================================================��������Ա����===================================================" << endl;
		// TODO: ��һ�������һ�䲻����׸�
		//�ж�����get_ball_palyer��receive_player_pos֮���λ�ù�ϵ�����x�᷽�����������²࣬�õ�true
		bool all_on_ball_x_boundary_left = (ball_pos.x - 2) < get_ball_player.x && (ball_pos.x - 2) < receive_player_pos.x;
		//���x�᷽�����������ϲ࣬�õ�true
		bool all_on_ball_x_boundary_right = (ball_pos.x - 2) > get_ball_player.x && (ball_pos.x - 2) > receive_player_pos.x;

		//�ж�y�᷽��get_ball_playerС�������λ�ù�ϵ��С�������Ҳ࣬�õ�true
		bool executer_onball_y_boundary_right = (ball_pos.y - 2) < get_ball_player.y ? true : false;

#if DEBUG
		if (all_on_ball_x_boundary_left)
			cout << "===================================================x�� ���� ���������²�===================================================" << endl;

		if (all_on_ball_x_boundary_right)
			cout << "===================================================x�� ���� ���������ϲ�===================================================" << endl;

		if (!all_on_ball_x_boundary_right && !all_on_ball_x_boundary_left)
			cout << "===================================================x�� ���� ��������֮��===================================================" << endl;

		if (executer_onball_y_boundary_right)
			cout << "===================================================y�᷽�� ������Ա �����Ҳ�===================================================" << endl;
		else
			cout << "===================================================y�᷽�� ������Ա �������===================================================" << endl;

#endif

		//�ж�С�������򳵡�����֮���λ�ù�ϵִ������
		if (all_on_ball_x_boundary_right){	// x�᷽�� �������Ա��Է����Ÿ���
			cout << "===================================================x�᷽�� �������Ա��Է����Ÿ���===================================================" << endl;
			if (executer_onball_y_boundary_right){	// y�᷽�� ��Ա�������
				//����task����Ŀ�������
				task.target_pos.set(ball_with_vel.x + away_ball_dist_x, ball_with_vel.y + away_ball_dist_y);
				cout << "===================================================y�᷽�� ��Ա��������===================================================" << endl;
			}
			else{
				task.target_pos.set(ball_with_vel.x + away_ball_dist_x, ball_with_vel.y - away_ball_dist_y);
				cout << "===================================================y�᷽�� ��Ա������Ҳ�===================================================" << endl;
			}

		}
		else if (all_on_ball_x_boundary_left){	// ����Ա�����Ÿ���
			cout << "===================================================����Ա�����Ÿ���===================================================" << endl;
			if (executer_onball_y_boundary_right){		// ��Ա��������
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y + away_ball_dist_y);
				cout << "===================================================y�᷽�� ��Ա������Ҳ�===================================================" << endl;
			}
			else{
				task.target_pos.set(ball_with_vel.x - away_ball_dist_x, ball_with_vel.y - away_ball_dist_y);
				cout << "===================================================y�᷽�� ��Ա������Ҳ�===================================================" << endl;
			}

		}
		else{		// ����������Ա֮��
			task.target_pos = ball_with_vel + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + get_ball_buf, receive2ball);
			cout << "===================================================��������Ա֮��===================================================" << endl;
		}
		task.orientate = (receive_player_pos - ball_pos).angle();
	}
	/**************************************************************************************************/
	if (ball_beside_player_mouth){
		//ִ������
		cout << "===================================================����GetBall��Ա�������츽����ִ������!!===================================================" << endl;
		task.needCb = true;	// ����
		cout << "===================================================��������===================================================" << endl;

		task.target_pos = ball_pos + Maths::polar2vector(9.5, anglemod(dir + PI));
		//		cout << "-------------------------------" << "������Ա�ƶ�Ŀ�ĵ�" << task.target_pos << "------------------------------------" << endl;
	}

	if (is_get_ball){
		// ����
		task.isChipKick = false;
		task.isPass = true;
		task.kickPower = 80;
		task.needKick = true;
		//task.needCb = false;
	}


	return task;

}
