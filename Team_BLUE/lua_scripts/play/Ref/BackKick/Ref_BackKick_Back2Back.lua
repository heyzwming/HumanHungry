
--desc: 

--[[

Ref_BackKick_Back2Back

发球球员Kicker挑球 给 背靠背的接应球员Receiver
对方阻挡球员在发球球员前方
接应球员在 阻挡球员的后方（背靠背）
发球球员挑球，越过阻挡球员和接应球员

伪代码：

敌我信息的获取
我方球员信息
敌方球员信息

四个球员朝向球的位置

通过球的具体位置  x  y  算出后场任意球发球球员的位置

找出距离球位置最近的地方球员编号  该球员即是对方任意球防守球员

⭐ 判断距离，如果 球到对方离球最近的防守队员的距离 + 我方接应队员的直径  大于  挑球最大距离  则可以执行挑球接应战术

⭐ 计算接应位置（其中的位置应该采用相对位置而不是绝对位置，因为对方防守球员会移动）

状态机模型

["Ready"]

Cbuf_cnt 延时一小会 return "GetBall"

站好位置
Kicker 在任意球的发球初始位置
Rece 在防守球员附近的随机位置
Tier 在禁区门口


["GetBall"]

如果拿到了球 return "PassBall"


Kicker 朝向某个球员拿球
Rece 随机站
Tier   随机站



["PassBall"]

Kicker 挑球传球
Rece 保持在防守球员的后方，朝向与防守球员相反
Tier 呆在中场偏前并随机改变位置

["ReceGetBall"]

Receiver去接球 
Kicker 去前场接应
Tier 呆在中场



然后就是各种各样的传球和射门状态机了~


]]


--[[ 获取敌方上场球员编号 ]]
GetOppNum = function()
    local oppTable = CGetOppNums()
    return oppTable
end


--[[  获取球的位置信息  ]]

GetBallX = function()
    local getBallX = CGetBallX()
    return getBallX
end

GetBallY = function()
    local getBallY = CGetBallY()
    return getBallY
end

--[[ 球与 Kicker 的距离 ]]

Ball2KickerDist = function()
    local ball2KickerDist = CBall2RoleDist("Kicker")
    return ball2KickerDist
end

--[[ 对方 距离球最近的球员 ]]
OppNearestNum = function()
    local dist = 9999   -- 距离初始化
    local Num = nil     -- 球员编号初始化为nil
    for i,val in pairs(GetOppNum) do -- 遍历 表 GetOppNum里的所有 key 和 value    
        
        num = tonumber(val) -- 把 value 字符串转为数字
        
        -- num-1 是因为lua层的车号从1开始 C++层从0开始
        if CBall2OppNumDist(num-1) < dist then
            dist = CBall2OppNumDist(num-1)
            Num = num
        end		
    end
    return Num
end

--[[ 对方 距离球最近的球员的坐标 ]]

OppNearestNumX = function()
    local oppNearestNumX = COppNum_x(OppNearestNum-1)
    return oppNearestNumX
end

OppNearestNumY = function()
    local oppNearestNumY = COppNum_y(OppNearestNum-1)
    return oppNearestNumY
end

--[[ 对方 距离球最近的球员的朝向 ]]

OppNearestNumDir = function()
    local oppNearestNumDir = COppNumDir(OppNearestNum-1)
    return oppNearestNumDir
end


-- 先假设在右半场

-- 变量要写在函数里面

KeepBallAwayX = function()
    local keepBallAwayX = 10   -- 常量调整值
    return keepBallAwayX
end

KeepBallAwayY = function()
    local keepBallAwayY = 10 -- 常量调整值
    return keepBallAwayY
end

Receiver2BallDir = function()
    local rece2BallDir = CRole2BallDir("Receiver")
    return rece2BallDir
end


Tier2BallDir = function()
    local tier2BallDir = CRole2BallDir("Tier")
    return tier2BallDir
end

gPlayTable.CreatePlay{

firstState = "Ready",

["Ready"] = {  -- 任意球开球前的排兵布阵
	switch = function()
		if Cbuf_cnt(true,20) then   -- 过 20 个时间单位 转到 GetBall 状态
			Return "GetBall"
        end
    end,
    -- 假设发球点在右半场
	Kicker      =   task.GotoPos("Kicker",CGetBallX()-KeepBallAwayX,CGetBallY()+KeepBallAwayY,Kicker2BallDir),  -- Kicker在任意球的发球初始位置
--	Receiver    =   task.GotoPos("Receiver",防守球员的x - X轴的随机位置,防守球员的y - Y轴的随机位置,与对方防守球员反方向),  -- 接应球员
 	Receiver    =   task.GotoPos("Receiver",OppNearestNumX - KeepBallAwayX,OppNearestNumY - KeepBallAwayY,Receiver2BallDir),
--    Tier        =   task.GotoPos("Tier",0,-150,朝向球的方向),
    Tier        =   task.GotoPos("Tier",0,-150,Tier2BallDir),
    Goalie      =   task.Goalie()
},

-- Kicker 去 拿球
["GetBall"] = {
    switch = function()
    -- 这里的15还需要考量 怎样判断已经拿到了球
    -- 然后还要进行判断 距离问题  是否采用背靠背传球战术
        if CBall2RoleDist("Receiver") < 15 then     -- 拿到了球 转向传球状态
    -- 考虑 判断条件使用下面这一个怎么样
    --  if CIsGetBall("Kicker") then
        --  if 距离足够 then
            return "PassBall"
        --  end
        end
    end,
    Kicker      =   task.GetBall("Kicker","Kicker")        -- Kicker 朝向球门拿球
--	Receiver    =   task.GotoPos("Receiver",防守球员的x - X轴的随机位置,防守球员的y - Y轴的随机位置,与对方防守球员反方向 即对方球员的方向+180度 lua里用的是角度制),  -- 接应球员
    Receiver    =   task.GoRecePos("Receiver",OppNearestNumX + KeepBallAwayX,OppNearestNumY - KeepBallAwayY,OppNearestNumDir-180),
--  Tier        =   task.GotoPos("Tier",0,-150,朝向球的方向),
    Tier        =   task.GotoPos("Tier",0,-150,Tier2BallDir),
    Goalie      =   task.Goalie()


--    Kicker = task.GoRecePos("Kicker"),
--    Receiver = task.GetBall("Receiver","Receiver"),
--    Goalie = task.Goalie()
},
    





["PassBall"] = {
    switch = function()
        if CIsBallKick("Receiver") then
            return "Shoot"
        end
    end,
    Kicker   = task.PassBall("Kicker","Receiver"),
    Receiver = task.GetBall("Receiver", "Tier"),
    Tier     = GoRecePos("Tier"),
    Goalie   = task.Goalie()
},
["Shoot"] = {
    switch = function()
        if CIsBallKick("Kicker") then
            return "finish"
        end
    end,
    Kicker = task.Shoot("Kicker"),
    Receiver = task.RefDef("Receiver"),
    Goalie = task.Goalie()
},
name = "Ref_BackKick_Back2Back"
}

