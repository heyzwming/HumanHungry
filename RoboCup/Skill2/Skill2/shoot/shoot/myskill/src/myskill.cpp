
/************************************
									*
1.�������˶�����һ���뾶��Χֹͣ		*
2.����ΪԲ����Բ���˶��������ŽǶ�		*
3.�����ŽǶȺ��ʵ�ʱ��������ǰ������	*
									*
************************************/

/*
����ͨ���޸�Ŀ���ķ�ʽ�޸�skill����shootball -> passball��
*/

#include "myskill.h"
#include "utils/maths.h"
//�û�ע�⣻�ӿ���Ҫ��������
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

enum ball_near  //PenaltyArea
{

	outOfOrbit,
	onOrbit,
	shoot
	/*RightArc_behind,
	RightArc_front,
	MiddleRectangle_behind,
	MiddleRectangle_front,
	LeftArc_behind,
	LeftArc_front,*/
};


PlayerTask player_plan(const WorldModel* model, int robot_id){
	PlayerTask task;
	bool isPasstoReceiver = false;//true->pass false->shoot
	int receiver;		// ������Ϊ�Ľ�����Ա
	// �����ҷ�6����Ա
	// Ѱ��һ���ڳ�����Ա��������Ա�ͱ�������Ա�⣩
	for (int i = 0; i < 6; i++){
		if (i == robot_id || i == model->get_our_goalie()) // ��������ִ�б�skill����Ա�����ҷ�����Ա��ʱ����������ѭ��
			continue;
		if (model->get_our_exist_id()[i])		// �ҵ�һ�����Դ������Ա
			receiver = i;				// ������Ա
	}
	const point2f& receiver_pos = model->get_our_player_pos(receiver);	// ������Ա��λ������
	point2f& opp_goal = -FieldPoint::Goal_Center_Point;	// �Է��������ĵ�
	if (isPasstoReceiver)	// �Ƿ���� ������Ϊ�Ľ�����Ա
							//  true -> ����  false -> ֱ������
		opp_goal = receiver_pos;

	const float pi = 3.1415926;
	const float& circleR = 30;		// �������� �뾶Ϊ30��Բ �ƶ�/��������  ����Χ�İ�ȫ����
	const float& DetAngle = 0.6;	// ��

	const point2f& goal = FieldPoint::Goal_Center_Point;	// Ŀ���->�Է���������
	const point2f& ball = model->get_ball_pos();	
	const point2f& kicker = model->get_our_player_pos(robot_id);
	
	const float& dir = model->get_our_player_dir(robot_id);
	ball_near orbit;	// orbit �������Χ 	ö������	outOfOrbit  |  onOrbit  |  shoot
	
	// �������+ ������ת���ɶ�ά����������circleR=30������(ball-opp_goal).angle() �ɶԷ�����ָ����������ĽǶȣ�
	// �� ����뾶Ϊ30�Ĺ���� �� ����׼���� = ������� + ��Ŀ��㣨�Է��������ģ�ָ����ķ��� ����Ϊ30��ʸ��������vector2polar��������ֵת���ɶ�ά����ֵ��
	point2f shootPosOnOrbit = ball + Maths::vector2polar(circleR,(ball-opp_goal).angle());

	// TODO: û����������
	// ���ŷ��� = | ��ָ��kicker�ĽǶ� - �Է���������ָ����ĽǶ� |
	float toShootDir = fabs((kicker - ball).angle() - (ball - opp_goal).angle());   //(kicker - shootPosOnOrbit).length();
	float toBallDist = (kicker - ball).length();		// kicker����ľ���
	float toOppGoalDir = (opp_goal - kicker).angle();		// ��kickerָ��Ŀ���� �Ƕ�
	float toBallDir = (ball - kicker).angle();

	/*
	˼����������

	1.��ô��������ȷ�ķ����ߵ�P2�㣨һֱ������ȷ�ķ���
	2.��ô���Ż��߶�����ֱ���ߵ�P2�����ź�ɫԲ���������ǻ�ɫֱ��ʾ��ͼ��

	��һ��������������˼�����Ҵ���������д
	�ڶ������⣬����Ҫ����һ�£����ǵ��ŷ�����
	1/60����ŷ����ڣ�ÿ��ִ��60��skill��״̬���жϣ���ͣ�������µ�targetpos�����ʹ��targetposִ�г����Ľ����һ��Բ��
	
	*/

	// = ���λ�� + �� ��ָ��kicker�ķ��� ��İ�ȫ�뾶����30 �Ķ�ά����
	// kicker �ڰ�ȫ�켣�ϵ� ����׼����  
	point2f robotBallAcrossCirclePoint = ball + Maths::vector2polar(circleR, (kicker - ball).angle());

	// = ������� + �� Ŀ��㵽���λ�� �ķ��� ��İ�ȫ�뾶����30 �Ķ�ά����
	point2f AntishootPosOnOrbit = ball + Maths::vector2polar(circleR, (opp_goal - ball).angle());

	// ����kicker����� ����
	point2f BallToRobot = kicker - ball;

	// ״̬����״̬�ж�
	// �Ե�ǰ��kicker�����򣨰�ȫ����� ����� ����ڣ����ţ��������ж�
	if (toBallDist >circleR + 10)	// ���kicker����ľ��� > ��ȫ����30 + 10
		orbit = outOfOrbit;
	else if (toShootDir > 1)	// �����kicker��������Ŀ��㵽��������ĽǶȲ����1  �� ˵��kicker������Բ�ι��
		orbit = onOrbit;
	// TODO: else ��ƥ������
		 else	// ���򣨽ǶȲ� < 1�� ����
			orbit = shoot;
	
	// �Ƿ��õ�����
	bool getBall = toBallDist < 10;
	float diffdir_onorbit = 0;				// ��
	float b2r = BallToRobot.angle();		// �Ƕ���
	float o2b = (ball - opp_goal).angle();	// �Ƕ���
	bool add;

	// ״̬�� ״̬ת��
	switch (orbit)
	{
		case outOfOrbit:		// ����İ�ȫ�����
			task.target_pos = robotBallAcrossCirclePoint;	// �ƶ�Ŀ���Ϊ��İ�ȫ���
			task.orientate = toOppGoalDir;		// ��Ա ʼ�ճ���Ŀ���
			break;
		case onOrbit:	// �ڰ�ȫ�����
			// ���� �� ����ϵ�λ��
			/*
			
			ÿ���û�������չһ��СԲ�� ������ �ս��뵽��ȫ����ĵ� һ��һ���������ߵ� ���� ��׼����


			
			*/

			// ���˾�������Ӧ�ÿ��ǵ���b2r��o2b�ĽǶȵ�����  ��b2r �� o2b��������ʱ�����Ϊ��
			if (b2r * o2b >0){
				if (b2r > 0){
					if (b2r > o2b)
						add = false;
					else
						add = true;
				}
				else{
					if (b2r > o2b)
						add = false;
					else
						add = true;
				}
			}
			else{
				if (b2r > 0)
					add = true;
				else
					add = false;
			}


			if (add){	
				//+
				task.target_pos = ball + Maths::vector2polar(circleR, BallToRobot.angle() + DetAngle);
				task.orientate = toOppGoalDir;
			}
			else{
				//-
				task.target_pos = ball + Maths::vector2polar(circleR, BallToRobot.angle() - DetAngle);
				task.orientate = toOppGoalDir;
			}
			break;

		case shoot: 
			task.target_pos = ball + Maths::vector2polar(5, (ball - opp_goal).angle());
			task.orientate = toOppGoalDir;
			task.needKick = true;
			task.flag = 1;
				
			if (toBallDist < 10 && fabs(model->get_our_player_dir(robot_id) - task.orientate) < 0.15){
				if (isPasstoReceiver)
					task.kickPower = 60;
				else
					task.kickPower = 127;
			}			
			break;
	}
	return task;
}
