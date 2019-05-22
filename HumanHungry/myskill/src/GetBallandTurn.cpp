#include "GetBallandTurn.h"
#include "GetBall2Ball.hpp"


extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model,int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
	PlayerTask task;

	const point2f& ball_pos = model->get_ball_pos();
	const point2f& player_pos = model->get_our_player_pos(robot_id);
	float player_dir = model->get_our_player_dir(robot_id);
	float ball_player_dir_angle = (ball_pos - player_pos).angle() - player_dir;

	bool close_ball = (ball_pos - player_pos).length() <= 12;
	bool get_ball = (ball_pos - player_pos).length() <= 9.8;



	if (get_ball){
		task.orientate = anglemod(player_dir + PI);
		task.needCb = true;
		task.target_pos = player_pos;
	}
	else{
		task = get_ball_2_ball_plan(model, robot_id);
	}

	//if (get_ball){

	//}

	return task;
}