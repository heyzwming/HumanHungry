#include "PenaltyDef.h"
//#include "def.h"
#include "utils\PlayerTask.h"
#include "utils\worldmodel.h"
#include "utils/maths.h"

using namespace std;
//#include "ParamReader.h"

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

namespace{
	float goalie_penalty_def_buf = 20;
}

/*
PenaltyDef::PenaltyDef(){
	//srand((int)time(NULL));

	//DECLARE_PARAM_READER_BEGIN(PlayBotSkillParam)
	//READ_PARAM(goalie_penalty_def_buf)
	//DECLARE_PARAM_READER_END

}

PenaltyDef::~PenaltyDef()
{
}
*/

/*

PlayerTask gotoPos(const WorldModel* model, float x, float y, float dir){
PlayerTask task;
task.target_pos.x = x;
task.target_pos.y = y;
task.orientate = dir;
return task;
}

*/


//获得离我球门最近的对方球员编号，即对方点球球员编号
int opp_penalty_player(const WorldModel* model){


	int opp_penalty_id = -1;	// 初始化对方点球球员编号为-1

	const bool* exist_id = model->get_opp_exist_id();	// 布尔数组  获得在场球员的编号 
	const point2f& our_goal = FieldPoint::Goal_Center_Point;
	float dist = 9999;

	// MAX_ROBOTS : 场上最多的球员数
	// 获得对方点球手编号和距离
	for (int i = 0; i < MAX_ROBOTS; i++){
		if (exist_id[i]){
			const point2f& pos = model->get_opp_player_pos(i);
			float goal_opp_dist = (pos - our_goal).length();
			if (goal_opp_dist<dist){
				dist = goal_opp_dist;
				opp_penalty_id = i;
			};
		}
	}
	return opp_penalty_id;
}

/*

//获得离我球门最近的我方球员编号，即我方点球防守球员编号
int our_penalty_player(const WorldModel* model){


int our_penalty_id = -1;	// 初始化对方点球球员编号为-1

const bool* exist_id = model->get_our_exist_id();	// 布尔数组  获得在场球员的编号
const point2f& our_goal = FieldPoint::Goal_Center_Point;
float dist = 9999;

// MAX_ROBOTS : 场上最多的球员数
// 获得对方点球手编号和距离
for (int i = 0; i < MAX_ROBOTS; i++){
if (exist_id[i]){
const point2f& pos = model->get_our_player_pos(i);
float goal_our_dist = (pos - our_goal).length();
if (goal_our_dist<dist){
dist = goal_our_dist;
our_penalty_id = i;
};
}
}
return our_penalty_id;
}

*/


 //计算防守位置
point2f def_pos(const point2f& p, float dir){

	// FIELD_LENGTH_H = 300			半场长度
	// goalie_penalty_def_buf = 20	球门内宽度
	// -FIELD_LENGTH_H + goalie_penalty_def_buf   -300+20  为点球防守初始站位
	float x = -FIELD_LENGTH_H + goalie_penalty_def_buf;
	float y = p.y + tanf(dir)*(x - p.x);

	// 三目运算符  如果y>0 则把1赋值给convert 否则把-1赋值给convert
	int convert = y > 0 ? 1 : -1;

	// TODO: ???
	if (y > 30 || y < -30)
		y = 30 * convert;
	return point2f(x,y);
}	

PlayerTask Player_plan(const WorldModel* model, int robot_id){
	PlayerTask task;

	int opp_kicker = opp_penalty_player(model);	// 对方点球球员编号
	const point2f& ball = model->get_ball_pos();
	const point2f& our_goal = FieldPoint::Goal_Center_Point;

	if (opp_kicker == -1) { // 没有检测到对方点球球员  直接返回task
		task.target_pos = our_goal + point2f(10,0);
		task.orientate = (task.target_pos - our_goal).angle();
		cout << "no opp penalty kicker" << endl;
		return task;
	}
	const point2f& penalty_kicker = model->get_opp_player_pos(opp_kicker);	// 获得对方点球球员编号
	float opp_dir = model->get_opp_player_dir(opp_kicker);					// 对方点球球员的角度

//	task = gotoPos(model, -605 / 2, 0.0, (ball - model->get_our_player_pos(our_penalty_player(model))).angle());	// 4 我方守门员编号

	task.target_pos = def_pos(penalty_kicker,opp_dir);		// 计算防守位置
	task.orientate = (ball - task.target_pos).angle();
	return task;
}