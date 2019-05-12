#ifndef SHOOT_H
#define SHOOT_H
#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/WorldModel.h"
#include <math.h>
using namespace std;

#define Center_To_Mouth 8
#define Vision_ERROR 2
#define fast_shoot 1

namespace{
	bool isSimulation = false;
	float param = 1;
}

enum ShootMethods
{
	None,
	ShootBall,
	StopBall,
	ChaseBall,
	WaitTouch,
	AdjustDir,
	GoAndTurnKick,
};

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask do_chase_ball(const WorldModel* model, int runner_id);
PlayerTask do_wait_touch(const WorldModel* model, int runner_id);
PlayerTask do_stop_ball_and_shoot(const WorldModel* model, int runner_id);
PlayerTask do_turn_and_shoot(const WorldModel* model, int runner_id);
PlayerTask do_adjust_dir(const WorldModel* model, int runner_id); PlayerTask do_shoot(const WorldModel* model, int runner_id);
PlayerTask player_plan(const WorldModel* model, int robot_id);

#endif