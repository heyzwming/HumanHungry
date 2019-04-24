#include "PenaltyDef.h"
//#include "def.h"
#include "utils/PlayerTask.h"
#include "utils/worldmodel.h"
#include "utils/maths.h"

using namespace std;
//#include "ParamReader.h"

extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

namespace{
	float goalie_penalty_def_buf = 20;
}

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


 //计算防守位置
point2f def_pos(const WorldModel* model, const point2f& p, float dir){


	/* 守门员初始点位 */

	float stayX = -300;	// 守门初始点x		TODO: 暂时用常量，之后要改成 宏定义
	float stayY = 0;	// 

	/* 获得 当前帧ball 和上一帧last_ball 小球坐标 */

	// 获得小球当前图像帧坐标位置
	// 重点：小球的坐标信息都以图像帧为最小单位从视觉机接收并存储，可以把球坐标看成是一个个数组，数组索引是图像帧号，数组元素是坐标信息
	const point2f& ball = model->get_ball_pos();

	//获得小球当前帧的上一帧图像坐标信息
	const point2f& last_ball = model->get_ball_pos(1);

	/* 在点球开始前 根据点球球员的方向 计算出大致的截球点 */


	// FIELD_LENGTH_H = 300			半场长度
	// goalie_penalty_def_buf = 20	球门内宽度
	// -FIELD_LENGTH_H + goalie_penalty_def_buf   -300+20  为点球防守初始站位
	float x = -FIELD_LENGTH_H + goalie_penalty_def_buf;
	float y = p.y + tanf(dir)*(x - p.x);	// y = 对方点球球员的y轴坐标 + 对方球员的角度的tan值 * （防守点x - 防守球员x）


	/* 判断 当前帧 点球球员有无将球点出 若无 则守门员待在 门框内  return 守门员初始点x,y */

	// TODO: 禁止！ 多出口（return）的函数
	if ( fabs((last_ball - ball).x) > 1  ){		// 球被踢出

		/* 根据球 当前帧 和上一帧 的位置 计算出移动方向 并更新截球点 return 截球点x,y */
		
		// x 点坐标不变
		y = p.y + tanf(((last_ball - ball).angle())*(x - ball.x));	// y = 对方点球球员的y轴坐标 + 对方球员的角度的tan值 * （防守点x - 防守球员x）

		//(last_ball-ball).angle()


		return point2f(x, y);	// 返回/前往 计算出的截球点
	}
	else{	// 未将球点出
		return point2f(stayX, stayY);	// 呆在初始点
	}








	




	
	// 三目运算符  如果y>0 则把1赋值给convert 否则把-1赋值给convert
	int convert = y > 0 ? 1 : -1;

	//TODO:???
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

	task.target_pos = def_pos(model, penalty_kicker,opp_dir);		// 计算防守位置
	task.orientate = (ball - task.target_pos).angle();
	return task;
}