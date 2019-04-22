#include "utils/maths.h"
#include "GoReveivePos.h"
#include <time.h>
#include "utils\worldmodel.h"

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

/*
GoReceivePos::GoReceivePos()
{
	srand((int)time(NULL));
}

GoReceivePos::~GoReceivePos()
{
}
*/

//敌方小车在我方小车和球之间阻挡，return true
bool opp_block_shoot(const WorldModel* model, const point2f& player, const point2f& ball, int& block_id){
	//初始化判断变量is_block
	bool is_block = false;
	// 获得对方球员的上场信息  返回一个布尔数组指针
	const bool* exist_id = model->get_opp_exist_id();

	for (int i = 0; i < MAX_ROBOTS; i++){
		//判断敌方车号
		if (exist_id[i]){
			const point2f& pos = model->get_opp_player_pos(i);
			//point_on_segment(v0, v1, p, flages),求p点到v0v1线段上的最近点
			point2f nearest_p = Vector::point_on_segment(player, ball, pos, true);
			float dist = (nearest_p - pos).length();
			if (dist<MAX_ROBOT_SIZE / 2){
				block_id = i;
				is_block = true;
				break;
			};
		}
	}
	return is_block;
}

PlayerTask player_plan(const WorldModel* model, int id){
	srand((int)time(NULL));
	PlayerTask task;
//	WorldModel worldModel;
	//获取执行接球点跑位需要的参数，部分参数注解可参考GetBall.cpp
	const point2f& opp = -FieldPoint::Goal_Center_Point;
	const point2f& ball = model->get_ball_pos();
	const point2f& runner = model->get_our_player_pos(id);
	const point2f& our_goal = FieldPoint::Goal_Center_Point;
	int block_id = -1;
	//convert是反转参数，当ball在右半场时，convert为-1，当ball在左半场，convert为1
	int convert = (ball.y > 0 || fabs(ball.y) < 3) ? -1 : 1;
	bool is_front = (ball.x > -3);
	bool is_block = opp_block_shoot(model, runner, ball, block_id);
	//判断敌方车是否阻挡执行接球点跑位
	if ( !is_block){
		//判断球是否在前场执行接球点跑位
		if (is_front){
			task.target_pos.x = ball.x -50 ;
			task.target_pos.y = convert * (FIELD_WIDTH_H-50);
			task.orientate = (opp - task.target_pos).angle();
		}
		else{
			task.target_pos.x = 20;
			task.target_pos.y = convert* (FIELD_WIDTH_H-50);
			task.orientate = (ball - task.target_pos).angle();
		}
	}
	else
	{
		float rang_x = ball.x;
		float rang_y = FIELD_WIDTH_H;
		int cnt = 0;
		bool bolck = true;
		while (cnt <30 && bolck )
		{
			float  x = rand() % (-10) - (rang_x - 10);
			float  y = rand() % (-10) - (convert * (rang_y - 10));
			point2f rand_p(x,y);
			bolck = opp_block_shoot(model, rand_p, opp, block_id);
			task.target_pos = rand_p;
			task.orientate = (opp - task.target_pos).angle();
			cnt++;
		}

	}
	
	return task;
}