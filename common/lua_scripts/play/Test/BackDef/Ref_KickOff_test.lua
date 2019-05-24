--desc: 

function Polar2Vector(length,dir)
    -- math.cos()：传入弧度
    -- math.rad(): 角度制转弧度制
    return length * math.cos(math.rad(dir)),length * math.sin(math.rad(dir))
end

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

local LeftInitPos_x,LeftInitPos_y = Polar2Vector(60,-135)
local RightInitPos_x,RightInitPos_y = Polar2Vector(60,135)

gPlayTable.CreatePlay{
firstState = "Start",
	
["Start"] = {
	switch = function ()		-- 状态跳转
		if CNormalStart() and Cbuf_cnt(true, 60) then	-- CNormalStart 裁判盒有无发送 开球指令
			return "KickerReady"	-- 转到 开球 状态
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		end
	end,
	Kicker 		= task.GotoPos("Kicker",-55,0,Kicker2BallDir),
	Receiver 	= task.GotoPos("Receiver",-60,-60,Receiver2BallDir),
	Tier 		= task.GotoPos("Tier",-60,60,Tier2BallDir),
	Goalie 		= task.Goalie()
},

["KickerReady"] = {
	switch = function()
		if Cbuf_cnt(true,60) then
			return "KickOff"
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		end
	end,
	Kicker 		= task.GotoPos("Kicker",-65,0,Kicker2BallDir),
	Receiver	= task.GotoPos("Receiver",-18,100,Receiver2BallDir),
	Tier 		= task.GotoPos("Tier",-18,-100,Tier2BallDir),
	Goalie 		= task.Goalie()
},

["KickOff"] = {
	switch = function()
		if CGameOn() then
			return "finish"
		elseif CIsGetBall("Kicker") and Cbuf_cnt(true, 120) then	-- 如果kicker拿到球 则 转到 传球状态
			return "passball"
		end
	end,
	Kicker 		= task.KickerTask("GetBall2Goal"),	-- 朝向球门拿球
	Receiver	= task.GotoPos("Receiver",-18,100,Receiver2BallDir),
	Tier 		= task.GotoPos("Tier",-18,-100,Tier2BallDir),
	Goalie 		= task.Goalie()
},

["passball"] = {
	switch = function()
		if CIsBallKick("Kicker") and Cbuf_cnt(true, 60) then		-- Kicker 已经传球
			return "Move"
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		end
	end,
	Kicker 		= task.PassBall("Kicker","Tier"),	-- Kicker传球给Receiver
	Receiver	= task.GotoPos("Receiver",-18,100,Receiver2BallDir),
	Tier 		= task.GotoPos("Tier",-50,80,Tier2BallDir),
	Goalie 		= task.Goalie()
},

["Move"] = {
	switch = function()
		if CisGetBall("Tier") then
			return "Shoot"
--			return "Pass2Kicker"
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		end
	end,
	Kicker 	 = task.GotoPos("Kicker",100,50,Kicker2BallDir),
	Receiver = task.GoRecePos("Receiver"),
	Tier 	 = task.GetBall("Tier","Kicker"),
	Goalie 	 = task.Goalie()
},

--[[
["Pass2Kicker"] = {
	switch = function()
		if CIsBallKick("Tier") then
			return "TierGetBall"
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		end
	end,
	Kicker 		= task.GotoPos("Kicker",100,50,Kicker2BallDir),
	Receiver 	= task.GoRecePos("Receiver"),
	Tier 		= task.passball("Tier","Kicker"),
	Goalie 		= task.Goalie()
},

["KickerGetBall"] = {
	switch = function()
		if CIsGetBall("Kicker") then
			return "Shoot"
		elseif CGameOn() then
			return "finish"
		end
	end,

},
]]
["Shoot"] = {
	switch = function()
		if CIsBallKick("Tier") then		-- Receiver射门 
			return "finish"
		end
	end,
	Kicker 		= task.Stop("Kicker",1),	-- stop : 停止。role_name_：执行者 role_，1代表前锋，离球50cm
	Receiver 	= task.GotoPos("Receiver",-220,0,Tier2BallDir),	-- 射门
	Tier 		= task.TierTask("Shoot"),
	Goalie 		= task.Goalie()
},


name = "Ref_KickOff_test"
}
