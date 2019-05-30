--desc: 黄队防守
gPlayTable.CreatePlay{
firstState = "doDef",

switch = function()
	if CBall2RoleDist("Kicker") < 20 or CBall2RoleDist("Receiver") < 20 or CBall2RoleDist("Tier") < 20 then
		return "finish"
	else	
		return "doDef"
	end
end,

["doDef"] = {
	Kicker  = task.KickerTask("face2facedef05"),
	Receiver= task.ReceiverTask("face2ball_def_only02"),
	Tier	= task.TierTask("Tdef_dev"),
	Goalie  = task.Goalie()
},

name = "Ref_BackDef"
}