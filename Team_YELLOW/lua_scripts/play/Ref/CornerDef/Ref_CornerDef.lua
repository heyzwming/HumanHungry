--desc: 
gPlayTable.CreatePlay{
firstState = "doCornerDef",

["doCornerDef"] = {
	switch = function()
		return "doCornerDef"
	end,
	Kicker  = task.KickerTask("face2face_60"),
	Receiver = task.ReceiverTask("face2ball_def_only02"),
	Tier	= task.TierTask("def"),
	Goalie  = task.Goalie()
},

name = "Ref_CornerDef"
}