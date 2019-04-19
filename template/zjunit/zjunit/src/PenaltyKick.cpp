#include "PenaltyKick.h"
#include "def.h"
#include "utils/maths.h"
//#include "ParamReader.h"
#include <time.h> 
namespace{
	float penalty_kick_random_range = 30;
	float penalty_kick_get_ball_buf = -2;
}
PenaltyKick::PenaltyKick()
{
	WorldModel worldModel;
	srand((int)time(NULL));
	// TODO: ???未定义标识符 暂时注释掉这部分代码
//	DECLARE_PARAM_READER_BEGIN(PlayBotSkillParam)
//	READ_PARAM(penalty_kick_random_range)
//	READ_PARAM(penalty_kick_get_ball_buf)
//	DECLARE_PARAM_READER_END
}

PenaltyKick::~PenaltyKick()
{
}

//获得离我球门最近的对方小车车号
int PenaltyKick::opp_goalie(){
	WorldModel worldModel;
	int opp_goalie_id = -1;
	const bool* exist_id = worldModel.get_opp_exist_id();
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	float dist = 9999;
	for (int i = 0; i < MAX_ROBOTS; i++){
		if (exist_id[i]){
			const point2f& pos = worldModel.get_opp_player_pos(i);
			float goal_opp_dist = (pos - opp_goal).length();
			if (goal_opp_dist<dist){
				dist = goal_opp_dist;
				opp_goalie_id = i;
			};
		}
	}
	return opp_goalie_id;
}


PlayerTask PenaltyKick::plan(int id){
	PlayerTask task;
	WorldModel worldModel;
	int opp_goalie_num = opp_goalie();
	const point2f& ball = worldModel.get_ball_pos();
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;
	const point2f& player = worldModel.get_our_player_pos(id);
	const float dir = worldModel.get_our_player_dir(id);
	bool get_ball = (ball - player).length() < get_ball_threshold - 3.5 && (fabs(anglemod(dir - (ball - player).angle())) < PI / 6);
	if (get_ball){
		task.kickPower = 127;
		task.isChipKick = false;
		task.needKick = true;
	}
	if (opp_goalie_num == -1){
		task.target_pos = ball + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + penalty_kick_get_ball_buf, (ball - opp_goal).angle());
		task.orientate = (opp_goal - ball).angle();
		return task;
	};
	const point2f& opp = worldModel.get_opp_player_pos(opp_goalie_num);
	int choose_cnt = 0;
	bool choose_succeed = false;
	point2f choose_p, neraest_p;
	choose_p.x = FIELD_LENGTH_H;
	while (choose_cnt <600 && !choose_succeed)
	{
		choose_p.y = rand() % (int)(penalty_kick_random_range * 2 + 1) - penalty_kick_random_range;
		neraest_p = Vector::point_on_segment(ball,choose_p,opp,true);
		if ((neraest_p - opp).length() > MAX_ROBOT_SIZE / 2 + BALL_SIZE / 2 + 2)
			choose_succeed = true;
		choose_cnt++;
	}
	task.target_pos = ball + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + penalty_kick_get_ball_buf, (ball - choose_p).angle());
	task.orientate = (choose_p - ball).angle();
	return task;
}