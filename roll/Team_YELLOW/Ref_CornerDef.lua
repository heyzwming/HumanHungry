--desc:  黄队防守
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
	Kicker  = task.RefDef("Kicker"),
	Receiver = task.RefDef("Receiver"),
	Tier   =  task.TierTask("def"),
	Goalie  = task.Goalie()	
},

name = "Ref_CornerDef"
}