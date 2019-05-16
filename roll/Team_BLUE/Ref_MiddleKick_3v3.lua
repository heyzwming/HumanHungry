--desc:蓝队中场进攻， Receiver 抢球后传给 Kicker 并向前跑位 ， Kicker 斜前传球给 Receiver ， Receiver 射门

--local Receiver_POS = CGeoPoint:new_local(100,150)
--local KICKER_POS1 = CGeoPoint:new_local(-100,-150)
--local KICKER_POS2 = CGeoPoint:new_local(200,-150)
--local Tier_POS = CGeoPoint:new_local(-200,50)
local Kickerdir2Tierdir = function()
	return COurRole2RoleDir("Kicker", "Tier")
end

local Tier2Kickerdir = function()
	return CRole2BallDir("Tier")
end

local Receiver2Kickerdir = function()
	return COurRole2RoleDir("Receiver", "Kicker")
end

local Kickerdir2Receiverdir = function()
	return COurRole2RoleDir("Kicker", "Receiver")
end

local Tierdir2Receiverdir = function()
	return COurRole2RoleDir("Tier", "Receiver")
end

gPlayTable.CreatePlay{

firstState = "xy",

["xy"] = {
	switch = function()
		if CGetBallY() > 0 then
			return "getball"
		else
			return "getball2"
		end
	end,
	Kicker   = task.Stop("Kicker",1),
	Receiver = task.Stop("Receiver",3) ,
	Goalie   = task.Stop("Goalie",6),
},

["getball"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10   then
			return "firstpass"
		end
	end,
	Receiver   = task.GetBall("Receiver", "Kicker"),
	Kicker   = task.GotoPos("Kicker", 0, -150, Kickerdir2Receiverdir),
	Goalie   = task.Goalie()
},

["firstpass"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "firstwait"
		end
	end,
	Receiver   = task.PassBall("Receiver", "Kicker"),
	Kicker   = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["firstwait"] = {
	switch = function()
		if CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "backball"
		end
	end,
	Receiver = task.GotoPos("Receiver", 120, 160, Receiver2Kickerdir),
	Kicker   = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["backball"] = {
	switch = function()
		if Cbuf_cnt(CRole2TargetDist("Receiver") < 10, 20) then
			return "sidepass"
		--elseif bufcnt(true, 120) then
		--	return "sidepass"
		end
	end,
	Receiver = task.GotoPos("Receiver", 120, 160, Receiver2Kickerdir),
	Kicker   = task.GetBall("Kicker", "Receiver"),
	Goalie   = task.Goalie()
},

["sidepass"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "sidewait"
		end
	end,
	Receiver = task.ReceiverTask("receiveball"),
	Kicker   = task.PassBall("Kicker", "Receiver"),
	Goalie   = task.Goalie()
},

["sidewait"] = {
	switch = function()
		if CBall2RoleDist("Receiver") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot"
		end
	end,
	Receiver = task.ReceiverTask("receiveball"),
	Kicker  = task.KickerTask("MarkingBallFake"),
	Goalie   = task.Goalie()
},

["finalshoot"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "finish"
		end
	end,
	Receiver = task.ReceiverTask("shoot"),
	Kicker  = task.KickerTask("MarkingBallFake"),
	Goalie   = task.goalie()
},


["getball2"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10 then
			return "firstpass2"
		end
	end,
	Receiver   = task.GetBall("Receiver", "Kicker"),
	Kicker   = task.GotoPos("Kicker", 0, 150, Kickerdir2Receiverdir),
	Goalie   = task.Goalie()
},

["firstpass2"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "firstwait2"
		end
	end,
	Receiver   = task.PassBall("Receiver", "Kicker"),
	Kicker   = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["firstwait2"] = {
	switch = function()
		if  CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "backball2"
		end
	end,
	Receiver = task.GotoPos("Receiver", 200, 160, Receiver2Kickerdir),
	Kicker   = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["backball2"] = {
	switch = function()
		if Cbuf_cnt(CRole2TargetDist("Receiver") < 10, 20) then
			return "sidepass2"
		--elseif bufcnt(true, 120) then
		--	return "sidepass"
		end
	end,
	Receiver = task.GotoPos("Receiver", 200, 160, Receiver2Kickerdir),
	Kicker   = task.GetBall("Kicker", "Receiver"),
	Goalie   = task.Goalie()
},

["sidepass2"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "sidewait2"
		end
	end,
	Receiver = task.GotoPos("Receiver", 200, 160, Receiver2Kickerdir),
	Kicker   = task.PassBall("Kicker", "Receiver"),
	Goalie   = task.Goalie()
},

["sidewait2"] = {
	switch = function()
		if CBall2RoleDist("Receiver") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot2"
		end
	end,
	Receiver = task.GotoPos("Receiver", 200, 160, Receiver2Kickerdir),
	Kicker  = task.KickerTask("MarkingBallFake"),
	Goalie   = task.Goalie()
},

["finalshoot2"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "finish"
		end
	end,
	Receiver = task.ReceiverTask("shoot"),
	Kicker  = task.KickerTask("MarkingBallFake"),
	Goalie   = task.goalie()
},


name = "Ref_MiddleKick_3v3"
}