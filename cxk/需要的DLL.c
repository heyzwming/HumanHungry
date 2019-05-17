//技能大全
/*
下面写了一些基础的技能需求：
1.只吸球    
-- 实验发现： 仅仅调用吸球功能 会让机器人前往(0,0)点并开启吸球
2.吸着球跑
3.接到球马上平射
4.接到球马上挑射
5.接到球马上传球
6.拿到球转身
7.拿到球转身后秒传球
8.判断持球距离有无超过1m(视觉机每帧的时间*帧数*小车移动速度=小车运动距离；例如：if 0.8*num*6=100 then return "stop")
9.判断持球时间有无超过15s（视觉机每帧的时间*帧数=小车的持球时间；例如：if 0.8*num==15 then return "stop"）
*/

/*
一些技能其实用官方给的，组合一下也可以实现。但是我想也许写在一个dll上，执行速度会快一点？
其他的还无想出，暂时不需要。

*/
#include"utils/PlayerTask.h"
#include"utils/maths.h"
#include"utils/worldmodel.h"

//傻站着，开启吸球模式
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
PlayerTask task;
task.needCb = true;
cout<<"Only Open Cb"<<endl;
return task;
}
//吸着球跑
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
PlayerTask task;

task.needCb = true;
task.Targetpos = （x,y）;//这个x,y是从外面传进来的
cout<<"Run and Open Cb"<<endl;
return task;
}

//平射！！！接球秒射   ->到球的一瞬间，马上射门
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
PlayerTask task;
task.needCb = true;
task.kickPower=127;
task.needKick=true;
cout<<"Get Ball and Shoot Immediately"<<endl;
return task;
}

//挑射！！！接球秒射   ->到球的一瞬间，马上射门
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
PlayerTask task;
task.needCb = true;
task.kickPower = 127;
task.isChipPass=true;
cout<<"Get Ball and Chip Immediately"<<endl;
return task;
}

//接球秒传      虽然没搞明白传球跟射球有啥区别，不都是对着一个目标射吗（这样描述好像在搞黄色）
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
PlayerTask task;
task.needCb = true;
task.isPass=true;
cout<<"Get Ball and Pass Ball Immediately"<<endl;
return task;
}

//拿球转身    
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
PlayerTask task;
task.needCb = true;
task.orientate = get_our_player_dir(id)+180;
cout<<"Turn Back"<<endl;


return task;
}

//拿球转身秒传球    需要队友站位配合    
extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);

PlayerTask player_plan(const WorldModel* model, int robot_id){
PlayerTask task;
task.needCb = true;
task.orientate = get_our_player_dir(id)+180;
task.isPass=true;//isPass是个怎样的传球法？平射？挑射？力度如何？
cout<<"Turn Back and Pass Ball Immediately"<<endl;

return task;
}

