#ifndef NORMALDEF_H
#define NORMALDEF_H
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"
#include "utils/maths.h"
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

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

//class NormalDef
//{
//public:
//	NormalDef();
//	~NormalDef();
//	PlayerTask player_plan(const WorldModel* model, int id);
//private:
//
//};

#endif