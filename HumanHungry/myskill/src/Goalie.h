#ifndef GOALIE_H
#define GOALIE_H

#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/worldmodel.h"

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);
bool is_inside_penalty(const point2f& p);








/*

class Goalie
{
public:
	Goalie();
	~Goalie();
	PlayerTask player_plan(const WorldModel* model, int id);

private:
	bool is_inside_penalty(const point2f& p );
};

typedef Singleton<Goalie> goalieSkill;

*/
#endif