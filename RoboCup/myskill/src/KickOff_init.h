#ifndef KICKOFF_INIT_H
#define KICKOFF_INIT_H

#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/constants.h"
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, float x, float y, float dir);

#endif