#include "utils/PlayerTask.h"
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"


extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
	PlayerTask task;

	task.needCb = true;
	cout << "===================================================仅仅开启吸球模式===================================================" << endl;

	return task;
}