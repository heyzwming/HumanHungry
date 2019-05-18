#ifndef GETBALL2R_H
#define GETBALL2R_H

#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/constants.h"
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

void isSimulate(const WorldModel* model);
bool toward_opp_goal(float dir);
float ball_x_angle(const WorldModel* model);

#endif