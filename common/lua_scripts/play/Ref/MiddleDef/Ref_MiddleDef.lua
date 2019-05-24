--desc: 
gPlayTable.CreatePlay{
firstState = "doCornerDef",
switch = function()
	return "doCornerDef"
end,
["doCornerDef"] = {
	Kicker  = task.KickerTask("face2face_60"),
	Receiver = task.ReceiverTask("face2ball_def_only02"),
	Tier	= task.TierTask("def"),
	Goalie  = task.Goalie()
},

name = "Ref_CornerDef_use"
}