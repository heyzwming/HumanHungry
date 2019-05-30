--desc:蓝队进攻， Receiver 抢球后判断如果离对方球门近则直接射门，否则传球给 Kicker  ， Kicker 射门

local Kicker2Receiverdir = function()
	return COurRole2RoleDir("Kicker", "Receiver")
end

local Tier2Receiverdir = function()
	return COurRole2RoleDir("Tier", "Receiver")
end

gPlayTable.CreatePlay{

firstState = "Start",

["Start"] = {
	switch = function()
		if CGetBallX() > 200 then
			return "getshoot"
		elseif CGetBallY() > 0 then
			return "getballR"
		else
			return "getballL"
		end
	end,
	Kicker   = task.Stop("Kicker", 1),
	Receiver = task.Stop("Receiver", 3),
	Tier	 = task.Stop("Tier", 5),
	Goalie   = task.Stop("Goalie", 6),
},

["getshoot"] = {
	switch = function()
		-- 角色球员距离其目标点的距离
		local x = 120
		local y = 30

		if CGetBallY > 0 then
			y = 30
		else y = -30
		end

		if CRole2TargetDist("Kicker") < 100  and Cbuf_cnt(true, 50) then
			return "gshoot"
		else return "Pass2Kicker"
		end
	end,
	Receiver = task.ReceiverTask("GetBall2Receiver"),
	Kicker   = task.GotoPos("Kicker", x, y, Kicker2Receiverdir),
	Tier	 = task.TierTask("GoReceivePos"),
	Goalie   = task.Goalie()
},

["Pass2Kicker"] = {
	switch = function()
		if CIsGetBall("Kicker")	then
			return "Pass2Tier"
		elseif CRole2TargetDist("Kicker") < 90   
}


["Pass2Tier"]

["gshoot"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "finish"
		end
	end,
	Kicker   = task.KickerTask("MarkingBallFake"),
	Receiver = task.ReceiverTask("shoot"),
	Tier 	 = task.TierTask("GoReceivepos"),
	Goalie   = task.goalie()
},

["getballR"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10 then
			return "firstpass"
		end
	end,
	Receiver   = task.GetBall("Receiver", "Kicker"),
	Kicker   = task.GotoPos("Kicker", 120,-150, Kicker2Receiverdir),
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
		if  CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot"
		end
	end,
	Receiver = task.ReceiverTask("RefDefBad"),
	Kicker   = task.KickerTask("receiveball"),
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
	Goalie   = task.goalie()
},


["getballL"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10  then
			return "firstpass2"
		end
	end,
	Receiver   = task.GetBall("Receiver", "Kicker"),
	Kicker   = task.GotoPos("Kicker", 120,150, Kicker2Receiverdir),
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
		if CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "finalshoot2"
		end
	end,
	Receiver = task.ReceiverTask("RefDefBad"),
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
	Goalie   = task.goalie()
},


name = "Ref_FrontKick_3v3"
}
