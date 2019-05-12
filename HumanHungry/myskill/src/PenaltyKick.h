#ifndef PENALTYKICK_H
#define PENALTYKICK_H

#include "utils/maths.h"
#include "utils/PlayerTask.h"
#include "utils/WorldModel.h"
#include <time.h> 
namespace{
	float penalty_kick_random_range = 30;
	float penalty_kick_get_ball_buf = -2;
}
//用户注意；接口需要如下声明
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

int opp_goalie(const WorldModel* model);




/*
class PenaltyKick
{
public:
	PenaltyKick();
	~PenaltyKick();
	PlayerTask plan(const WorldModel* model, int robot_id);
private:
	int opp_goalie();
};
typedef Singleton<PenaltyKick> penaltyKick;
*/
#endif