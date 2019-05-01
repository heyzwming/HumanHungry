--desc: 中场开球
--desc: 
--desc: 设置开球初始点
--  official lua scripts


--[[kickerdir = function()
	return CRole2BallDir("Kicker")
end

ReceiverDir = function()
	return CRole2BallDir("Receiver")
end

oppGoalDir = function()
	return CRole2OppGoalDir("Receiver")
end

gPlayTable.CreatePlay{

firstState = "start",
	
["start"] = {
	switch = function ()
		if CNormalStart() then
			return "KickOff"
		elseif CGameOn() then
			return "finish"
		end
	end,
	Kicker = task.GotoPos("Kicker",-50,0,kickerdir),
	Receiver = task.GotoPos("Receiver",0,50,ReceiverDir),
	Goalie = task.Goalie()
},

["KickOff"] = {
	switch = function()
		if CGameOn() then
			return "finish"
		elseif CIsGetBall("Kicker") then
			return "passball"
		end
	end,
	Kicker = task.GetBall("Kicker","Receiver"),
	Receiver = task.GotoPos("Receiver",0,50,ReceiverDir),
	Goalie = task.Goalie()
},

["passball"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "Shoot"
		end
	end,
	Kicker = task.PassBall("Kicker","Receiver"),
	Receiver = task.GotoPos("Receiver",0,50,ReceiverDir),
	Goalie = task.Goalie()
},

["Shoot"] = {
	switch = function()
		if CIsBallKick("Receiver")then
			return "finish"
		end
	end,
	Kicker = task.Stop("Kicker",1),
	Receiver = task.Shoot("Receiver"),
	Goalie = task.Goalie()
},

name = "Ref_KickOff"
}]]


-- KickOff
Kicker2BallDir = function()
	return CRole2BallDir("Kicker")
end

Receiver2BallDir = function()
	return CRole2BallDir("Receiver")
end

Tier2BallDir = function()
	return CRole2BallDir("Tier")
end

Goalie2BallDir = function()
	return CRole2BallDir("Goalie")
end


gPlayTable.CreatePlay{
firstState = "Start",
	
["Start"] = {
	switch = function ()		-- 状态跳转
		if CNormalStart() then	-- CNormalStart 裁判盒有无发送 开球指令
			return "KickOff"	-- 转到 开球 状态
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		end
	end,
	--Receiver = task.ReceiverTask("KickOff_init"),		-- 中场球员拿球
	--Kicker = task.KickerTask("KickOff_init"),
	--Tier = task.TierTask("KickOff_init"),
	--Goalie = task.GoalieTask("KickOff_init")		-- 这里应该要调用自定义的防守dll 暂时先用官方goalie()
	Kicker = task.GotoPos("Kicker",-50,0,kickerdir),
	Receiver = task.GotoPos("Receiver",-10,60,ReceiverDir),
	Tier = task.GotoPos("Tier",-10,-60,Tier),
	Goalie = task.Goalie()
},

["KickOff"] = {
	switch = function()
		if CGameOn() then
			return "finish"
		elseif CIsGetBall("Kicker") then	-- 如果kicker拿到球 则 转到 传球状态
			return "passball"
		end
	end,
	Kicker = task.GetBall("Kicker","Receiver"),	-- Receiver 传球给 Kicker/ Kicker 朝向 Receiver拿球
	Receiver = task.GotoPos("Receiver",0,50,ReceiverDir),
	Tier = task.GotoPos("Tier",-220,0,Tier2BallDir),
	Goalie = task.Goalie()
},

["passball"] = {
	switch = function()
		if CIsBallKick("Kicker") then		-- Kicker 已经传球
			return "Shoot"
		end
	end,
	Kicker = task.PassBall("Kicker","Receiver"),	-- Kicker传球给Receiver
	Receiver = task.GotoPos("Receiver",0,50,ReceiverDir),
	Tier = task.GotoPos("Tier",-220,0,Tier2BallDir),
	Goalie = task.Goalie()
},

["Shoot"] = {
	switch = function()
		if CIsBallKick("Receiver")then		-- Receiver射门 
			return "finish"
		end
	end,
	Kicker = task.Stop("Kicker",1),	-- stop : 停止。role_name_：执行者 role_，1代表前锋，离球50cm
	Receiver = task.Shoot("Receiver"),	-- 射门
	Tier = task.GotoPos("Tier",-220,0,Tier2BallDir),
	Goalie = task.Goalie()
},

name = "Ref_KickOff_test"
}
