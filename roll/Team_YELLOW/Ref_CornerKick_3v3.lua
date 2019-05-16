--desc: 角球

local Receiver2Kickerdir = function()
	return COurRole2RoleDir("Receiver", "Kicker")
end

local Kickerdir2Receiverdir = function()
	return COurRole2RoleDir("Kicker", "Receiver")
end

gPlayTable.CreatePlay{

firstState = "xy",

["xy"] = {
	switch = function()
		if CGetBallY() > 0 then
			return "GetBall"
		else
			return "GetBall2"
		end
	end,
	Kicker   = task.Stop("Kicker",1),
	Receiver = task.Stop("Receiver",3) ,
	Goalie   = task.Stop("Goalie",6),
	Tier     = task.Stop("Tier",5)
},


["GetBall"] = {
	switch = function()
		if CRole2TargetDist("Receiver") < 10  and Cbuf_cnt(true, 30) then
			return "PassBall"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 185, -145, Kickerdir2Receiverdir),
	Receiver = task.GetBall("Receiver","Kicker"),
	Goalie   = task.Goalie()
},
	
["PassBall"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "receiveball"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 185, -145, Kickerdir2Receiverdir),
	Receiver = task.ReceiverTask("chippassball"),
	Goalie   = task.Goalie()
},

["receiveball"] = {
	switch  = function()
		if CBall2RoleDist("Receiver") < 10 and Cbuf_cnt(true, 10) then
			return "Shoot"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 185, -145, Kickerdir2Receiverdir),
	Receiver = task.RefDef("Receiver"),
	Goalie = task.Goalie()
},

["Shoot"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "finish"
		end
	end,
	Kicker   = task.KickerTask("shoot"),
	Receiver = task.RefDef("Receiver"),
	Goalie = task.Goalie()
},


["GetBall2"] = {
	switch = function()
		if CRole2TargetDist("Receiver") < 10  and Cbuf_cnt(true, 30) then
			return "PassBall2"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 185, 85, Kickerdir2Receiverdir),
	Receiver = task.GetBall("Receiver","Kicker"),
	Goalie   = task.Goalie()
},
	
["PassBall2"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "receiveball"
		end
	end,
	Kicker = task.GotoPos("Kicker", 185, 165, Kickerdir2Receiverdir),
	Receiver = task.ReceiverTask("chippassball"),
	Goalie   = task.Goalie()
},

["receiveball2"] = {
	switch  = function()
		if CBall2RoleDist("Kicker") < 10 and Cbuf_cnt(true, 10) then
			return "Shoot2"
		end
	end,
	Kicker = task.KickerTask("receiveball"),
	Receiver = task.RefDef("Receiver"),
	Goalie = task.Goalie()
},

["Shoot2"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "finish"
		end
	end,
	Kicker   = task.KickerTask("shoot"),
	Receiver = task.RefDef("Receiver"),
	Goalie = task.Goalie()
},

name = "Ref_CornerKick_3v3"
}