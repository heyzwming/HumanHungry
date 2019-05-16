kickerdir = function()
	return CRole2BallDir("Kicker")
end

ReceiverDir = function()
	return CRole2BallDir("Receiver")
end

gPlayTable.CreatePlay{
firstState = "GotoPos",

["GotoPos"] = {
	switch = function ()
		if CNormalStart()  and Cbuf_cnt(true,50) then
			return "PenaltyKick"
		elseif CGameOn() then
			return "finish"
		end
	end,
	Kicker = task.GotoPos("Kicker",190,0,kickerdir),
	Receiver = task.Stop("Receiver",3),
	Tier   = task.NormalDef("Tier"),
	Goalie = task.Goalie()
},



["PenaltyKick"] = {
	switch = function()
		if CIsBallKick("Kicker") or CGameOn() then
			return "finish"
		end
	end,
	Kicker   = task.PenaltyKick("Kicker"),
	Receiver = task.Stop("Receiver",3),
	Tier     = task.NormalDef("Tier"),
	Goalie   = task.Goalie()
},

name = "Ref_PenaltyKick"
}