--desc: 蓝队进攻角球

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
	Receiver = task.Stop("Receiver",3),
	Tier     = task.Stop("Tier",5),
	Goalie   = task.Stop("Goalie",6)
},


["getball"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10 then
			return "firstpass"
		end
	end,
	Receiver   = task.GetBall("Receiver", "Kicker"),
	Kicker   = task.GotoPos("Kicker", 120,-150, Kickerdir2Receiverdir),
	Tier     = task.TierTask("def"),
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
		Tier     = task.TierTask("def"),
	Goalie   = task.Goalie()
},

["firstwait"] = {
	switch = function()
		if  CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot"
		end
	end,
	Receiver = task.ReceiverTask("RefDefBad"),
	Kicker   = task.KickerTask("receiveball"),
		Tier     = task.TierTask("def"),
	Goalie   = task.Goalie()
},

["finalshoot"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "finish"
		end
	end,
	Receiver = task.ReceiverTask("RefDefBad"),
	Kicker   = task.KickerTask("shoot"),
		Tier     = task.TierTask("def"),
	Goalie   = task.goalie()
},


["getball2"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10  then
			return "firstpass2"
		end
	end,
	Receiver   = task.GetBall("Receiver", "Kicker"),
	Kicker   = task.GotoPos("Kicker", 120,150, Kickerdir2Receiverdir),
		Tier     = task.TierTask("def"),
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
		Tier     = task.TierTask("def"),
	Goalie   = task.Goalie()
},

["firstwait2"] = {
	switch = function()
		if CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot2"
		end
	end,
	Receiver = task.ReceiverTask("RefDefBad"),
		Tier     = task.TierTask("def"),
	Kicker   = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["finalshoot2"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "finish"
		end
	end,
	Receiver = task.ReceiverTask("RefDefBad"),
	Kicker   = task.KickerTask("shoot"),
		Tier     = task.TierTask("def"),
	Goalie   = task.goalie()
},





name = "Ref_CornerKick_4v4"
}