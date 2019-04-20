#include "def.h"
#include "utils/maths.h"
//用户注意；接口需要如下声明
//extern "C" __declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

enum PenaltyArea
{
	RightArc,
	MiddleRectangle,
	LeftArc
};


PlayerTask player_plan(const WorldModel* model, int robot_id){
	PlayerTask task;
	const point2f& goal = FieldPoint::Goal_Center_Point;
	const point2f& arc_center_right = FieldPoint::Penalty_Arc_Center_Right;
	const point2f& arc_center_left = FieldPoint::Penalty_Arc_Center_Left;
	const point2f& rectangle_left = FieldPoint::Penalty_Rectangle_Left;
	const point2f& rectangle_right = FieldPoint::Penalty_Rectangle_Right;
	const point2f& ball = model->get_ball_pos();
	PenaltyArea area;
	if (ball.y > arc_center_right.y)
		area = RightArc;
	else if (ball.y < arc_center_left.y)
		area = LeftArc;
	else
		area = MiddleRectangle;
	switch (area)
	{
	case RightArc:
		task.orientate = (ball - goal).angle();
		task.target_pos = goal + Maths::polar2vector(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R / 2, task.orientate);
		break;
	case MiddleRectangle:
		task.orientate = (ball - goal).angle();
		task.target_pos = Maths::across_point(rectangle_left, rectangle_right, ball, goal);
		break;
	case LeftArc:
		task.orientate = (ball - goal).angle();
		task.target_pos = goal + Maths::polar2vector(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R / 2, task.orientate);
		break;
	default:
		break;
	}

	return task;
}