#include "GotoPos.h"
//#include "def.h"
#include "utils\worldmodel.h"
#include "utils/PlayerTask.h"

//extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, float x, float y, float dir);

PlayerTask player_plan(const WorldModel* model, float x, float y, float dir){
	PlayerTask task;
	task.target_pos.x = x;
	task.target_pos.y = y;
	task.orientate = dir;
	return task;
}

