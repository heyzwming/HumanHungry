#ifndef GOTOPOS_H
#define GOTOPOS_H
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"
#include "utils/PlayerTask.h"

PlayerTask GotoPos_plan(const WorldModel* model, float x, float y, float dir);

#endif