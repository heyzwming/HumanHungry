#ifndef GOALIE_H
#define GOALIE_H
//#include "utils/PlayerSkill.h"
#include "utils/PlayerTask.h"
class Goalie
{
public:
	Goalie();
	~Goalie();
	PlayerTask plan(int id);

private:
	bool is_inside_penalty(const point2f& p );
};

typedef Singleton<Goalie> goalieSkill;
#endif