#ifndef REFDEF_H
#define REFDEF_H
#include "utils/PlayerTask.h"
#include "utils/WorldModel.h"
#include "utils/maths.h"

PlayerTask player_plan(const WorldModel* model, int id, string role);

enum BallArea
{
	Left,
	Middle,
	Right
};

#endif