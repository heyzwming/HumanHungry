#ifndef PASSBALL_H
#define PASSBALL_H
#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/constants.h"
#include "utils/worldmodel.h"
#include <iostream>

#define fast_pass 3

float head_len = 7.0;

namespace{
	bool isSimulation = false;
	float param = 2;
}

PlayerTask player_plan(const WorldModel* model, int runner_id, int reveiver_id);

bool is_ready_pass(const point2f& ball, const point2f& passer, const point2f& receiver);

#endif