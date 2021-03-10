# HumanHungry!

人类：饥肠辘辘

# 2019年浙江省机器人竞赛


# 工作流（Workflow）

本团队将采用名为[**特征分支工作流**](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E4%BD%9C%E6%B5%81)的工作流来进行开发。也称为[Feature分支工作流](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/001376026233004c47f22a16d1f4fa289ce45f14bbc8f11000)。

在实际开发中，我们应该按照几个基本原则进行[分支管理](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/0013758410364457b9e3d821f4244beb0fd69c61a185ae0000)：

`master`分支是主分支，因此要时刻与远程同步；

`dev`分支是开发分支，团队所有成员都需要在上面工作，所以也需要与远程同步；

`bug`分支只用于在本地修复bug，就没必要推到远程了，除非老板要看看你每周到底修复了几个bug；

`feature`分支是否推到远程，取决于你是否和你的小伙伴合作在上面开发。

## 分支创建与合并

Git鼓励大量使用分支：

查看分支：`git branch`

创建分支：`git branch <name>`

切换分支：`git checkout <name>`

创建+切换分支：`git checkout -b <name>`

合并某分支到当前分支：`git merge <name>`

删除分支：`git branch -d <name>`

## 解决冲突

当Git无法自动合并分支时，就必须首先解决冲突。解决冲突后，再提交，合并完成。

解决冲突就是把Git合并失败的文件手动编辑为我们希望的内容，再提交。

用`git log --graph`命令可以看到分支合并图。

## 分支管理

首先，`master` 分支应该是非常稳定的，也就是**仅用来发布新版本**，平时不能在上面干活；

那在哪干活呢？干活都在`dev`分支上，也就是说，`dev`分支是不稳定的，到某个时候，比如1.0版本发布时，再把`dev`分支合并到`master`上，在`master`分支发布1.0版本；

你和你的小伙伴们每个人都在`dev`分支上干活，每个人都有自己的分支，时不时地往`dev`分支上合并就可以了。

所以，团队合作的分支看起来就像这样：

![branch](https://cdn.liaoxuefeng.com/cdn/files/attachments/001384909239390d355eb07d9d64305b6322aaf4edac1e3000/0)

Git分支十分强大，在团队开发中应该充分应用。

合并分支时，加上`--no-ff`参数就可以用普通模式合并，合并后的历史有分支，能看出来曾经做过合并，而`fast forward`合并就看不出来曾经做过合并。

## BUG分支

修复bug时，我们会通过创建新的bug分支进行修复，然后合并，最后删除；

当手头工作没有完成时，先把工作现场`git stash`一下，然后去修复bug，修复后，再`git stash pop`，回到工作现场。

## Feature分支

开发一个新feature，最好新建一个分支；

如果要丢弃一个没有被合并过的分支，可以通过`git branch -D <name>`强行删除。

## 多人协作

多人协作的工作模式通常是这样：

首先，可以试图用 `git push origin <branch-name>` 推送自己的修改；

如果推送失败，则因为远程分支比你的本地更新，需要先用 `git pull` 试图合并；

如果合并有冲突，则解决冲突，并在本地提交；

没有冲突或者解决掉冲突后，再用 `git push origin <branch-name>` 推送就能成功！

如果 `git pull` 提示 `no tracking information` ，则说明本地分支和远程分支的链接关系没有创建，用命令 `git branch --set-upstream-to <branch-name> origin/<branch-name>` 。

这就是**多人协作的工作模式**，一旦熟悉了，就非常简单。

## 总结

查看远程库信息，使用`git remote -v`；

本地新建的分支如果不推送到远程，对其他人就是不可见的；

从本地推送分支，使用`git push origin branch-name`，如果推送失败，先用`git pull`抓取远程的新提交；

在本地创建和远程分支对应的分支，使用`git checkout -b branch-name origin/branch-name`，本地和远程分支的名称最好一致；

建立本地分支和远程分支的关联，使用`git branch --set-upstream branch-name origin/branch-name`；

从远程抓取分支，使用`git pull`，如果有冲突，要先处理冲突。

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
5) 结合`二次开发手册` 和 `VS2013`（**PDF** 和 **IDE** 的搜索功能`Ctrl` + `F`）查阅官方函数的功能，另外在 **IDE** 中还能设置搜索范围为`当前文档`还是整个`解决方案`。
6) 部分变量中出现的 `arc` 是 **弧** 的意思，多出现在禁区相关的变量/常量/宏定义中。
7) 在原来的task函数包中的`vector2polar`我都已经修改成了`polar2vector`，如果有遗漏的 `vector2polar` 可以查看定义，这个函数的意思其实是**将极坐标转换成二维坐标**。
8) 在lua程序中，以下划线开头连接一串大写字母的名字（比如 _VERSION）被保留用于 Lua 内部全局变量。在默认情况下，变量总是认为是全局的。全局变量不需要声明，给一个变量赋值后即创建了这个全局变量，访问一个没有初始化的全局变量也不会出错，只不过得到的结果是：nil。
9) Lua for vs2013调试器 : 
    
    https://blog.csdn.net/babestudio/article/details/84685026
10) Task：**自定义 task 函数**
    * 自定义 task 函数，使用官方 `task.lua` 提供的标准入口函数`KickerTask()` 、 `ReceiverTask()` 、 `TierTask()` 、 `GoalieTask()`，通过加载用户自己编写的技能 `dll` 来实现。
    * 自定义 task 函数有 `KickerTask()`、 `ReceiverTask()`、 `TierTask()`、`DefenderTask()`、 `MiddleTask()`、 `GoalieTask()`；
    * 自定义 task 函数只能给指定的角色使用，如 `KickerTask` 对应 **Kicker(前锋)**，`ReceiverTask` 对应 **Receiver（中场）**、 `Tier` 对应 **Tier（后卫）**、 `GoalieTask`对应 **Goalie（守门员)** 等
11) 官方task函数调用官方提供的技能函数 Task：官方 task 函数主要有 `GetBall()`、 `PassBall()`、 `ReceiveBall()`、 `Shoot()`、`Goalie()`等 13 个；
12)  C++层Skill拓展方法： 
    player_plan 函数中对PlayerTask 对象实现自定义技能，扩展步骤如下：
* 参照 1.2.3 中的步骤搭建 C++开发环境，根据 4.4 中的框架使用 C++编写自定义技能
* 将编写好的技能编译生成 dll 文件，并将 dll 文件 copy 到 `user_skills` 目录下
* 根据 5.2 中的示例编写 LUA 脚本，通过自定义 task 函数调用用户自定义的技能
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

1)  完整防守带自定义.dll的play战术

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
20) 每个接口函数只能给指定的角色使用。函数中的参数就是读者的自定义skill 名称。例如：`Tier=task.TierTask（“myDef”）`，就是将 `myDef` 这个skill 给后卫使用。
21) 注意分清楚 官方task的调用框架和自定义task(.dll)的调用框架。
22) task函数的Lua程序的命名需要按照一定的格式。如Ref模式下的脚本程序要以`Ref_`开头
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
53) 挑球的最小机器人摆放距离是30cm，最大摆放距离是120cm

54) C++层可以使用#pragma region title 和 #pragma endregion 划分区块

55) 取放电池的时候小心一点！当心被划伤哦~~







# 当前任务

1) 将官方task函数通过lua进行调用测试并在测试中调试整定某些关键参数。
2) 思考每一个机器人足球运动员在C++ Skill层面除去官方的Skill函数包还应该有哪些动作。
3) 这些C++ 层的Skill有哪些可以改进的地方。
4) 针对Lua层所需要的dll，由官方的函数包改造出我们需要的dll（比如挑球）。
5) 
6) 将所有的task应用到一场play中。
7) 对方守门员可能使用的官方守门员程序，考虑针对官方守门员程序的针对程序。
8) 角球任意球：打守门员
9) 守门员Goalie.cpp 应用上最小二乘法。
10) 

# 我的任务

- [ ] 踢球开关和挑球开关同时开启会怎么样？
- [ ] 旋转踢球会怎么样？
- [ ] GetBall拿球参数调试,写一个朝向球拿球，接口为 `extern "C"_declspec(dllexport) PlayerTask player_plan(const WorldModel* model, int robot_id);`的C++ dll库。调试方法：完成一个有上述接口可以直接调用dll的库，
- [ ] 传球
- [ ] 最小二乘法防守算法。
- [ ] 在球运动轨迹上计算截球点并截球的dll
- [ ] 一些前往固定位置的GotoPos.dll
- [ ] NormalDef 在常规防守的状态下，使防守球员能在禁区边线面向 球 贴线防守
- [ ] PassBall传球程序有严重的参数调试问题。调整其中的参数使得传球过程更加稳定。
- [ ] 
- [ ] 





# C++层的小Tips

ChipKick 挑射
FlatKick 平射

设置task中的踢球参数：
		// kickPower	踢球力量
		// needKick		平踢球开关
		// isChipKick	挑球开关
        // task.needCb  设置task中的吸球开关为true，小车吸球

	bool needKick;						// 踢球动作执行开关
	bool isPass;						// 是否进行传球
	bool needCb;						// 是否吸球
	bool isChipKick;					// 挑球还是平射
	double kickPrecision;				// 踢球朝向精度
	double kickPower;					// 踢球力度
	double chipKickPower;				// 挑球力度	

const float&   player_ball_dir	= (fabs(anglemod(player_dir - (ball_pos - player_pos).angle())));	  // 球员的朝向 与 球员到球的方向 的角度差


迭代获得多个帧下的 球的坐标位置
	// vector<point2f> 以二维（浮点）坐标点为类型的 vector向量   
	// 一个存储球二维浮点型坐标点的数组
	vector<point2f> ball_points;
	ball_points.resize(8);	// 数组的大小改为8个元素

	// 迭代8次，将8次获取到的球的坐标存入 ball_points 向量
	for (int i = 0; i < 8; i++){
		const point2f& temp_points = model->get_ball_pos(i);
		ball_points.push_back(temp_points);
	}
	// TODO: 未知返回值
	return Maths::least_squares(ball_points);


    const bool* exist_id = model->get_opp_exist_id();	// 布尔数组  获得在场球员的编号 

# Lua层的小Tips：

获取拿球球员的编号：num是全局变量的情况
```lua
function OppGetBallNum()
    local oppTable = CGetOppNums()  -- 敌方所有上场球员编号
    -- pairs 迭代 table元素的迭代器 
	for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value    
		num = tonumber(val) -- 把 value 字符串转为数字
        if COppIsGetBall(num-1) then
			return true
		end		
	end
end
```

num 是本地变量的情况
```lua
function getOppNum()
    local oppTable = CGetOppNums()
    -- pairs 迭代 table元素的迭代器 
	for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value    
		local num = tonumber(val) -- 把 value 字符串转为数字
        if COppIsGetBall(num-1) then
			break
		end		
	end
	return num		-- 返回 拿球球员编号 num
end
```

获取地方没有拿球球员的编号
```lua
-- 获取对方没有拿球的球员编号
-- 暂时先把守门员也考虑进去了
-- 使用方法： local NoBallNum = OppNotGetBallNum()	声明一个本地变量 接收函数返回值（table类型）
function OppNotGetBallNum()
    local oppTable = CGetOppNums()  -- 敌方所有上场球员编号
    -- pairs 迭代 table元素的迭代器 
	for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value    
        local number = tonumber(val) -- 把 value 字符串转为数字
        local NoBallTable = {-1,-1,-1}
        if ~COppIsGetBall(number-1) then    -- number编号的球员没有拿到球
			NoBallTable[i] = number
        end	    	
    end
    return NoBallTable	-- 返回table类型
end
```
Lua的table类型下标默认从1开始的哦~




# 目录说明

<details>
<summary>bin</summary>
</details>



<details>
<summary>common</summary>
所有正式脚本的存放目录。

### lua_scripts

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
2) 此类 skill 在 lua_scripts\skill\PlayBotSkill 路径下，以独立的 lua 文件形式存在

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
1) Config.lua:
lua配置文件

2) play.lua:
战术表

3) PlayBot.lua:
路径配置文件

4) SelectPlay.lua:
选择战术

5) Skill.lua:
技能表

6) StartPlayBot.lua:
设置包路径为 `./lua_scripts/?.lua` ,同时使用require函数调用 `Config.lua` 和 `PlayBot.lua`
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

test
