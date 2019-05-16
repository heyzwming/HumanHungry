--desc:黄队中场进攻， Kicker 抢球后回传给 Receiver并向另一侧跑位 ， Receiver 前传球给 Kicker ， Kicker 射门

--要求后卫抢球在右后半场，尚未体现抢球过程
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
	Tier     = task.Stop("Tier",5)
},

["getball"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10  and Cbuf_cnt(true, 20) then
			return "firstpass"
		end
	end,
	Kicker   = task.GetBall("Kicker", "Receiver"),
	Receiver = task.GotoPos("Receiver", -150,0, Receiver2Kickerdir),
	Goalie   = task.Goalie()
},

["firstpass"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "firstwait"
		end
	end,
	Kicker   = task.PassBall("Kicker", "Receiver"),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie()
},

["firstwait"] = {
	switch = function()
		if  CBall2RoleDist("Receiver") < 15 then
			return "backball"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 100, -80, Kickerdir2Receiverdir),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie()
},

["backball"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10 then
			return "sidepass"
		--elseif bufcnt(true, 120) then
		--	return "sidepass"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 100, -80, Kickerdir2Receiverdir),
	Receiver = task.GetBall("Receiver","Kicker"),
	Goalie   = task.Goalie()
},

["sidepass"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "sidewait"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.PassBall("Receiver","Kicker"),
	Goalie   = task.Goalie()
},

["sidewait"] = {
	switch = function()
		if CBall2RoleDist("Kicker") < 15 then
			return "finalshoot"
		end
	end,
	Receiver   = task.RefDef("Receiver"),
	Kicker   = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["finalshoot"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "finish"
		end
	end,
	Receiver   = task.RefDef("Receiver"),
	Kicker   = task.KickerTask("shoot"),
	Goalie   = task.Goalie()
},

["getball2"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 15 then
			return "firstpass2"
		end
	end,
	Kicker   = task.GetBall("Kicker", "Receiver"),
	Receiver = task.GotoPos("Receiver", -150, 0, Receiver2Kickerdir),
	Goalie   = task.Goalie()
},

["firstpass2"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "firstwait2"
		end
	end,
	Kicker   = task.PassBall("Kicker", "Receiver"),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie()
},

["firstwait2"] = {
	switch = function()
		if  CBall2RoleDist("Receiver") < 15 then
			return "sidepass2"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 100, 80, Kickerdir2Receiverdir),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie()
},


["sidepass2"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "sidewait2"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.PassBall("Receiver", "Kicker"),
	Goalie   = task.Goalie()
},

["sidewait2"] = {
	switch = function()
		if CBall2RoleDist("Kicker") < 15 then
			return "finalshoot2"
		end
	end,
	Receiver   = task.RefDef("Receiver"),
	Kicker   = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["finalshoot2"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "finish"
		end
	end,
	Receiver   = task.RefDef("Receiver"),
	Kicker   = task.KickerTask("shoot"),
	Goalie   = task.Goalie()
},

name = "Ref_MiddleKick_3v3"
}
