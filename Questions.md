

1) [1] GetBall.cpp  第115行注释  意义不明

	//我方receier_id小车朝向信息，
	//注意：小车朝向为车头垂直方向与场地x轴正方向逆时针夹角
	const float rece_dir = model->get_our_player_dir(receiver_id);



2) [1] GetBall.cpp  第128行注释  意义不明

    //获得receive_ball_player到ball向量的角度，注意：所有角度计算为向量与场地x轴正方向逆时针夹角
        float receive2ball = (ball - receive_ball_player).angle();      // .angle() 弧度

3) [1]anglemod()  什么意思                      角度求模



4) [1] GetBall.cpp中 away_ball_dist_x 这个值越大  拿球越平滑  为什么                        拿球前的距离

5) [?]GetBall 中 对各个情况下的拿球目标点判断尚有不明

6) [1]提供的task函数包，里面是用C++用面向对象(class)的方式写的，但是好像和二次开发手册里的接口不太对应，我改成了面向过程的，能被编译成.dll  会有什么隐患吗？    

8) [1]我对库中的一些常量（宏定义的意义）不太明确

10) [1]PassBall.cpp中    paramReader.h以及其中的官方的PenaltyDef中的一段代码意义不明确           
        //DECLARE_PARAM_READER_BEGIN(PlayBotSkillParam)
        //READ_PARAM(goalie_penalty_def_buf)
        //DECLARE_PARAM_READER_END

// xml是一种配置文件格式，可以自定义param.xml 这个就是参数配置文件  <vechivle_vel> xxx </vechivle_vel>
tag 和json类似

11) [1]GoReceivePos.cpp   这里的3？有疑问       双保险
    //convert是反转参数，当ball在右半场时，convert为-1，当ball在左半场，convert为1
        // TODO: 3？
        int convert = (ball.y > 0 || fabs(ball.y) < 3) ? -1 : 1;


        // 程序的严谨性，双保险  || 符号的特性   防重影的双保险

12) [1]GoReceivePos.cpp   这一段的随机数生成不太明白

			float  x = rand() % (-10) - (rang_x - 10);		// b = 0  a = 10  rand() % (b-a) + ((-)ball.x -10)
			float  y = rand() % (-10) - (convert * (rang_y - 10));
13) [1]NormalDef.cpp 这一段中 目标点中 polar2vector函数的传入参数有点不明白  为什么又有 + PENALTY_AREA_R / 2 部分？


    case RightArc:
            //任务小车的朝向角及目标点
            task.orientate = (ball - goal).angle();
            // goal 我方球门中心点
            task.target_pos = goal + Maths::polar2vector(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R/2, task.orientate);	// 罚球区右边界80 + 最大机器人半径9 + 罚球区右边界80/2

            // 调试值

14) [1]PassBall.cpp 中 #define fast_pass 3  这个宏定义 的意义是什么   传球的距离？还是助跑？
    task.target_pos = ball + Maths::polar2vector(fast_pass, opp_goal_to_ball);

    助跑？：
    	//判断并执行传球
 	if (is_ready_pass(ball,excute_pos,rece_pos) ){	// 准备好传球了
		if (get_ball){		// 如果拿到了球，设置传球的属性
			task.kickPower = 50;
			task.needKick = true;
			task.isChipKick = false;
		}
		task.target_pos = ball + Maths::polar2vector(fast_pass, rece_to_ball);
		//printf("kicke ball\n");
		}

    task.target_pos = ball + Maths::polar2vector(fast_pass, rece_to_ball);这行代码没有else  传入的fast_pass是助跑的意思吗？


    // if (!getball && !(bool)isBallKick )  {task.target_pos = ball + Maths::polar2vector(fast_pass, rece_to_ball);}
    // dll程序运行到task.needKick = true 这一行的时候  就会执行 踢球操作 
    // 踢球的效率 同时也和 getball的判断准确度有关  如果getball判断准确  则踢球效率=高

15) [1]在原来的task函数包中的（面向对象的源码）单例模式，因为我把整个程序该成了面向过程的，去掉了单例模式有影响吗？
16) 在lua_scripts中 对应 二次开发手册 6.1.7 - 6.1.19部分的lua程序  例如 stop.lua中的返回值CRobotStop(..)是什么作用？什么意义。
17) [1]在lua层的哪里执行射门操作？因为在C++中只是设置了task的数据成员，并返回了PlayerTask类的task对象。
18) [1]在SOM中的一些txt需要关注吗？有什么具体的含义吗？例如SOM v3.3.3\Team_BLUE\ball fast\fastMatrices60.txt等
19) [1]~\SOM v3.3.3\Team_BLUE\params\KickParam.cfg 
20) 希望能对SOM系统下的lua有个简单的介绍
21) log 输出调试的什么意思
22) 如何调试？
23) 很多.lua都是空的 我想直到我们的开发流程  比如 先完善skill.cpp  再 写task  再 写 play  这些内容具体应该写在哪些地方（文件夹下）
24) lua层没讲清楚，包括task.lua 这个文件应该是作为task. ....的接口吧
25) 在二次开发手册的实战案例里，task.GetBall 这个GetBall应该是在哪个文件被声明定义的？如果我想要改/或者说增加这样的判断函数，要在哪里改，改哪些文件。
26) lua层可以直接调用的基础函数在哪。如果我们自己写这样的基础函数要怎么写，放在哪个文件夹下。
27) 写.dll的C++文件的接口，函数名必须为player_plan吗？传入参数必须只有2个吗（const WorldModel* model, int robot_id）
28) [1]GetBall.cpp中的变量，例如spiral_buff、get_ball_buf等
29) [1]GetBall.cpp 中开头有个函数（我改名成了isSimulate）叫void get_ball(const WorldModel* model)。目的是判断是否是模拟状态，有什么意义？
30) [1]Receiver_id 和 GetBall_id的含义有点模糊
31) 在宁大选拔题中，可以在纯lua程序中实现跑位和拿球、射门吗
32) play脚本怎么写，怎么在play脚本中完成衔接task的脚本
33) [1]像RefDef.cpp一样有3个参数的player_plan函数接口和有2个参数的player_plan在被lua调用的时候有什么区别
34) [1] 三个参数的接口是被其他task调用的而不是底层 底层调用的时候只能有2个参数
9) [?] 点球防守的初始点问题
10) [?]接上条，我写了一个PenaltyKick和一个PenaltyDef程序，其中SOM程序好像可以调用Kick.dll但是不能调用Def.dll







如何获得多个帧的图像数据  ML里的线性回归算法
const point2f& last_ball = model->get_ball_pos(1);  传入参数：0为当前帧 1为上一帧 2为上上帧

任意球防守 挡拆战术

有block球员的情况下的  挑球战术




