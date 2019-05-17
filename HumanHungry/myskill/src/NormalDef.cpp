/************************************************************
* 普通防守函数函数名： NormalDef								*
*															*
* 实现功能： 简单的射门线阻挡防守								*
*															*
* 具体描述： 												*
*															*
*															*
* 返回值：			PlayerTask								*
*															*
* 说明：														*
*															*
************************************************************/


// TODO: Arc  弧线

#include "NormalDef.h"

PlayerTask player_plan(const WorldModel* model, int robot_id){
	//创建PlayerTask对象task，task对象是一个任务方法集合
	PlayerTask task;

	/***********************************参数获取*******************************************************/
	const point2f& goal = FieldPoint::Goal_Center_Point;
	const point2f& arc_center_right = FieldPoint::Penalty_Arc_Center_Right;		// (605/2 ,  35/2)，右弧线的圆心
	const point2f& arc_center_left = FieldPoint::Penalty_Arc_Center_Left;		// (605/2 , -35/2)，左弧线的圆心
	const point2f& rectangle_left = FieldPoint::Penalty_Rectangle_Left;			// (-605/2 + 80 , -35/2 )中心矩阵的左边界
	const point2f& rectangle_right = FieldPoint::Penalty_Rectangle_Right;		// (-605/2 + 80 ,  35/2 )
	const point2f& ball_pos = model->get_ball_pos();


	//area为枚举变量，根据不同的ball位置，设置不同的枚举值
	/***********************************将球分成了左中右 (-200,-35/2) (-35/2,35/2) (35/2,200)*************************/
	PenaltyArea area;
	if (ball_pos.y > arc_center_right.y)		// 球的y坐标 在 右弧线的右边
		area = RightArc;
	else if (ball_pos.y < arc_center_left.y)	// 左弧线的左边
		area = LeftArc;
	else
		area = MiddleRectangle;

	cout << "---------------球的x坐标" << ball_pos.x << "       球的y坐标" << ball_pos.y << "-------------" << endl;

	//switch根据不同的area值，设置不同的task
	switch (area)
	{
	case RightArc:
		//任务小车的朝向角及目标点
		task.orientate = (ball_pos - goal).angle();
		// goal 我方球门中心点
		task.target_pos = goal + Maths::polar2vector(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R/2, task.orientate);	// 罚球区右边界80 + 最大机器人半径9 + 罚球区右边界80/2

		cout << "*****************************RightArc右侧弧线**********************************" << endl;
		cout << "-----------------------------机器人朝向" << task.orientate << "---------------------" << endl;
		cout << "-----------------------------机器人的目的地" << task.target_pos << "-------------------" << endl;
		cout << "-----------------------------枚举类型area" << area << "-----------------------" << endl;
		cout << "-----------------------------" << "" << "" << endl;


		break;

		//TODO: 这一段的代码非常有使用价值！！ 当对方球 入射轨迹将经过我们禁区的中心矩形区域
	case MiddleRectangle:
		task.orientate = (ball_pos - goal).angle();

		//across_point(p1, p2, p3, p4)函数是求p1p2线段和p3p4线段的交点
		task.target_pos = Maths::across_point(rectangle_left, rectangle_right, ball_pos, goal);		// 求出 我方禁区中心矩形部分 和 球与我们球门中心  的交点。其中goal实参还需考量，因为对方不一定会瞄准球门中心射门！ 要通过球的当前帧与上一帧的位置来计算

		cout << "*****************************MiddleRectangle中场矩形区域*****************************" << endl;
		cout << "-----------------------------机器人朝向" << task.orientate << "---------------------" << endl;
		cout << "-----------------------------机器人的目的地" << task.target_pos << "-------------------" << endl;
		cout << "-----------------------------枚举类型area" << area << "-----------------------" << endl;
		cout << "-----------------------------" << "" << "" << endl;

		break;
	case LeftArc:
		task.orientate = (ball_pos - goal).angle();
		task.target_pos = goal + Maths::polar2vector(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R / 2, task.orientate);
		break;
	default:
		break;
	}

	return task;
}