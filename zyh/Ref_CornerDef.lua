--desc: 

goto_x2 = function() 
	local x
	x = COurRole_x("Kicker") 
	return x-20
end

goto_x1 = function() 
	local x
	x = COurRole_x("Kicker") 
	return x+20
end

goto_y2 = function() 
	local y
	y = COurRole_y("Kicker") 
	return y-30*main.cos(goto_dir1())
end

goto_y1 = function() 
	local y
	y = COurRole_y("Kicker") 
	return y+30*main.cos(math.rad(goto_dir1()))
end


goto_x = function() 
	local x
	x = COurRole_x("Receiver") 
	return x+50
end

goto_y  = function()
	local y 
	y = COurRole_x("Receiver") 
	return y+50
end

goto_dir = function()
	return CRole2OppGoalDir("Kicker")
end

goto_dir1 = function()
	return CRole2BallDir("Kicker") 
end




gPlayTable.CreatePlay{
firstState = "doCornerDef",

["doCornerDef"] = {
	switch = function()
		if CBall2RoleDist("Receiver") < 30 or CBall2RoleDist("Tier") < 30 or CBall2RoleDist("Receive") < 30  then
			return "GetBall"
		else
			return "doCornerDef"
		end
	end,
	Kicker  = task.NormalDef("Kicker"),
	Tier    = task.GotoPos("Tier",goto_x2,goto_y2,goto_dir1),
	Receive    = task.GotoPos("Receiver",goto_x1,goto_y1,goto_dir1),
	--Receive = task.RefDef("Receiver"),
	Goalie  = task.Goalie()
	
},


["GetBall"] = {
	switch = function()
		if CBall2RoleDist("Receiver") < 30 and CIsGetBall("Receiver") then
			return "PassBall"
		end
	end,
	Kicker   = task.GotoPos("Kicker",goto_x,goto_y,goto_dir),
	Receiver = task.GetBall("Receiver","Receiver"),
	Goalie   = task.Goalie()
},

["PassBall"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "Shoot"
		end
	end,
	Kicker   = task.GotoPos("Kicker",goto_x,goto_y,goto_dir),
	Receiver = task.PassBall("Receiver","Kicker"),
	Goalie   = task.Goalie()
},

["Shoot"] = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "doCornerDef"
		end
	end,
	Kicker = task.Shoot("Kicker"),
	Receiver = task.RefDef("Receiver"),
	Goalie = task.Goalie()
},

name = "Ref_CornerDef"
}