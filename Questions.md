

1) GetBall.cpp  第115行注释  意义不明

	//我方receier_id小车朝向信息，
	//注意：小车朝向为车头垂直方向与场地x轴正方向逆时针夹角
	const float rece_dir = model->get_our_player_dir(receiver_id);

2) GetBall.cpp  第128行注释  意义不明

    //获得receive_ball_player到ball向量的角度，注意：所有角度计算为向量与场地x轴正方向逆时针夹角
        float receive2ball = (ball - receive_ball_player).angle();

3) anglemod()  什么意思


4) GetBall.cpp中 away_ball_dist_x 这个值越大  拿球越平滑  为什么

5) GetBall 中 对各个情况下的拿球目标点判断尚有不明

6) 贵公司提供的task函数包，里面是用C++用面向对象(class)的方式写的，但是好像和二次开发手册里的接口不太对应，我改成了面向过程的，能被编译成.dll  会有什么隐患吗？
7) 接上条，我写了一个PenaltyKick和一个PenaltyDef程序，其中SOM程序好像可以调用Kick.dll但是不能调用Def.dll
8) 我对库中的一些常量（宏定义的意义）不太明确
9) 点球防守的初始点问题
10) PassBall.cpp中    paramReader.h以及其中的官方的PenaltyDef中的一段代码意义不明确
        //DECLARE_PARAM_READER_BEGIN(PlayBotSkillParam)
        //READ_PARAM(goalie_penalty_def_buf)
        //DECLARE_PARAM_READER_END
11) GoReceivePos.cpp   这里的3？有疑问
    //convert是反转参数，当ball在右半场时，convert为-1，当ball在左半场，convert为1
        // TODO: 3？
        int convert = (ball.y > 0 || fabs(ball.y) < 3) ? -1 : 1;
12) GoReceivePos.cpp   这一段的随机数生成不太明白

			float  x = rand() % (-10) - (rang_x - 10);		// b = 0  a = 10  rand() % (b-a) + ((-)ball.x -10)
			float  y = rand() % (-10) - (convert * (rang_y - 10));
13) NormalDef.cpp 这一段中 目标点中 polar2vector函数的传入参数有点不明白  为什么又有 + PENALTY_AREA_R / 2 部分？


    case RightArc:
            //任务小车的朝向角及目标点
            task.orientate = (ball - goal).angle();
            // goal 我方球门中心点
            task.target_pos = goal + Maths::polar2vector(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R/2, task.orientate);	// 罚球区右边界80 + 最大机器人半径9 + 罚球区右边界80/2



