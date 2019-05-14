--desc: 

KickerDir = function()
	return CRole2BallDir("Kicker")
end

ReceiverDir = function()
	return CRole2BallDir("Receiver")
end

oppGoalDir = function()
	return CRole2OppGoalDir("Receiver")
end
TierDir = function()
	return CRole2BallDir("Tier")
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
	Tier   =  task.GotoPos("Tier",-180,0,TierDir),
	Kicker = task.GotoPos("Kicker",0.5,53,KickerDir),
	Receiver = task.GotoPos("Receiver",-10,-50,ReceiverDir),
	Goalie = task.Goalie()
},
["KickOff"] = {
	switch = function()
		if CGameOn() then
			return "finish"
		elseif CIsGetBall("Receiver") then
			return "PassBall"
		elseif CIsGetBall("Tier") then
			return "Shoot1"
		end
	end,
	Tier   =  task.GetBall("Tier","Tier"),
	Kicker = task.GotoPos("Kicker",0.5,53,KickerDir),
	Receiver = task.GetBall("Receiver","Kicker"),
	Goalie = task.Goalie()
},
["PassBall"] = {
	switch = function()
		if CIsGetBall("Kicker") then
			return "Shoot"
		end
	end,
	Receiver = task.GotoPos("Receiver",-2,11,ReceiverDir),
	Tier     = task.TierTask("Def"),
	Kicker   = task.GetBall("Kicker","Kicker"),
	Goalie   = task.Goalie()
},
["Shoot"] = {
	switch = function()
		if CIsBallKick("Kicker") or Cbuf_cnt(true,120) then
			return "finish"
		end
	end,
	Tier   = task.Stop("Tier",3),
	Kicker = task.Shoot("Kicker"),
	Receiver = task.Stop("Receiver",5),
	Goalie = task.Goalie()
},
["Shoot1"] = {
	switch = function()
		if CIsBallKick("Tier") or Cbuf_cnt(true,120) then
			return "finish"
		end
	end,
    Tier   = task.Shoot("Tier"),
	Kicker = task.Shoot("Kicker"),
	Receiver = task.Stop("Receiver",5),
	Goalie = task.Goalie()
},
name = "Ref_KickOff"
}