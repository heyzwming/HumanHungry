#ifndef NORMALDEF_H
#define NORMALDEF_H
#include "utils/PlayerTask.h"
#include "utils/maths.h"
#include "utils/playerTask.h"
#include "utils/WorldModel.h"
enum PenaltyArea
{
	RightArc,		// �ұ߻���
		MiddleRectangle,
		LeftArc			// �� ����
};
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

#endif