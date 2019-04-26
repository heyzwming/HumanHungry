# RoboCup

Our target is International RoboCup and star sea !

# 工作流（Workflow）

采用[**特征分支工作流**](https://git-scm.com/book/zh/v2/Git-%E5%88%86%E6%94%AF-%E5%88%86%E6%94%AF%E5%BC%80%E5%8F%91%E5%B7%A5%E4%BD%9C%E6%B5%81)

# 注意！

1) 将`SoccerPlanner3.exe` 、`~/Team_BLUE/PlayBot-SSL.exe` 、`~/Team_BLUE/SmallSim.exe` 、 `~/Team_YELLOW/PlayBot-SSL.exe` 、`~/Team_BLUE/SmallSim.exe` 设为**以管理员方式打开**。
2) 在阅读源码的时候建议：先**跳过**变量的声明和定义部分，直接从 `if` 、`for` 等语句开始，当遇到意义不明确的变量的时候，再去查看变量的意义。
3) 接上条：鼠标选中变量，右键->查看定义(Alt+F12)即可以快速跳转到变量的声明。
4) 使用Visual Studio 2013的**Tips**：
   *  使用 `//TODO: ` + `你要标记的内容`可以插入一个“书签”，“书签”名字不一定非要`//TODO:`，具体的设置参考 `工具` -> `选项` -> `环境` -> `任务列表`。查看书签的方式：`视图` -> `任务列表`
   *  在`解决方案资源管理器`中，按住`Ctrl`再选文件可以分别将不连续的文件选中。
   *  按住`Shift`可以将一片连续的文件选中。
   *  如果将一个.cpp文件或者.h文件选中，`右键` -> `从项目中排除` ，在生成.dll文件的时候就不会编译这些被排除的文件。


5) 注释符号`//`后面加个空格是我的习惯，加了空格的注释是我写的，没加空格的注释是官方的。
6) 结合`二次开发手册`（PDF的搜索功能`Ctrl` + `F`）查阅官方函数的功能。
7) 部分变量中出现的 `arc` 是 弧 的意思，多出现在禁区相关的变量/常量/宏定义中。
8) 在原来的task函数包中的vector2polar我都已经修改成了polar2vector，如果有遗漏的vector2polar 可以查看定义，这个函数的意思其实是将极坐标转换成二维坐标
9) 在整合版的skill工程文件中，如果将一个.cpp文件或者.h文件选中，`右键` -> `从项目中排除` ，在生成.dll文件的时候就不会编译这些被排除的文件。
10) 在lua程序中，以下划线开头连接一串大写字母的名字（比如 _VERSION）被保留用于 Lua 内部全局变量。在默认情况下，变量总是认为是全局的。全局变量不需要声明，给一个变量赋值后即创建了这个全局变量，访问一个没有初始化的全局变量也不会出错，只不过得到的结果是：nil。
11) Lua for vs2013调试器 https://blog.csdn.net/babestudio/article/details/84685026
12)  Task：**自定义 task 函数**
    1) 自定义 task 函数，使用官方 `task.lua` 提供的标准入口函数，通过加载用户自己编写的技能 `dll` 来实现。
    2) 自定义 task 函数有 `KickerTask()`、 `ReceiverTask()`、 `TierTask()`、`DefenderTask()`、 `MiddleTask()`、 `GoalieTask()`；
    3) 自定义 task 函数只能给指定的角色使用，如 KickerTask 对应 Kicker(前锋)，ReceiverTask 对应 Receiver（中场）、 Tier 对应 Tier（后卫）、 GoalieTask对应 Goalie（守门员）等
13) 官方taask函数调用官方提供的技能函数 Task：官方 task 函数主要有 `GetBall()`、 `PassBall()`、 `ReceiveBall()`、 `Shoot()`、`Goalie()`等 13 个；
14)  拓展方法： 
     player_plan 函数中对PlayerTask 对象实现自定义技能，扩展步骤如下：
    1. 参照 1.2.3 中的步骤搭建 C++开发环境，根据 4.4 中的框架使用 C++编写自定义技能
    2. 将编写好的技能编译生成 dll 文件，并将 dll 文件 copy 到 user_skills 目录下
    3. 根据 5.2 中的示例编写 LUA 脚本，通过自定义 task 函数调用用户自定义的技能
15)  战术框架主结构: 
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
16) task实战场景框架（调用自定义.dll）
17) 
```lua
    Receive = task.ReceiverTask("def")
    --ReceiverTask()函数调用用户自定义的 task 技能；
    --”def”技能由 C++编写设计， 生成的 def.dll 放置在 user_skills 中
    --每一个角色都有固定的自定义 task 函数
    --如 KickerTask()， TierTask()， GoalieTask()等
    --说明： def.dll 的源代码，用户可以在官方提供的 demo 中查看
```
18) 完整防守带自定义.dll的play战术
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
19) 我们的状态机模型是怎么被决策子系统理解并执行的呢？这就要依赖子系统lua架构中的SelectPlay.lua 和Play.lua 这两个脚本程序。其中的SelectPlay.lua 实现了“正常比赛”战术脚本和其他“场景”战术脚本之间的选择，Play.lua 实现状态机模型的解析，使决策子系统能理解我们写的战术脚本并正常调用战术脚本。所以，不建议用户修改SelectPlay.lua和Play.lua，会造成不可知的异常问题。
20) 每个接口函数只能给指定的角色使用。函数中的参数就是读者的自定义skill 名称。例如：Tier=task.TierTask（“myDef”），就是将myDef 这个skill 给后卫使用。
21) 注意分清楚 官方task的调用框架和自定义task(.dll)的调用框架。

# 如何更新fork项目的更新

## 命令行方法

### 1、配置上游项目地址。

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

### 2、获取上游项目更新。

使用 fetch 命令更新，fetch 后会被存储在一个本地分支 upstream/master 上。

```
➜ git fetch upstream
```

### 3、合并到本地分支。

切换到 master 分支，合并 upstream/master 分支。

```
➜ git merge upstream/master
```

### 4、提交推送。

根据自己情况提交推送自己项目的代码。

```
➜ git push origin master
```

由于项目已经配置了上游项目的地址，所以如果 fork 的项目再次更新，重复步骤 2、3、4即可。

## 不用命令行方法

参考[不用命令行的方法](https://jinlong.github.io/2015/10/12/syncing-a-fork/)

# 目录说明

## bin

## common

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

## oneNote

战术策略笔记/画板

## platforms

## RoboCup

Skill C++ 源文件

## Team_BLUE

蓝队的文件系统。

### ball \ data

### lua_scripts 

对脚本进行测试的时候要将脚本放到这里面然后导入SOM系统进行测试，测试通过再转成正式脚本。

### Params \ Pos \ Rotation

这三个文件都存放着一些.txt和.cfg

### user_skills

将Skill C++ 源代码编译生成的.dll库放在这个目录下，lua脚本在调用用户自定义.dll库的时候会自动在该目录下搜索。

## Team_YELLOW

## 其他文件

都是QT`SoccerPlanner3.exe`的足球机器人管理系统的用户图形界面的动态链接库(.dll)




# 当前任务

1) 思考每一个机器人足球运动员在C++ Skill层面除去官方的Skill函数包还应该有哪些动作。
2) 这些C++ 层的Skill有哪些可以改进的地方。



# 更新日志

## 4.25 

更新了所有的官方task函数包的注释。

## 4.26

1) 将多个skill (vs2013)工程整合到了一个RoboCup工程文件下，通过vs2013中项目的包含和排除来进行有选择性的编译
