Kicker2BallDir = function()
	return CRole2BallDir("Kicker")
end

Receiver2BallDir = function()
	return CRole2BallDir("Receiver")
end

Tier2BallDir = function()
	return CRole2BallDir("Tier")
end

Player[4]={"Kicker","Reciever","Tier","Goalie"}//把每个球员放入数组中
i=0

Whogetball= function()   //得知谁控球
    while i<5 do
        if CIfavailable(Kicker)==ture then
            return a[i]
        end
    end
end
    

Whocanreceiveball=function() //得知该传给谁
    while i<4 do //除去守门员
        if CIfavailable(Whogetball,a[i])==ture then
            return a[i]
        end
    end,    
end

CanShoot=function() //平射
    if CIfavailable(Whogetball,Whocanreceiveball)==ture then
        return ture
    end
end
    

CanChip=function()
    if CIfavailable(Whogetball,Whocanreceiveball)==nil then
        return ture
    end
end

gPlayTable.CreatePlay{
    firstState = "Start",      //球已经发出来了
        
    ["Start"] = {
        switch = function ()		-- 状态跳转
            if CNormalStart() then	-- CNormalStart 裁判盒有无发送 开球指令
                return "Kickoff"	-- 转到 开球 状态
            elseif CGameOn() then	-- 比赛是否开始
                return "finish"		-- 结束本状态机
            end
        end,
        --Kicker = task.GotoPos("Kicker",-20,0,Kicker2BallDir),   //阵型
        --Receiver = task.GotoPos("Receiver",-30,120,Receiver2BallDir),
        --Tier = task.GotoPos("Tier",-30,-120,Tier2BallDir),
        --Goalie = task.Goalie(),         //站到指定位置
        --Kicker.needCb =true  //??Kicker开启吸球模式
        开球结束，混战开始
        if CIsGetBall(Kicker) == true or CIsGetBall(Receiver) == true or CIsGetBall(Tier) == true then
            return "KickOff"
        else then 
            return "Grab"//抢球模式
    },

    ["KickOff"] = {
        switch = function()
            if CGameOn() then
                return "finish"
            elseif CIsGetBall("Kicker") and CBall2PointDist(303,0)>160 and CHoldingtime(Kicker)>15 and CHoldingdist(Kicker)>100 and CIfavailable(Kicker)==ture then	-- 如果kicker拿到球 则 转到 传球状态
                return "passball" //需要写holdingtime和holdingdistance和CIfavailable的函数
            end
        end,
        
        Kicker = task.GetBall("Kicker","Kicker"),	-- 朝向球门拿球
        Receiver = task.GotoPos("Receiver",-30,120,Receiver2BallDir),
        Tier = task.GotoPos("Tier",-30,-120,Tier2BallDir),
        Goalie = task.Goalie()//其他3名队员位置不改变
    },
    
    ["Passball"]={
        switch = function()
            While i<5 do
                if COurRole2RoleDist(a[i],opp players)<32 and CanChip(i) == false then
                    Chip(Whogetball,0000)
                else if CanChip(i)



    }

    ["Grab"]={
        switch = function()
            
    }
    