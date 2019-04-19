#ifndef PENALTYKICK_H
#define PENALTYKICK_H
#include "utils/PlayerTask.h"

class PenaltyKick
{
public:
	PenaltyKick();
	~PenaltyKick();
	PlayerTask plan(int id);
private:
	int opp_goalie();
};
typedef Singleton<PenaltyKick> penaltyKick;
#endif