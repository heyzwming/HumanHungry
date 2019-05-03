# RoboCup

Our target is International RoboCup and star sea !

# 工作流（Workflow）

本团队将采用名为[**特征分支工作流**](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E4%BD%9C%E6%B5%81)的工作流来进行开发。

# 注意！

1) 将`SoccerPlanner3.exe` 、`~/Team_BLUE/PlayBot-SSL.exe` 、`~/Team_BLUE/SmallSim.exe` 、 `~/Team_YELLOW/PlayBot-SSL.exe` 、`~/Team_BLUE/SmallSim.exe` 设为**以管理员方式打开**。
2) 在阅读源码的时候建议：先**跳过**变量的声明和定义部分，直接从 `if` 、`for` 等判断循环语句开始，当遇到意义不明确的变量的时候，再去查看变量的意义。
3) 使用Visual Studio 2013的**Tips**：
   *  快速查看变量的声明：选中变量，右键 -> 查看定义(`Alt`+`F12`)即可以（通过小窗口）快速跳转到变量的声明。
   *  “书签”标注：使用 `//TODO: ` + `你要标记的内容`可以插入一个“书签”，“书签”名字不一定非要`//TODO:`，具体的设置参考 `工具` -> `选项` -> `环境` -> `任务列表`。查看书签的方式：`视图` -> `任务列表`
   *  在`解决方案资源管理器`中，按住`Ctrl`再选文件可以分别将不连续的文件选中。
   *  按住`Shift`可以将一片连续的文件选中。
   *  如果将一个.cpp文件或者.h文件选中，`右键` -> `从项目中排除` ，在编译生成.dll动态链接库的时候就不会编译这些被排除的文件。

4) 注释符号`//`后面加个**空格**是我的习惯，加了空格的注释是我写的，没加空格的注释是官方的。
5) 结合`二次开发手册`（PDF的搜索功能`Ctrl` + `F`）查阅官方函数的功能。
6) 部分变量中出现的 `arc` 是 **弧** 的意思，多出现在禁区相关的变量/常量/宏定义中。
7) 在原来的task函数包中的`vector2polar`我都已经修改成了`polar2vector`，如果有遗漏的 `vector2polar` 可以查看定义，这个函数的意思其实是**将极坐标转换成二维坐标**
8)  在lua程序中，以下划线开头连接一串大写字母的名字（比如 _VERSION）被保留用于 Lua 内部全局变量。在默认情况下，变量总是认为是全局的。全局变量不需要声明，给一个变量赋值后即创建了这个全局变量，访问一个没有初始化的全局变量也不会出错，只不过得到的结果是：nil。
9)  Lua for vs2013调试器 : 
    
    https://blog.csdn.net/babestudio/article/details/84685026
10)  Task：**自定义 task 函数**
    
         1) 自定义 task 函数，使用官方 `task.lua` 提供的标准入口函数，通过加载用户自己编写的技能 `dll` 来实现。
         2) 自定义 task 函数有 `KickerTask()`、 `ReceiverTask()`、 `TierTask()`、`DefenderTask()`、 `MiddleTask()`、 `GoalieTask()`；
         3) 自定义 task 函数只能给指定的角色使用，如 KickerTask 对应 Kicker(前锋)，ReceiverTask 对应 Receiver（中场）、 Tier 对应 Tier（后卫）、 GoalieTask对应 Goalie（守门员）等
11) 官方taask函数调用官方提供的技能函数 Task：官方 task 函数主要有 `GetBall()`、 `PassBall()`、 `ReceiveBall()`、 `Shoot()`、`Goalie()`等 13 个；
12)  拓展方法： 
    player_plan 函数中对PlayerTask 对象实现自定义技能，扩展步骤如下：
    1. 参照 1.2.3 中的步骤搭建 C++开发环境，根据 4.4 中的框架使用 C++编写自定义技能
    2. 将编写好的技能编译生成 dll 文件，并将 dll 文件 copy 到 user_skills 目录下
    3. 根据 5.2 中的示例编写 LUA 脚本，通过自定义 task 函数调用用户自定义的技能
13)  战术框架主结构: 
```lua
gPlayTable.CreatePlay{ --红色部分为战术框架主结构
firstState = "",
[] = { --紫色部分为状态框架
    switch = function() --蓝色部分为状态跳转函数
        if ... then
        return ...
    end,
    Role = task --绿色部分为角色、任务分配
},
[] = {
    switch = function()
        if ... then
        return ...
    end,
    Role = task
    },
[] = {
    switch = function()
        if ... then
        return ..
    end,
    Role = task
},
name = "" --此处为脚本名
}
```
14)  task实战场景框架（调用自定义.dll）
  
```lua
    Receive = task.ReceiverTask("def")
    --ReceiverTask()函数调用用户自定义的 task 技能；
    --”def”技能由 C++编写设计， 生成的 def.dll 放置在 user_skills 中
    --每一个角色都有固定的自定义 task 函数
    --如 KickerTask()， TierTask()， GoalieTask()等
    --说明： def.dll 的源代码，用户可以在官方提供的 demo 中查看
```

15) 完整防守带自定义.dll的play战术

```lua
-- 示例战术脚本名为 Ref_KickDef.LUA
gPlayTable.CreatePlay{
firstState = "doCornerDef",
switch = function()
    return "doDef"
end,
["doDef"] = {
    Kicker = task.RefDef("Kicker"),
    Receive = task.ReceiverTask("def"),
    Goalie = task.Goalie()
},

name = "Ref_KickDef"
```
19) 我们的状态机模型是怎么被决策子系统理解并执行的呢？这就要依赖子系统lua架构中的 `SelectPlay.lua` 和`Play.lua` 这两个脚本程序。其中的 `SelectPlay.lua` 实现了“正常比赛”战术脚本和其他“场景”战术脚本之间的选择，`Play.lua` 实现状态机模型的解析，使决策子系统能理解我们写的战术脚本并正常调用战术脚本。所以，不建议用户修改`SelectPlay.lua` 和 `Play.lua`，会造成不可知的异常问题。
20) 每个接口函数只能给指定的角色使用。函数中的参数就是读者的自定义skill 名称。例如：Tier=task.TierTask（“myDef”），就是将myDef 这个skill 给后卫使用。
21) 注意分清楚 官方task的调用框架和自定义task(.dll)的调用框架。
22) task函数的Lua程序的命名需要按照一定的格式
23) both control，平时训练的时候开起来可以在一台PC控制双方队伍，在比赛的时候记得关掉，因为比赛的时候需要让裁判机对双方进行控制。
24) lua层中车号从 **1** 开始，C++层的车号从 **0** 开始
25) log调试输出 -> bot.txt：可以通过在C++层中加入 `cout` 语句输出调试信息，判断程序有没有进入到这一句中，并在~/SOM/bot.txt中查看log信息。
26) `CGetOppNums` 返回的 **table** 类型，其存储格式是{[0]=”n1”, [1]=”n2”,[2]=”n3”}，存储顺序是随机的；其中”n1”,”n2”,”n3”表示返回的车号，车号是 string 类型。在实际应用中，我们需要用 for...in pairs(table)do...的方式遍历 table 并找到场上敌方车号。
例如下面这段：
```lua
    function getOppNum()
        local oppTable = CGetOppNums()
        for i,val in pairs(oppTable) do 
            num = tonumber(val)
            if COppIsGetBall(num-1) then
                return true
            end	
        end
    end
```
其中 `val` 是**string**类型的，需要调用lua的官方函数`tonumber()`来将string类型转换成number类型。

27) 调试相关：通过 `#define DEBUG 1` `#ifdef DEBUG` `#endif` 来控制log日志输出
28) 在C++源代码中,`.angle()`返回的是**弧度**，在C++层中所有与角度有关的数值都是**弧度制**，而在Lua层中所有与角度有关的数值都是**角度制**。
39) `anglemode()`方法是求角度的模的运算，因为机器人球员的角度方向被限定于[-π,π]中，而如果在计算中或者传入的参数中有超过这个范围的值，将通过取模运算，重新回到这个范围内。
30) 在C++层有一些特定的常量/宏定义，如`GetBall.cpp`  `away_ball_dist_x`代表了一段拿球前的距离，当这个值越大，球员越不容易在拿球的过程中撞到球导致拿球不稳。
31) 一个存在于 `GoReceivePos.cpp` 的细节：
```C++
int convert = (ball.y > 0 || fabs(ball.y) < 3) ? -1 : 1;
```

这段代码中要考虑到`||`符号的特性：当`||`符号前的表达式为1，“或”符号后面的表达式将不执行。而后面的 `fabs(ball.y) < 3` 为的是提高程序的严谨性，防止双目摄像头的重叠区域产生的重影对视觉系统的误判，起到双保险的左右。 
32) `GoReceivePos.cpp` 中的一段随机数生成：

```C++
float  x = rand() % (-10) - (rang_x - 10);
float  y = rand() % (-10) - (convert * (rang_y - 10));
```
意义是在一块矩形1:2的区域内随机选择一个点位。
33) 在 `NormalDef.cpp` 中的这一段代码中，有一段程序：

```C++
case RightArc:
            //任务小车的朝向角及目标点
    task.orientate = (ball - goal).angle();// goal 我方球门中心点
    task.target_pos = goal + Maths::polar2vector(PENALTY_AREA_R + MAX_ROBOT_SIZE + PENALTY_AREA_R/2, task.orientate);	// 罚球区右边界80 + 最大机器人半径9 + 罚球区右边界80/2
```
其中的 `+ PENALTY_AREA_R/2` 为调试值，因根据实际的防守距离需要进行更改。

35) 在 `PassBall.cpp` 中有个宏定义 `#define fast_pass 3` 。

```C++
//判断并执行传球
if (is_ready_pass(ball,excute_pos,rece_pos) ){	// 准备好传球了
	if (get_ball){		// 如果拿到了球，设置传球的属性
		task.kickPower = 50;
		task.needKick = true;
		task.isChipKick = false;
		}   
    if (!getball && !(bool)isBallKick )  
        {task.target_pos = ball + Maths::polar2vector(fast_pass, rece_to_ball);}
    //printf("kicke ball\n");
}
```
.dll程序运行到 `task.neddKick = true;` 时就会执行踢球操作。

另一个方面，踢球的效率同时也和**getball**的判断准确度有关，如果**getball**的判断准确，则踢球的效率将非常的高。达到的效果就是刚接到球就能马上**shoot**。

36)  单例模式:WorldModel.在单例模式下，对于一个类，只能生成一个对象，让所有对这个类的调用都找到这个单例对象
// worldModel::getInstance()->  .... 

37)  C++层的skill函数的接口必须统一，且接口函数名必须为player_plan，传入参数必须为2个：（const WorldModel* model, int robot_id）。传入参数为多个（2个以上）说明该函数是要被被其他skill函数调用的。

38)  有些被定义但没有别用到的是老版本的变量，不用在意。

39)  如果配置play脚本战术？
    1) 手工配置战术包  
    2) 在C++或者Lua里把所有战术都配置好一本万利

40)  lua程序的名字要按照一定的规则命名  **Ref_ xxxxxx.lua**。

41)  如何获得多个帧的图像数据？将多个球位置信息通过ML里的线性回归算法/最小二乘法得出一个拟合的直线并预测出球的轨迹。

```C++
const point2f& last_ball = model->get_ball_pos(1);
```

传入参数：0为当前帧 1为上一帧 2为上上帧。

43) 任意球防守考虑**挡拆**战术。

44)  有block球员的情况下，使用**挑球**战术。

45)  如果机器人跑到了(0,0)点，说明.dll动态链接库出错了或者根本没有找到.dll动态链接库。

46) 频点： 蓝队为3  0011 ，黄队为5  0101

48) 当比赛暂停的时候，调用的脚本为~\SOM v3.3.3\Team_BLUE\lua_scripts\play\Ref\GameStop\Ref_Stop.lua

49) 在Ref文件夹下的.lua脚本（如GameHalt.lua\GameOver.lua\GamaStop.lua等）都会调用相应Ref文件夹下的子文件夹下的 lua 脚本。

50) 在 ~\SOM v3.3.3\Team_BLUE\lua_scripts\play\Ref\
OurindirectKick.lua 中 会在 裁判裁定为任意球中 根据球的x坐标位置判定为 角球、中/中/后场任意球。

51) 在GameHalt.lua  GameOver.lua 中，触发这两种情况后，会调用Ref_Halt.lua，使得所有机器人急停。由SOM底层自动调用。

52) 获得对方所有球员编号的tip：

```lua
function getOppNum()
	local oppTable = CGetOppNums()
	for i,val in pairs(oppTable) do 
		num = tonumber(val)
		if COppIsGetBall(num-1) then
			return true
		end
		
	end
end
```

53) 取放电池的时候小心一点！当心被划伤哦~~





# 当前任务

1) 将官方task函数通过lua进行调用测试。
2) 思考每一个机器人足球运动员在C++ Skill层面除去官方的Skill函数包还应该有哪些动作。
3) 这些C++ 层的Skill有哪些可以改进的地方。
4) 将所有的task应用到一场play中。
4) 对方守门员可能使用的官方守门员程序，考虑针对官方守门员程序的针对程序。
5) 角球任意球：打守门员
6) 



# 更新日志

<details>
<summary>4.25</summary>

更新了所有的官方task函数包的注释。
</details>




<details>
<summary>4.26</summary>

1) 将多个skill (vs2013)工程整合到了一个RoboCup工程文件下，通过vs2013中项目的包含和排除来进行有选择性的编译
</details>

<details>
<summary>4.27</summary>

1) 江湖哥培训，解决C++层与Lua层疑问,更新至`注意`中。
</details>

<details>
<summary>4.28 </summary>

1) 将4.27培训的疑问都更新并整理到了`注意`区。
2) 将官方的C++层task函数都编译生成了.dll动态链接库并放置于 `user_skills` 下。
</details>

<details>
<summary>4.30</summary>

规范了头文件和源文件的内容，将 `#include` 、 `枚举定义` 、 `命名空间定义` 都放在了头文件里。
</details>

<details>
<summary>5.1</summary>

1、更新了Markdown语法的折叠功能，使得README界面更美观。
2、编写开球站位dll：KickOff_init.cpp 和 KickOff_init.h
3、更新了“cxk”工作日志板块。

</details>


# 目录说明

<details>
<summary>bin</summary>
</details>



<details>
<summary>common</summary>
所有正式脚本的存放目录。


<details>
<summary>lua_scripts</summary>
所有的lua脚本都被放置在这个目录下。

#### oppnent

在这个文件夹下的都是在SOM系统下生成的战术包名称。

#### play

play脚本层，所有通过页面的“脚本导入”功能导入的脚本，都会自动存放在这个目录下。

##### Nor

在没有裁判盒指令干预下执行的正式脚本，称为正常脚本，当用户在选择转正式脚本时，如果选择的战术类型为“Normal”，系统会自动存放在 Nor 目录下。

##### Ref

在裁判盒指令干预下执行的正式脚本，称为裁判脚本，当用户在选择转正式脚本时，如果选择的战术类型为裁判指令对应的战术类型，系统会自动存放到 Ref 目录下。

开球、暂停、点球、角球、任意球。

##### Test

没有转为正式脚本之前的脚本都会被放置在Test目录下


#### skill

在skill文件夹下还有个文件夹叫 `PlayBotSkill` ，在 `PlayBotSkill` 文件夹外的文件是官方提供的自定义task函数.lua，例如KickerTask、ReceiverTask等

在`PlayBotSkill`下的是官方 task 函数.lua，调用官方提供的技能函数；
· 每一个官方 task 函数完成一项技能，并且可以指派给所有的角色使用。如GetBall\Goalie等

⚫ 官方 skill 函数
1) 官方提供的 skill 函数调用官方提供的 cpp
2) 此类 skill 在 lua_scripts\skill\PlayBotSkill 路径下，以独立的 lua 文件
形式存在
⚫ 用户自定义 skill 函数
1) 用户自定义 skill 需要用户使用 C++编写，最终以 dll 的方式加载到user_skills目录下

#### worldmodel

本文件夹下的task.lua中包含的是官方的task函数包的调用接口。即二次开发手册6.1的部分

⚫ 6.1.1-6.1.6 函数为官方提供的自定义 task 函数，传入用户编写的 dll 技
能，实现扩展
⚫ 每个自定义 task 函数指定给对应的角色使用，如 KickerTask 对应 Kicker（前锋）、 ReceiverTask 对应 Receiver（中场）等。
⚫ 使用方法示例：
Kicker = KickerTask(“dll 名称” , pos_,dir_,kickflat_,kp_,cp_)

**我们把一次运动决策所分配到各个机器人所需各自执行的任务称为 task。每个 task 以函数的形式存在，函数定义在 task.lua 文件中。**

#### 其他.lua文件

1) Config.lua

lua配置文件

2) play.lua

战术表

3) PlayBot.lua

路径配置文件

4) SelectPlay.lua

选择战术

5) Skill.lua

技能表

6) StartPlayBot.lua

设置包路径为 `./lua_scripts/?.lua` ,同时使用require函数调用 `Config.lua` 和 `PlayBot.lua`
</details>
</details>




<details>
<summary>oneNote</summary>
战术策略笔记/画板
</details>

<details>
<summary>platforms</summary>
</details>

<details>
<summary>RoboCup</summary>
Skill C++ 源文件
</details>

<details>
<summary>Team_BLUE</summary>
蓝队的文件系统。

### ball \ data

### lua_scripts 

对脚本进行测试的时候要将脚本放到这里面然后导入SOM系统进行测试，测试通过再转成正式脚本。

### Params \ Pos \ Rotation

这三个文件都存放着一些.txt和.cfg



### user_skills

将Skill C++ 源代码编译生成的.dll库放在这个目录下，lua脚本在调用用户自定义.dll库的时候会自动在该目录下搜索。

</details>



<details>
<summary>Team_YELLOW</summary>
</details>



<details>
<summary>其他文件</summary>
都是QT`SoccerPlanner3.exe`的足球机器人管理系统的用户图形界面的动态链接库(.dll)
</details>



# 如何更新fork项目的更新

## 命令行方法



<details>
<summary>1、配置上游项目地址</summary>

即将你 fork 的项目的地址给配置到自己的项目上。比如我 fork 了一个项目，原项目是 `wabish/fork-demo.git`，我的项目就是 `cobish/fork-demo.git`。使用以下命令来配置。
```
➜ git remote add upstream https://github.com/wabish/fork-demo.git
```
然后可以查看一下配置状况，很好，上游项目的地址已经被加进来了。
```
➜ git remote -v
origin  git@github.com:cobish/fork-demo.git (fetch)
origin  git@github.com:cobish/fork-demo.git (push)
upstream    https://github.com/wabish/fork-demo.git (fetch)
upstream    https://github.com/wabish/fork-demo.git (push)
```
</details>

<details>
<summary>2、获取上游项目更新。</summary>

使用 fetch 命令更新，fetch 后会被存储在一个本地分支 upstream/master 上。

```
➜ git fetch upstream
```
</details>


<details>
<summary>3、合并到本地分支。</summary>

切换到 master 分支，合并 upstream/master 分支。

```
➜ git merge upstream/master
```
</details>


<details>
<summary>4、提交推送。</summary>

根据自己情况提交推送自己项目的代码。

```
➜ git push origin master
```
由于项目已经配置了上游项目的地址，所以如果 fork 的项目再次更新，重复步骤 2、3、4即可。
</details>



## 不用命令行方法

参考[不用命令行的方法](https://jinlong.github.io/2015/10/12/syncing-a-fork/)


# Markdown的折叠语法

<details>
<summary>Title</summary>

content!!!
</details>