--desc: 中场开球
--desc: 
--desc: 设置开球初始点


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
	Kicker = task.GotoPos("Kicker",-55,0,Kicker2BallDir),
	Receiver = task.GotoPos("Receiver",-18,55,Receiver2BallDir),
	Tier = task.GotoPos("Tier",-18,-55,Tier2BallDir),
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
	--Kicker = task.GotoPos("Kicker",0,-25,Kicker2BallDir),
	--Kicker = task.GetBall("Kicker","Receiver"),	-- Receiver 传球给 Kicker/ Kicker 朝向 Receiver拿球
	Kicker = task.GetBall("Kicker","Kicker"),	-- 朝向球门拿球
	Receiver = task.GotoPos("Receiver",-18,100,Receiver2BallDir),
	Tier = task.GotoPos("Tier",-18,-100,Tier2BallDir),
	Goalie = task.Goalie()
},

["passball"] = {
	switch = function()
		if CIsBallKick("Kicker") then		-- Kicker 已经传球
			return "Shoot"
		end
	end,
	Kicker = task.PassBall("Kicker","Receiver"),	-- Kicker传球给Receiver
	Receiver = task.GotoPos("Receiver",0,150,Receiver2BallDir),
	Tier = task.GotoPos("Tier",160,-100,Tier2BallDir),
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
