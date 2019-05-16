kickerdir = function()
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
	Goalie = task.Goalie(),
	Tier = task.TierTask("def")
},

["KickOff"] = {
	switch = function()
		if CGameOn() then
			return "finish"
		elseif CIsGetBall("Kicker") and Cbuf_cnt(true,50)  then
			return "passball"
		end
	end,
	Kicker = task.GetBall("Kicker","Receiver"),
	Receiver = task.GotoPos("Receiver",0,150,ReceiverDir),
	Goalie = task.Goalie(),
	Tier = task.TierTask("def")
},

["passball"] = {
	switch = function()
		if CGetBallY() > 20 then
			return "passwait"
		elseif Cbuf_cnt(true,200) then
			return "finish"
		end
	end,
	Kicker = task.PassBall("Kicker","Receiver"),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie = task.Goalie(),
	Tier = task.TierTask("def")
},

["passwait"] = {
	switch = function()
		if CBall2RoleDist("Receiver") < 15 then
			return "Shoot"
		elseif Cbuf_cnt(true, 200) then
			return "finish"
		end
	end,
	Receiver   = task.ReceiverTask("receiveball"),
	Kicker = task.RefDef("Kicker"),
	Tier = task.TierTask("def"),
	Goalie   = task.Goalie()
},

["Shoot"] = {
	switch = function()
		if CIsBallKick("Receiver")then
			return "finish"
		end
	end,
	Kicker = task.RefDef("Kicker"),
	Receiver = task.ReceiverTask("shoot"),
	Goalie = task.Goalie(),
	Tier = task.TierTask("def")
},

name = "Ref_KickOff"
}