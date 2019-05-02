--desc: 
kickerdir = function()
	return CRole2BallDir("Kicker")
end

ReceiverDir = function()
	return CRole2BallDir("Receiver")
end

TierDir = function()
	return CRole2BallDir("Tier")
end

oppGoalDir = function()
	return CRole2OppGoalDir("Receiver")
end

gPlayTable.CreatePlay{

firstState = "start",
	
["start"] = {	-- SOM 中点击执行  过一小会 进入start状态
	switch = function ()
		if CNormalStart() then
			return "KickOff"
		elseif CGameOn() then
			return "finish"
		end
	end,
	Kicker = task.GotoPos("Kicker",-55,0,kickerdir),
	Receiver = task.GotoPos("Receiver",-20,50,ReceiverDir),
	Tier = task.GotoPos("Tier",-20,-50,TierDir),
	Goalie = task.Goalie()
},

["KickOff"] = {
	switch = function()
		if CGameOn() then
			return "finish"
		elseif CIsGetBall("Kicker") then
			return "passball"
		end
	end,
	Kicker = task.GetBall("Kicker","Receiver"),
	Receiver = task.GotoPos("Receiver",-10,80,ReceiverDir),
	Tier = task.GotoPos("Tier",-10,-80,TierDir),
	Goalie = task.Goalie()
},

["passball"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "Shoot"
		end
	end,
	Kicker = task.PassBall("Kicker","Receiver"),
	Receiver = task.GotoPos("Receiver",-10,120,ReceiverDir),
	Tier = task.GotoPos("Tier",-10,-120,TierDir),
	Goalie = task.Goalie()
},

["Shoot"] = {
	switch = function()
		if CIsBallKick("Receiver")then
			return "finish"
		end
	end,
	Kicker = task.Stop("Kicker",1),
	Receiver = task.Shoot("Receiver"),
	Tier = task.Stop("Tier",1),
	Goalie = task.Goalie()
},

name = "Ref_KickOff"
}