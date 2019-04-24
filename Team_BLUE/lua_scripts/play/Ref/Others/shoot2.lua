--desc: shoot2
gPlayTable.CreatePlay{
firstState = "GetBall",

["GetBall"]={
	switch = function()
	  if CBall2RoleDist("Receiver") < 15 then
		return "PassBall"
	  end
	end,
	Kicker = task.GoRecePos("Kicker"),
    Receiver = task.GetBall("Receiver,Receiver"),
    Goalie = task.Goalie()
},

["Shoot"]={
	switch=function()
	  if CIsBallkick("Kicker")then
		return "finish"
	  end
    end,
    Kicker=task.Shoot("Kicker"),
    Goalie=task.RefDef("Receiver"),
    Goalie=task.Goalie()
},
name = "shoot2"--必须顶格写

}