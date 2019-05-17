#include "utils/PlayerTask.h"
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"


extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
	PlayerTask task;

	const point2f& player_pos = model->get_our_player_pos(robot_id);
	const float player_dir = model->get_our_player_dir(robot_id);

	cout << "===================================================仅仅开启原地吸球模式===================================================" << endl;
	task.needCb = true;
	task.orientate = player_dir;
	task.target_pos = player_pos;

	return task;
}