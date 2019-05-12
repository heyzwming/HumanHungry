#ifndef RECEIVEBALL_H
#define RECEIVEBALL_H
#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/WorldModel.h"
#define BALL_VISION_ERROR 2.5
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int runner_id);


#endif