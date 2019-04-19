#ifndef GORECEIVEPOS_H
#define GORECEIVEPOS_H
//#include "utils/PlayerSkill.h"
#include "utils/PlayerTask.h"
class GoReceivePos
{
public:
	GoReceivePos();
	~GoReceivePos();
	PlayerTask plan(int id);
private:
	bool opp_block_shoot(const point2f& runner,const point2f& ball,int& opp_block_id);
};
typedef Singleton<GoReceivePos> goReceivePos;

#endif