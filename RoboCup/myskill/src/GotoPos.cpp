/************************************************************
* 跑位接球函数函数名： GotoPos								*
*															*
* 实现功能： 指定跑位点										*
*															*
* 具体描述： 												*
*															*
*															*
* 返回值：			PlayerTask								*
*															*
* 说明：														*
*															*
************************************************************/


#include "GotoPos.h"
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

