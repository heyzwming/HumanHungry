#ifndef GETBALL2KICKERTEST_H
#define GETBALL2KICKERTEST_H

#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/constants.h"
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"

// getball
#define fast_pass 3

// TODO: 球员的头部 部分宽度
float head_len = 6.0;

namespace{
	bool isSimulation = false;
	float param = 2;
}

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

void isSimulate(const WorldModel* model);
bool toward_opp_goal(float dir);
float ball_x_angle(const WorldModel* model);

#endif