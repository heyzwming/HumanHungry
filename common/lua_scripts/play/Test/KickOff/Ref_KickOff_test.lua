--desc: 

-- 一个 PassBall 的 dll

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

-------------------------------
--- 计算球员到球的距离
function Role2BallDist(role)
	local ball_x = CGetBalLX()
	local ball_y = CGetBallY()
	local role_x = COurRole_x(role)
	local role_y = COurRole_y(role)
	
	local dist = math.sqrt(math.pow((role_y-role_x),2) + math.pow((ball_y-ball_x),2))
	return dist
end
---------------------------------

local LeftInitPos_x,LeftInitPos_y = Polar2Vector(60,-135)
local RightInitPos_x,RightInitPos_y = Polar2Vector(60,135)

gPlayTable.CreatePlay{
firstState = "Start",
	
["Start"] = {
	switch = function ()		-- 状态跳转
		if CNormalStart() and Cbuf_cnt(true, 60) then	-- CNormalStart 裁判盒有无发送 开球指令
			return "Forward"	-- 转到 开球 状态
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		end
	end,
	Kicker 		= task.GotoPos("Kicker",-57,0,Kicker2BallDir),
	Receiver 	= task.GotoPos("Receiver",-45,-45,Receiver2BallDir),
	Tier 		= task.GotoPos("Tier",-45,45,Tier2BallDir),
	Goalie 		= task.Goalie()
},

["Forward"] = {
	switch = function()
		if Cbuf_cnt(true,100) then
			return "KickOff"
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		end
	end,
	Kicker 		= task.GotoPos("Kicker",-10,0,Kicker2BallDir),
	Receiver	= task.GotoPos("Receiver",-18,-100,Receiver2BallDir),
	Tier 		= task.GotoPos("Tier",-18,100,Tier2BallDir),
	Goalie 		= task.Goalie()
},

["KickOff"] = {	--KickerOff  中 GetBall 拿球
	switch = function()
		if CGameOn() then
			return "finish"
		elseif CIsGetBall("Kicker") and Cbuf_cnt(true, 100) then	-- 如果kicker拿到球 则 转到 传球状态
			return "Passball"		-- TODO: 写一个随机函数  如果1 传给Receiver 0传给Tier
		end
	end,
	Kicker 		= task.KickerTask("GetBall2Goal"),	-- 朝向球门拿球
	Receiver	= task.GotoPos("Receiver",-20,-120,Receiver2BallDir),
	Tier 		= task.GotoPos("Tier",-20,120,Tier2BallDir),
	Goalie 		= task.Goalie()
},

["Passball"] = {	-- 传给Tier
	switch = function()
		if CIsBallKick("Kicker") and Cbuf_cnt(true, 60) then		-- Kicker 已经传球
			return "Move"
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		end
	end,
	Kicker 		= task.PassBall("Kicker","Tier"),	-- Kicker传球给Tier
	Receiver	= task.GotoPos("Receiver",-20,-120,Receiver2BallDir),
	Tier 		= task.GotoPos("Tier",-20,120,Tier2BallDir),
	Goalie 		= task.Goalie()
},

["PassWait"] = {		-- 等待传球 球的运动
	switch = function()
		if CisGetBall("Tier") then
			return "TierShoot"
--			return "Pass2Kicker"
		elseif CGameOn() then	-- 比赛是否开始
			return "finish"		-- 结束本状态机
		elseif  Role2BallDist("Tier") < 15 then
			return "TierGetBall"
		end
	end,
	Kicker 	 = task.GotoPos("Kicker",100,50,Kicker2BallDir),
	Receiver = task.GoRecePos("Receiver"),
	Tier 	 = task.GotoPos("Tier",-20,120,Tier2BallDir),
	Goalie 	 = task.Goalie()
},
--[[
["TierGetBall"] = {
	switch = function()
}]]

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
["TierShoot"] = {
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

["ReceiverShoot"] = {
	switch = function()
		if CIsBallKick("Receiver") then		-- Receiver射门 
			return "finish"
		end
	end,
	Kicker 		= task.Stop("Kicker",1),	-- stop : 停止。role_name_：执行者 role_，1代表前锋，离球50cm
	Receiver 	= task.ReceiverTask("Shoot"),	-- 射门
	Tier 		= task.GoRecePos("Tier"),
	Goalie 		= task.Goalie()
},

name = "Ref_KickOff_test"
}
