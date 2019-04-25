# RoboCup

Our target is International RoboCup and Star sea !


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
9) 


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

## 不用命令行的方法

参考[不用命令行的方法](https://jinlong.github.io/2015/10/12/syncing-a-fork/)

# 当前任务

1) 思考每一个机器人足球运动员在C++ Skill层面除去官方的Skill函数包还应该有哪些动作。
2) 这些C++ 层的Skill有哪些可以改进的地方。



# 更新日志
