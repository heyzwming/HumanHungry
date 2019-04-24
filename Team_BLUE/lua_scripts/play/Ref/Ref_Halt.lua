gPlayTable.CreatePlay{

firstState = "halt",
--switch = function()
	--return "halt"
--end,

["halt"] = {
	Kicker    = task.RobotHalt("Kicker"),
	Receiver  = task.RobotHalt("Receiver"),
	Goalie    = task.RobotHalt("Goalie"),
	Tier      = task.RobotHalt("Tier"),
	Defender  = task.RobotHalt("Defender"),
	Middle    = task.RobotHalt("Middle")
},

name = "Ref_Halt"
}
