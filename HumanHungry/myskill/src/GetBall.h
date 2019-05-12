#ifndef GETBALL_H
#define GETBALL_H

#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/constants.h"
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"

PlayerTask get_ball_plan(const WorldModel* model, int robot_id, int receiver_id);

void isSimulate(const WorldModel* model);
bool toward_opp_goal(float dir);
float ball_x_angle(const WorldModel* model);

#endif