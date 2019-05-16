--desc:黄队防守反击， Kicker 抢球后斜前传球给 Receiver 并向前跑位， Receiver 斜前传给 Kicker ， Kicker 射门

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
		if CRole2TargetDist("Receiver")<10  then
			return "firstpass"
		end
	end,
	Receiver   = task.GotoPos("Receiver", -60, -100, Receiver2Kickerdir),
	Kicker   = task.GetBall("Kicker","Receiver"),
	Goalie   = task.Goalie()
},

["firstpass"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "firstwait"
		end
	end,
	Receiver = task.ReceiverTask("receiveball"),
	Kicker = task.PassBall("Kicker", "Receiver"),	
	Goalie   = task.Goalie()
},

["firstwait"] = {
	switch = function()
		if  CBall2RoleDist("Receiver") < 10 and Cbuf_cnt(true, 10) then
			return "frontball"
		end
	end,
	Receiver = task.ReceiverTask("receiveball"),
	Kicker   = task.GotoPos("Kicker", 100, 100, Kickerdir2Receiverdir),
	Goalie   = task.Goalie()
},

["frontball"] = {
	switch = function()
		if Cbuf_cnt(CRole2TargetDist("Kicker")<10, 60) then
			return "crosspass"
		end
	end,
	Receiver   = task.GetBall("Receiver", "Kicker"),
	Kicker   = task.GotoPos("Kicker", 100, 100, Kickerdir2Receiverdir),
	Goalie   = task.Goalie()
},
	--Receiver   = task.waitTouch(CGeoPoint:new_local(-100,-150),dir.ourPlayerToPlayer("Kicker"),dir.ourPlayerToPlayer("Kicker")),
["crosspass"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "crosswait"
		end
	end,
	Receiver   = task.PassBall("Receiver", "Kicker"),
	Kicker = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["crosswait"] = {
	switch = function()
		if CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot"
		end
	end,
	Receiver   = task.RefDef("Receiver"),
	Kicker = task.KickerTask("receiveball"),
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
	Goalie   = task.goalie()
},

["getball2"] = {
	switch = function()
		if CRole2TargetDist("Receiver")<10  then
			return "firstpass2"
		end
	end,
	Receiver   = task.GotoPos("Receiver", -60, 100, Receiver2Kickerdir),
	Kicker   = task.GetBall("Kicker","Receiver"),
	Goalie   = task.Goalie()
},

["firstpass2"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "firstwait2"
		end
	end,
	Receiver = task.ReceiverTask("receiveball"),
	Kicker = task.PassBall("Kicker", "Receiver"),	
	Goalie   = task.Goalie()
},

["firstwait2"] = {
	switch = function()
		if  CBall2RoleDist("Receiver") < 10 and Cbuf_cnt(true, 10) then
			return "frontball2"
		end
	end,
	Receiver = task.ReceiverTask("receiveball"),
	Kicker   = task.GotoPos("Kicker", 100, -100, Kickerdir2Receiverdir),
	Goalie   = task.Goalie()
},

["frontball2"] = {
	switch = function()
		if Cbuf_cnt(CRole2TargetDist("Kicker") < 10, 60) then
			return "crosspass2"
		end
	end,
	Receiver   = task.GetBall("Receiver", "Kicker"),
	Kicker   = task.GotoPos("Kicker", 100, -100, Kickerdir2Receiverdir),
	Goalie   = task.Goalie()
},
	--Receiver   = task.waitTouch(CGeoPoint:new_local(-100,-150),dir.ourPlayerToPlayer("Kicker"),dir.ourPlayerToPlayer("Kicker")),
["crosspass2"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "crosswait2"
		end
	end,
	Receiver   = task.PassBall("Receiver", "Kicker"),
	Kicker = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["crosswait2"] = {
	switch = function()
		if CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot2"
		end
	end,
	Receiver   = task.RefDef("Receiver"),
	Kicker = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["finalshoot2"] = {
	switch = function()
		if CIsBallKick("Kicker")  then
			return "finish"
		end
	end,
	Receiver   = task.RefDef("Receiver"),
	Kicker   = task.KickerTask("shoot"),
	Goalie   = task.goalie()
},

name = "Ref_BackKick_3v3"
}
