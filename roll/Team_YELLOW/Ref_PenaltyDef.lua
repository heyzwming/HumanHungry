kickerdir = function()
	return CRole2BallDir("Kicker")
end

ReceiverDir = function()
	return CRole2BallDir("Receiver")
end

tierdir = function()
	return CRole2BallDir("Tier")
end

gPlayTable.CreatePlay{
firstState = "PenaltyDef",

["PenaltyDef"] = {
	switch = function()
		return "PenaltyDef"
	end,
	Kicker   = task.GotoPos("Kicker",-230,80,kickerdir),
	Receiver = task.GotoPos("Receiver",-230,-80,ReceiverDir),
	Tier     = task.GotoPos("Tier",-120,0,tierdir),
	Goalie   = task.GoalieTask("penaltyDef")
},

name = "Ref_PenaltyDef"
}