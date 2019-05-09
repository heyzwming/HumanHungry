
-- 1、变量的命名规范
-- 2、注释
-- 3、跳过开球部分
-- 4、敌我站位的分析和战术的选择
-- 5、尽可能使用 local声明 本地变量
-- 6、先建立框架，思考战术，再编程=


--[[ 获得球员朝向球的方向 ]]
Kicker2BallDir = function()
	return CRole2BallDir("Kicker")
end

Receiver2BallDir = function()
	return CRole2BallDir("Receiver")
end

Tier2BallDir = function()
	return CRole2BallDir("Tier")
end

-- 二次手册中的普通函数(被lua层调用) 中，如果传入参数是id的，要从0开始(函数内部有+处理)，传入的参数也不应该用纯粹的数字，应该用变量，

--[[  参考这一段：  对方 距离球最近的球员

        获取敌方上场球员编号 
GetOppNum = function()
    local oppTable = CGetOppNums()
    return oppTable
end

        对方 距离球最近的球员
OppNearestNum = function()
    local dist = 9999   -- 本地变量  距离初始化
    local Num = nil     -- 本地变量  球员编号初始化
    for i,val in pairs(GetOppNum) do    -- 迭代遍历 表 GetOppNum里的所有 key 和 value    
        num = tonumber(val)             -- 把 value 字符串转为数字
        
        -- num-1 是因为lua层的车号从1开始 C++层从0开始，而被lua函数调用的(二次开发手册中的)普通函数底层代码是用C++写的
        if CBall2OppNumDist(num-1) < dist then
            dist = CBall2OppNumDist(num-1)
            Num = num
        end		
    end
    return Num
end
]]

OppPlayer2BallDir1 = function()
	return COppNum2BallDir(1)
end

OppPlayer2BallDir2 = function()
	return COppNum2BallDir(2)
end

OppPlayer2BallDir3 = function()
	return COppNum2BallDir(3)
end

OppPlayer2BallDir4 = function()
	return COppNum2BallDir(4)
end

--[[ 把每个球员放入数组中 ]]

Player[4]={"Kicker","Reciever","Tier","Goalie"} 

i=1 -- 定义全局 循环下标变量 i

WhoGetBall = function()   --//得知谁控球       --   注释的符号是 两个减号哦 “-- ...”  多行注释： “--[[ ... ]]”
    while i<5 do
        if COppIsGetBall(i) == true then
            result=2
        end
        
        if CIsGetBall(a[i-1]) == true then          -- a是什么？？？
            result = 1
        end
    end
    return result
end

WhoCanReceiveBall = function() -- 得知该传给谁 错错错
    while i<3 do    -- 除去守门员                   -- TODO:除去守门员 也是不应该这么写
        if CIfavailable(Whogetball,a[i])==ture then     
            return a[i]
        end
    end
end

CanShoot = function()     -- 可以平射 错错错
    if CIfavailable(Whogetball,Whocanreceiveball) == ture then
        return 1
    end
end
    

CanChip=function()      -- 可以挑射 错错错
    if CIfavailable(Whogetball,Whocanreceiveball) == nil then
        return 1
    end
end

OppGoalie=function()
    while i<5 do
        if COppNumx(i) => 582.75 and -80<COppNum_y(i)<80 then
            return i
        end
    end
end

BallPosition=function()
    if COurRole_x("Kicker")>180 then
        return 1
    elseif COurRole_x("Kicker")>-180 then
        return 2
    else
        return 3
    end
end





gPlayTable.CreatePlay{
firstState = "Start",     --- //球已经发出来了
        
["Start"] = {
    switch = function ()		
        
        if CIsGetBall("Kicker") == false or CIsGetBall("Receiver") == false or CIsGetBall("Tier") == false then
            -- 这里应该return "Defence"
            return "finish" --没拿到球，跳出，转到防守战术   

        elseif BallPosition == 1 then --前场
            return "FrontCourt"

        elseif BallPosition == 2 then --中场
            return "MidCourt"

        elseif BallPosition == 3 then --后场
            return "BackCourt"
        end
      
    end,
   
},

--[[["KickOff"] = {
    switch = function()
        if CGameOn() then
            return "finish"
        elseif CIsGetBall("Kicker") and CBall2PointDist(303,0)>160 and CHoldingtime(Kicker)>15 and CHoldingdist(Kicker)>100 and CIfavailable(Kicker)==ture then	-- 如果kicker拿到球 则 转到 传球状态
            return "passball" -- 需要写holdingtime和holdingdistance和CIfavailable的函数
        end
    end,
    
    Kicker = task.GetBall("Kicker","Kicker"),	-- 朝向球门拿球
    Receiver = task.GotoPos("Receiver",-30,120,Receiver2BallDir),
    Tier = task.GotoPos("Tier",-30,-120,Tier2BallDir),
    Goalie = task.Goalie()  -- //其他3名队员位置不改变
},

["Passball"]={
    switch = function()
       while i<5 do
if COurRole2RoleDist(a[i],opp players)<32 and CanChip(i) == 0 then
                Chip(Whogetball,0000)
            else if CanChip(i)
}]]

["FrontCourt"]={
    switch = function()
    if abs(COppNumDir(OppGoalie))+abs(COurRoleDir(WhoGetBall))==180
    执行骗人战术，战术还没写！！
    elseif NoOthers==1 then
        WhoGetBall = task.Shoot(WhoGetBall)
    elseif NoOthers==0 then
        挑射！！



}

["MidCourt"]={
    switch = function()
        三人传球战术，没写！！
        
}

["BackCourt"]={
    switch = function()
        三人长距离传球战术，没写！！
        
}