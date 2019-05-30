--desc: 蓝队防守反击， Kicker 抢球后传球给 Receiver  并向斜前侧跑位， Receiver 前传给 Kicker ， Kicker 射门

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

local Receiver2Tierdir = function()
	return COurRole2RoleDir("Receiver", "Tier")
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
		if CRole2TargetDist("Receiver") < 10 then
			return "firstpass"
		end
	end,
	Kicker   = task.GotoPos("Kicker", -50, -120, Kickerdir2Receiverdir),
	Receiver   = task.ReceiverTask("GetBall2K"),
	--Receiver   = task.GetBall("Receiver","Kicker"),
	Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.Goalie()
},

["firstpass"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "firstwait"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.ReceiverTask("passball"),
	Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.Goalie()
},

["firstwait"] = {
	switch = function()
		if  CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "backball"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver   = task.GotoPos("Receiver", 120, 100, Receiver2Kickerdir),
	Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.Goalie()
},

["backball"] = {
	switch = function()
		if Cbuf_cnt(CRole2TargetDist("Kicker") < 10, 20) then
			return "sidepass"
		--elseif bufcnt(true, 120) then
		--	return "sidepass"
		end
	end,
	Kicker   = task.GetBall("Kicker","Receiver"),
	Receiver   = task.GotoPos("Receiver", 120, 100, Receiver2Kickerdir),
	Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.Goalie()
},

["sidepass"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "sidewait"
		end
	end,
	Kicker   = task.PassBall("Kicker","Receiver"),
	Receiver = task.ReceiverTask("receiveball"),
	Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.Goalie()
},

["sidewait"] = {
	switch = function()
		if CBall2RoleDist("Receiver") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot"
		end
	end,
	Receiver = task.ReceiverTask("receiveball"),
		Tier     = task.TierTask("Tdef_dev"),
	Kicker = task.KickerTask("RefDefBad"),
	Goalie   = task.Goalie()
},

["finalshoot"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "finish"
		end
	end,
	Kicker   = task.KickerTask("RefDefBad"),
	Receiver = task.ReceiverTask("shoot"),
		Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.goalie()
},


["getball2"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "firstpass2"
		end
	end,
	Receiver   = task.GotoPos("Receiver", -50, 120, Receiver2Kickerdir),
	Kicker   = task.GetBall("Kicker","Receiver"),
		Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.Goalie()
},

["firstpass2"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "firstwait2"
		end
	end,
	Receiver   = task.ReceiverTask("receiveball"),
	Kicker = task.PassBall("Kicker","Receiver"),
		Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.Goalie()
},

["firstwait2"] = {
	switch = function()
		if  CBall2RoleDist("Receiver") < 10 and Cbuf_cnt(true, 10) then
			return "backball2"
		end
	end,
	Receiver   = task.ReceiverTask("receiveball"),
	Kicker   = task.GotoPos("Kicker", 120, -100, Kickerdir2Receiverdir),
		Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.Goalie()
},

["backball2"] = {
	switch = function()
		if Cbuf_cnt(CRole2TargetDist("Kicker")<10, 60) then
			return "sidepass2"
		--elseif bufcnt(true, 120) then
		--	return "sidepass"
		end
	end,
	Receiver   = task.GetBall("Receiver","Kicker"),
	Kicker   = task.GotoPos("Kicker", 120, -100, Kickerdir2Receiverdir),
		Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.Goalie()
},

["sidepass2"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "sidewait2"
		end
	end,
	Receiver   = task.PassBall("Receiver","Kicker"),
		Tier     = task.TierTask("Tdef_dev"),
	Kicker = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["sidewait2"] = {
	switch = function()
		if CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot2"
		end
	end,
	Receiver = task.ReceiverTask("RefDefBad"),
		Tier     = task.TierTask("Tdef_dev"),
	Kicker = task.KickerTask("receiveball"),
	Goalie   = task.Goalie()
},

["finalshoot2"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "finish"
		end
	end,
	Kicker   = task.KickerTask("shoot"),
	Receiver = task.ReceiverTask("RefDefBad"),
	Tier     = task.TierTask("Tdef_dev"),
	Goalie   = task.goalie()
},



name = "Ref_BackKick"
}
