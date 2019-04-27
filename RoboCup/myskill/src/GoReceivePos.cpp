/************************************************************
* 跑位接球函数函数名： GoReceivePos							*
*															*
* 实现功能： 随机计算接球点跑位接球							*
*															*
* 具体描述： 												*
*															*
*															*
* 返回值：			PlayerTask								*
*															*
* 说明：														*
*															*
************************************************************/


#include "utils/maths.h"
#include "GoReveivePos.h"
#include <time.h>
#include "utils\worldmodel.h"

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

//敌方小车在我方小车和球之间阻挡，return true
bool opp_block_shoot(const WorldModel* model, const point2f& player, const point2f& ball, int& block_id){
	//初始化判断变量is_block
	bool is_block = false;
	// 获得对方球员的上场信息  返回一个布尔数组指针
	const bool* exist_id = model->get_opp_exist_id();

	for (int i = 0; i < MAX_ROBOTS; i++){
		//判断敌方车号
		if (exist_id[i]){
			// 对方上场球员的位置
			const point2f& pos = model->get_opp_player_pos(i);
			//point_on_segment(v0, v1, p, flages),求p点到v0v1线段上的最近点
			// 即 遍历所有对方球员，找到距离我方传球路径最近的对方球员
			point2f nearest_p = Vector::point_on_segment(player, ball, pos, true);
			// 对方球员距离 该最近点的长度
			float dist = (nearest_p - pos).length();
			// 如果距离小于一个机器人的半径 则认为对方球员阻挡在我方传球路线上
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

	// 获取执行接球点跑位需要的参数，部分参数注解可参考GetBall.cpp
	const point2f& opp = -FieldPoint::Goal_Center_Point;		// 我方半场
	const point2f& ball = model->get_ball_pos();
	const point2f& runner = model->get_our_player_pos(id);
	const point2f& our_goal = FieldPoint::Goal_Center_Point;
	int block_id = -1;

	//convert是反转参数，当ball在右半场时，convert为-1，当ball在左半场，convert为1
	// TODO: 3？
	// 判断这里的3  防止摄像头重影  需要用后面的判断 作为双保险  
	int convert = (ball.y > 0 || fabs(ball.y) < 3) ? -1 : 1;

	bool is_front = (ball.x > -3);							//判断球是否在前场执行接球点跑位
	bool is_block = opp_block_shoot(model, runner, ball, block_id);		//判断敌方球员是否阻挡执行接球点跑位

	//判断敌方球员是否阻挡执行接球点跑位
	if ( !is_block){		// 没有阻挡
		//判断球是否在前场执行接球点跑位
		if (is_front){		// 目标点x坐标为球后50，
			task.target_pos.x = ball.x - 50 ;
			task.target_pos.y = convert * (FIELD_WIDTH_H-50);		// 当ball在右半场时，convert为-1，接球点的y坐标为负半场-(405/2-80)的位置
			task.orientate = (opp - task.target_pos).angle();
		}else{	//  球不在前场
			task.target_pos.x = 20;			
			task.target_pos.y = convert* (FIELD_WIDTH_H-50);
			task.orientate = (ball - task.target_pos).angle();
		}
	}else{		// 有对方球员前来阻挡接球
		float rang_x = ball.x;
		float rang_y = FIELD_WIDTH_H;	// 宽度半场
		int cnt = 0;
		bool block = true;

		while (cnt < 30 && block )	// 当 计数器 < 30次 同时仍然被阻挡
		{
			// TODO: 这一块的随机数生成 不太明白
			float  x = rand() % (-10) - (rang_x - 10);		// b = 0  a = 10  rand() % (b-a) + ((-)ball.x -10)	   // rang_x 球的x坐标位置
			float  y = rand() % (-10) - (convert * (rang_y - 10));
			point2f rand_p(x,y);	// 随机生成的2维坐标
			block = opp_block_shoot(model, rand_p, opp, block_id);
			task.target_pos = rand_p;
			task.orientate = (opp - task.target_pos).angle();
			cnt++;
		}
	}
	
	return task;
}


/*
产生一定范围随机数的通用表示公式
要取得 [a,b) 的随机整数，使用 (rand() % (b-a))+ a;

要取得 [a,b] 的随机整数，使用 (rand() % (b-a+1))+ a;

要取得 (a,b] 的随机整数，使用 (rand() % (b-a))+ a + 1;

通用公式: a + rand() % n；其中的 a 是起始值，n 是整数的范围。

要取得 a 到 b 之间的随机整数，另一种表示：a + (int)b * rand() / (RAND_MAX + 1)。

要取得 0～1 之间的浮点数，可以使用 rand() / double(RAND_MAX)。

*/