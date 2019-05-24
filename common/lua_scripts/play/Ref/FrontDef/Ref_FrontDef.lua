--desc: 
gPlayTable.CreatePlay{
firstState = "doFrontDef",
switch = function()
	return "doFrontDef"
end,
["doFrontDef"] = {
	Kicker  = task.RefDef("Kicker"),
	Receive = task.RefDef("Receiver"),
	Tier	= task.NormalDef("Tier"),
	Goalie  = task.Goalie()
},

name = "Ref_FrontDef"
}