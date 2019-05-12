#ifndef GORECEIVEPOS_H
#define GORECEIVEPOS_H

#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"
#include "utils/maths.h"
#include <time.h>

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);
bool opp_block_shoot(const WorldModel* model, const point2f& player, const point2f& ball, int& block_id);






/*
class GoReceivePos
{
public:
GoReceivePos();
~GoReceivePos();
PlayerTask plan(int id);
private:
bool opp_block_shoot(const point2f& runner,const point2f& ball,int& opp_block_id);
};
typedef Singleton<GoReceivePos> goReceivePos;

*/

#endif