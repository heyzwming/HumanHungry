#ifndef PASSBALL2KICKER_H
#define PASSBALL2KICKER_H
#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/constants.h"
#include "utils/worldmodel.h"
#include <iostream>

#define fast_pass 3

// TODO: 球员的头部 部分宽度
float head_len = 6.0;

namespace{
	bool isSimulation = false;
	float param = 2;
}

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int runner_id);

bool is_ready_pass(const point2f& ball, const point2f& passer, const point2f& receiver);

#endif