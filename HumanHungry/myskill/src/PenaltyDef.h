#ifndef PENALTY_H
#define PENALTY_H
#include "utils/PlayerTask.h"
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"
#include "utils/maths.h"
namespace{
	float goalie_penalty_def_buf = 20;
}
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);
int opp_penalty_player(const WorldModel* model);
point2f def_pos(const point2f& p, float dir);

/*
class PenaltyDef
{
public:
	PenaltyDef();
	~PenaltyDef();
	PlayerTask plan();
private:
	int opp_penalty_player();
	point2f def_pos(const point2f& p,float dir);
};

typedef Singleton<PenaltyDef> penaltyDef;
*/
#endif