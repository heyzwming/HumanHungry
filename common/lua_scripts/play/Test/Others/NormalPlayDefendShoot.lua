--desc: 

goto_x = function() 
	local x
	x = 0
	return x
end
goto_y  = function()
	local y 
		y = 0
	return y
end
goto_dir = function()
	return CRole2OppGoalDir("Kicker")
end
goto_dirx = function()
	return CRole2OppGoalDir("Tier")
end
goto_x1 = function() 
	local x
	x = -180
	return x
end
goto_y1  = function()
	local y 
		y = 0
	return y
end
goto_dir1 = function()
	return CRole2OppGoalDir("Kicker")
end
goto_dirx1 = function()
	return CRole2OppGoalDir("Tier")
end 
gPlayTable.CreatePlay{

firstState = "initState",
["initState"] = {
	switch = function ()
	       if  CIsGetBall("Receiver")  and CGetBallX() > 50  and  CGetBallX() < 303  then
	       	return "shootz"
	    elseif  CIsGetBall("Receiver") and CGetBallX() < 50 and CGetBallX() > -303 then
	       	return "shootz1"
		elseif CIsGetBall("Kicker")   and CGetBallX() > 50 and CGetBallX() < 303   then
			return "shooty"  
		elseif CIsGetBall("Kicker")  and CGetBallX() < 50 and CGetBallX() > -303   then
			return "shooty1"
		elseif CIsGetBall("Tier")   and CGetBallX() > 50 and CGetBallX() < 303    then
			return "shootx"
		elseif CIsGetBall("Tier")   and CGetBallX() < 50 and CGetBallX() > -303  then
			return "shootx1"
		end
	end,
	Tier     = task.GetBall("Tier","Tier"),
	Kicker   = task.GetBall("Kicker","Kicker"),
	Receiver = task.Shoot("Receiver"),
	Goalie   = task.Goalie()
},

["shootx"] = {
	switch = function()
		if CIsBallKick("Tier") or Cbuf_cnt(true,120)then
			return "initState"	
		end
	end,
	Tier     = task.Shoot("Tier"),
	Kicker   = task.GotoPos("Kicker",goto_x,goto_y,goto_dir),
	Receiver = task.ReceiverTask("def"),
	Goalie   = task.Goalie()
},

["shootx1"] = {
	switch = function()
		if CIsBallKick("Tier") or Cbuf_cnt(true,120)then
			return "initState"	
		end
	end,
	Tier     = task.Shoot("Tier"),
	Kicker   = task.GotoPos("Kicker",goto_x1,goto_y1,goto_dir1),
	Receiver = task.ReceiverTask("def"),
	Goalie   = task.Goalie()
},

["shooty"] = {
	switch = function()
		if CIsBallKick("Kicker") or Cbuf_cnt(true,120)then
			return "initState"	
		end
	end,
	Tier     = task.GotoPos("Tier",goto_x,goto_y,goto_dirx),
	Kicker   = task.Shoot("Kicker"),
	Receiver = task.ReceiverTask("def"),
	Goalie   = task.Goalie()
},

["shooty1"] = {
	switch = function()
		if CIsBallKick("Kicker") or Cbuf_cnt(true,120)then
			return "initState"	
		end
	end,
	Tier     = task.GotoPos("Tier",goto_x1,goto_y1,goto_dirx1),
	Kicker   = task.Shoot("Kicker"),
	Receiver = task.ReceiverTask("def"),
	Goalie   = task.Goalie()
},

["shootz"] = {
	switch = function()
		if CIsBallKick("Receiver") or Cbuf_cnt(true,120)then
			return "initState"	
		end
	end,
	Tier     = task.GotoPos("Tier",goto_x,goto_y,goto_dirx),
	Kicker   = task.KickerTask("def"),
	Receiver = task.Shoot("Receiver"),
	Goalie   = task.Goalie()
},


["shootz1"] = {
	switch = function()
		if CIsBallKick("Receiver") or Cbuf_cnt(true,120)then
			return "initState"	
		end
	end,
	Tier     = task.GotoPos("Tier",goto_x1,goto_y1,goto_dirx1),
	Kicker   = task.KickerTask("def"),
	Receiver = task.Shoot("Receiver"),
	Goalie   = task.Goalie()
},


name = "NormalPlayDefendShoot"
}