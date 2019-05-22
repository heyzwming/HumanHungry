#include "GoReveivePos.h"
#include <time.h>
#include "def.h"
#include "PassBall.h"
#include "utils/maths.h"
#include "utils/constants.h"
#include "utils/basevision.h"
#include "utils/FilteredObject.h"
#include "utils/game_state.h"
#include "utils/historylogger.h"
#include "utils/matchstate.h"
#include "utils/PlayerTask.h"
#include "utils/referee_commands.h"
#include "utils/robot.h"
#include "utils/singleton.h"
#include "utils/vector.h"
#include "utils/util.h"
#include "utils/worldmodel.h"
//用户注意；接口需要如下声明
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

enum PenaltyArea
{
	RightArc,
	MiddleRectangle,
	LeftArc
};


PlayerTask player_plan(const WorldModel* model, int robot_id){
	PlayerTask task;
	bool is_block = false;
	 point2f& goal = FieldPoint::Goal_Center_Point;
	const point2f& arc_center_right = FieldPoint::Penalty_Arc_Center_Right;
	const point2f& arc_center_left = FieldPoint::Penalty_Arc_Center_Left;
	const point2f& rectangle_left = FieldPoint::Penalty_Rectangle_Left;
	const point2f& rectangle_right = FieldPoint::Penalty_Rectangle_Right;
	const point2f& ball = model->get_ball_pos();
	
	const bool* exist_id = model->get_opp_exist_id(); 
	float maxx = 1000;
	int really_opp_id=0;
	for (int i = 0; i < 6; i++)
	{
		//判断敌方车号
		if (exist_id[i])
		{
			
		//	if (pos.x < 0)
	
			//point_on_segment(v0, v1, p, flages),求p点到v0v1线段上的最近点
			//point2f nearest_p = Vector::point_on_segment(player, ball, pos, true);
			point2f pos = model->get_opp_player_pos(i);
			float dist = (ball - pos).length();
			cout << "!!!!!!!!!!!!!!!" <<"maxx="<<maxx<<"i= "<<i<< dist << " !!!!!!!!!!!!!!!!!!!" << endl;
			if (maxx>dist)
			{
				cout << "!!!!!"<< "maxx=" << maxx << "i=" << i << dist << " !!!!!!!!!!!!!!!!!!!" << endl;
				maxx = dist;
				really_opp_id = i;
			}
		}
	}
	//really_opp_id = 3;
	float opp_dir = model->get_opp_player_dir(really_opp_id);
	point2f opp_pos = model->get_opp_player_pos(really_opp_id);

	float our_dir = opp_dir + 3.1415926;
	task.orientate = our_dir;
	point2f our_pos = (opp_pos - Maths::polar2vector(50, task.orientate));
	task.target_pos = our_pos;
	/*
	PenaltyArea area;
	int area = 0;
	if (ball.y > arc_center_right.y)
		area =  RightArc;
	else if (ball.y < arc_center_left.y)
		area =  LeftArc;
	else
		area =  MiddleRectangle;
	switch (area)
	{
	case RightArc:
		task.orientate = (ball - goal).angle();
		task.target_pos = goal + Maths::vector2polar(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R / 2, task.orientate);
		break;
	case MiddleRectangle:
		task.orientate = (ball - goal).angle();
		task.target_pos = Maths::across_point(rectangle_left, rectangle_right, ball, goal);
		break;
	case LeftArc:
		task.orientate = (ball - goal).angle();
		task.target_pos = goal + Maths::vector2polar(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R / 2, task.orientate);
		break;
	default:
		break;
	}
	*/
	return task;
}