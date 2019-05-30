--desc: 
-- 如果我方拿球即return finish
gPlayTable.CreatePlay{
firstState = "doMiddleDef",
switch = function()
	return "doMiddleDef"
end,
["doMiddleDef"] = {
	Kicker   = task.KickerTask("face2face_60"),
	Receiver = task.ReceiverTask("face2ball_def_only02"),
	Tier	 = task.TierTask("def"),
	Goalie   = task.Goalie()
},

name = "Ref_MiddleDef"
}