/*
实现 开球的初始位置状态：




*/

#include "KickOff_init.h"
#include "GotoPos.h"
#include <iostream>

PlayerTask player_plan(const WorldModel* model, int robot_id){
	PlayerTask task;

	const point2f& ball_Pos = model->get_ball_pos();

	const point2f& Kicker_Target = ball_Pos + Maths::polar2vector(50, -3 * PI / 2);
	const point2f& Receiver_Target = ball_Pos + Maths::polar2vector(50, PI);
	const point2f& Tier_Target = ball_Pos + Maths::polar2vector(50, 3 * PI / 2);
	const point2f& Goalie_Target = ball_Pos + Maths::polar2vector(-310, PI);
	
	const point2f& Kicker_Pos = model->get_our_player_pos(KICKER_ID);
	const point2f& Receiver_Pos = model->get_our_player_pos(RECEIVER_ID);
	const point2f& Tier_Pos = model->get_our_player_pos(TIER_ID);
	const point2f& Goalie_Pos = model->get_our_player_pos(GOALIE_ID);


	const float& Kicker2ball = (ball_Pos - Kicker_Pos).angle();
	const float& Receiver2ball = (ball_Pos - Receiver_Pos).angle();
	const float& Tier2ball = (ball_Pos - Tier_Pos).angle();
	const float& Goalie2ball = (ball_Pos - Goalie_Pos).angle();

	if (robot_id == KICKER_ID){	//Kicker
		cout << "********************************KickerGotoInitPos***********************************"<< endl;
		task = GotoPos_plan(model, Kicker_Target.X(), Kicker_Target.Y(), Kicker2ball);	// 前往Kicker的目标点 朝向球的方向
	}
	else if (robot_id == RECEIVER_ID){	// Receiver
		cout << "********************************ReceiverGotoInitPos***********************************" << endl;
		task = GotoPos_plan(model, Receiver_Target.X(), Receiver_Target.Y(), Receiver2ball);
	}
	else if (robot_id == TIER_ID){	// Tier
		cout << "********************************TierGotoInitPos***********************************" << endl;
		task = GotoPos_plan(model, Tier_Target.X(), Tier_Target.Y(), Tier2ball);
	}
	else if (robot_id == GOALIE_ID){	// Goalie
		cout << "********************************GoalieGotoInitPos***********************************" << endl;
		task = GotoPos_plan(model, Goalie_Target.X(), Goalie_Target.Y(), Goalie2ball);
	}
	return task;

}