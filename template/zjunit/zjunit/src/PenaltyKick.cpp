/************************************************************
*  函数名： PenaltyKick(Role_name_)							*
*															*
* 实现功能： 罚点球，在接受到罚点球命令后执行点球				*
*															* 
* 传入参数：	  参数名			参数类型		参数说明				* 
* 			role_name_       string     参数为执行者角色名	*
*															*
* 返回值：			无										*
*															*
* 说明： 罚点球时只有一名点球球员和一名点球防守球员				*
*															*
************************************************************/

/*rand随机数相关 http://www.runoob.com/w3cnote/cpp-rand-srand.html */

/*
计算机的随机数都是由伪随机数，即是由小M多项式序列生成的，其中产生每个小序列都有一个初始值，即随机种子。

（注意： 小M多项式序列的周期是65535，即每次利用一个随机种子生成的随机数的周期是65535，当你取得65535个随机数后它们又重复出现了。）

我们知道 rand() 函数可以用来产生随机数，但是这不是真正意义上的随机数，是一个伪随机数，

是根据一个数（我们可以称它为种子）为基准以某个递推公式推算出来的一系列数，

当这系列数很大的时候，就符合正态公布，从而相当于产生了随机数，

但这不是真正的随机数，当计算机正常开机后，这个种子的值是定了的，除非你破坏了系统。

*/

/*

1.rand()
功能:		随机数发生器

用法:		int rand(void)

rand() 的内部实现是用线性同余法做的，它不是真的随机数，因其周期特别长，故在一定的范围里可看成是随机的。

rand() 返回一随机数值的范围在 0 至 RAND_MAX 间。RAND_MAX 的范围最少是在 32767 之间(int)。用 unsigned int 双字节是 65535，四字节是 4294967295 的整数范围。

0~RAND_MAX 每个数字被选中的机率是相同的。

用户未设定随机数种子时，系统默认的随机数种子为 1。

rand() 产生的是伪随机数字，每次执行时是相同的; 若要不同, 用函数 srand() 初始化它。

*/

/* 
2. srand()
功能：		初始化随机数发生数 

用法：		void srand(unsigned int seed);

srand()用来设置rand()产生随机数时的随机数种子，如果每次 seed 都设相同值，rand() 所产生的随机数值每次就会一样。

rand() 产生的随机数在每次运行的时候都是与上一次相同的。

若要不同, 用函数 srand() 初始化它。可以利用 srand((int)(time(NULL)) 的方法，产生不同的随机数种子，因为每一次运行程序的时间是不同的。

*/

/*
3.产生一定范围随机数的通用表示公式

要取得 [a,b) 的随机整数，使用 (rand() % (b-a))+ a;

要取得 [a,b] 的随机整数，使用 (rand() % (b-a+1))+ a;

要取得 (a,b] 的随机整数，使用 (rand() % (b-a))+ a + 1;

通用公式: a + rand() % n；其中的 a 是起始值，n 是整数的范围。

要取得 a 到 b 之间的随机整数，另一种表示：a + (int)b * rand() / (RAND_MAX + 1)。

要取得 0～1 之间的浮点数，可以使用 rand() / double(RAND_MAX)。

*/

#include "PenaltyKick.h"
#include "def.h"
#include "utils/maths.h"
//#include "ParamReader.h"
#include <time.h> 

namespace{
	float penalty_kick_random_range = 30;
	float penalty_kick_get_ball_buf = -2;
}
PenaltyKick::PenaltyKick()	// 构造函数
{
	WorldModel worldModel;
	/* 初始化随机数发生数 void srand(unsigned int seed);

	srand()用来设置rand()产生随机数时的随机数种子，如果每次 seed 都设相同值，rand() 所产生的随机数值每次就会一样。

	rand() 产生的随机数在每次运行的时候都是与上一次相同的。
	
	若要不同, 用函数 srand() 初始化它。可以利用 srand((int)(time(NULL)) 的方法，产生不同的随机数种子，因为每一次运行程序的时间是不同的。
	
	*/
	srand((int)time(NULL));
	// TODO: ???未定义标识符 暂时注释掉这部分代码
//	DECLARE_PARAM_READER_BEGIN(PlayBotSkillParam)
//	READ_PARAM(penalty_kick_random_range)
//	READ_PARAM(penalty_kick_get_ball_buf)
//	DECLARE_PARAM_READER_END
}

/*
PenaltyKick::~PenaltyKick()
{
}
*/


//获得对方守门员编号
int PenaltyKick::opp_goalie(){
	WorldModel worldModel;

	// 对方守门员编号
	int opp_goalie_id = -1;
	// get_opp_exist_id 获得场上对方球员编号
	// 返回布尔类型数组  长度为6  1号球员对应下标0 ，2号球员对应下标1
	const bool* exist_id = worldModel.get_opp_exist_id();
	const point2f& opp_goal = -FieldPoint::Goal_Center_Point;	// opp_goal: 对方球门二维坐标位置
	float dist = 9999;	// ?

	// 在罚点球的情况下 ： 只有一名点球球员和一名点球防守球员
	for (int i = 0; i < MAX_ROBOTS; i++){	// 对场上每一个机器人(4V4 最多8个)遍历
		if (exist_id[i]){		// 如果该编号的球员上场了
			const point2f& pos = worldModel.get_opp_player_pos(i);	// 获得该球员位置
			// 球员与对方球门的距离
			float goal_opp_dist = (pos - opp_goal).length();	
			if (goal_opp_dist<dist){	// 如果球员与球门的距离小于 dist  
				dist = goal_opp_dist;	// 更新dist
				opp_goalie_id = i;		// 获得对方守门员编号
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

	// 判断是否 控到球 判断方法：球员与球的距离 和 角度
	bool get_ball = (ball - player).length() < get_ball_threshold - 3.5 && (fabs(anglemod(dir - (ball - player).angle())) < PI / 6);

	if (get_ball){	// 如果控到球
		task.kickPower = 127;
		task.isChipKick = false;
		task.needKick = true;
	}

	// TODO: 不理解这段判断语句的意义
	if (opp_goalie_num == -1){	// 如果没有检测到对方守门员的编号  直接return返回task
		task.target_pos = ball + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + penalty_kick_get_ball_buf, (ball - opp_goal).angle());
		task.orientate = (opp_goal - ball).angle();
		return task;
	};

	const point2f& opp = worldModel.get_opp_player_pos(opp_goalie_num);		//对方守门员位置
	
	int choose_cnt = 0;					// 计数器 对于点球方向的随机选择 的次数
	bool choose_succeed = false;		// 随机选择 生成 是否成功

	point2f choose_p, nearest_p;		// ?
	choose_p.x = FIELD_LENGTH_H;

	// TODO: 对于随机生成点球方向的部分没有完全理解  2019.4.19 22:40
	// 随机选择一个点球方向
	// 不停地随机（600次以内）生成一个点球选择  直到生成失败
	while (choose_cnt <600 && !choose_succeed)	// 当次数小于600次  且 生成成功
	{
		// TODO: 下面这句随机数生成语句  可能有错
		// 选择点球向的位置的y坐标     球门宽度为70cm   对方球门中点为（300，0）
		// 下面这条语句  相当于  rand() % (int)(penalty_kick_random_range - (-penaltykick_random_range) + 1) - penalty_kick_random_range
		// rand() % (int)(30 - (-30) + 1) - 30
		// 对应于 随机数生成公式中的 要取得 [a,b] 的随机整数，使用 (rand() % (b-a+1))+ a; 其中b = 30   a = -30
		// 即随机生成（300,-30） 到 (300,30)的点球目标点
		choose_p.y = rand() % (int)(penalty_kick_random_range * 2 + 1) - penalty_kick_random_range;	// float penalty_kick_random_range = 30

		// Vector::point_on_segment 返回线段x0（ball）-x1（choose_p）离向量p（opp）最近的点   最后一个参数flag = true时考虑线段的性质
		nearest_p = Vector::point_on_segment(ball,choose_p,opp,true);
		
		// TODO: 这里的判断条件还需要再考量一下
		if ((nearest_p - opp).length() > MAX_ROBOT_SIZE / 2 + BALL_SIZE / 2 + 2)
			choose_succeed = true;
		choose_cnt++;
	}
	// 目标点
	task.target_pos = ball + Maths::polar2vector(BALL_SIZE / 2 + MAX_ROBOT_SIZE + penalty_kick_get_ball_buf, (ball - choose_p).angle());
	task.orientate = (choose_p - ball).angle();
	return task;
}