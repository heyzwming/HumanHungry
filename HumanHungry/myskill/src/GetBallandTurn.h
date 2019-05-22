#ifndef GETBALLANDTURN_H
#define GETBALLANDTURN_H

#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/constants.h"
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"


extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);


#endif