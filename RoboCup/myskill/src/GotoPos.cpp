/************************************************************
* ��λ�������������� GotoPos								*
*															*
* ʵ�ֹ��ܣ� ָ����λ��										*
*															*
* ���������� 												*
*															*
*															*
* ����ֵ��			PlayerTask								*
*															*
* ˵����														*
*															*
************************************************************/

#include "GotoPos.h"

PlayerTask player_plan(const WorldModel* model, float x, float y, float dir){
	PlayerTask task;
	task.target_pos.x = x;
	task.target_pos.y = y;
	task.orientate = dir;
	return task;
}

