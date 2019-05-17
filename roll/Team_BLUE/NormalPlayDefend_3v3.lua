--desc:正常踢球测试

--local Receiver_POS = CGeoPoint:new_local(100,150)
--local KICKER_POS1 = CGeoPoint:new_local(-100,-150)
--local KICKER_POS2 = CGeoPoint:new_local(200,-150)
--local Tier_POS = CGeoPoint:new_local(-200,50)

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
		if CGetBallX() > 0 and CGetBallY() > 0 then
				return "getball"
		elseif  CGetBallX() > 0 and CGetBallY() < 0 then
				return "getball2"
		elseif  CGetBallX() < 0 and CGetBallY() > 0 then
				return "PGetBall3"
		else
				return "PGetBall4"
		end
	end,
	Kicker   = task.Stop("Kicker",1),
	Receiver = task.Stop("Receiver",3),
	Tier 	 = task.Stop("Tier",5),
	Goalie   = task.Stop("Goalie",6),
},

-----------------------------------------------------------------------------X < 0 Y > 0
["PGetBall3"] = {
	switch = function()
		if CRole2TargetDist("Kicker")<10 and Cbuf_cnt(true,60) then
			return "RPassBall3"
		end
	end,
	Kicker   = task.GotoPos("Kicker", -50, -160, Kickerdir2Receiverdir),
	Receiver = task.GetBall("Receiver","Kicker"),
	Goalie   = task.Goalie(),
},

["RPassBall3"] = {
	switch = function()
		if CBall2RoleDist("Receiver") > 25  and Cbuf_cnt(true, 30) then
			return "KReceBall3"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.PassBall("Receiver","Kicker"),
	Goalie   = task.Goalie(),
},

["KReceBall3"] = {
	switch = function()
		if CRole2TargetDist("Receiver")<10 and Cbuf_cnt(true,30) then
			return "TgetBall3"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.GotoPos("Receiver", 120, 140, Receiver2Kickerdir),
	Goalie   = task.Goalie(),
},

["TgetBall3"] = {
	switch = function()
		if CBall2RoleDist("Kicker") < 20 and Cbuf_cnt(true, 30) then
			return "Kshoot3"
		end
	end,
	Kicker = task.GetBall("Kicker", "Receiver"),
	Receiver   = task.GotoPos("Receiver", 120, 140, Receiver2Kickerdir),
	Goalie   = task.Goalie()
},

["Kshoot3"] = {
	switch = function()
		if CBall2RoleDist("Kicker") > 25  and Cbuf_cnt(true,30) then
			return "KGetBalls"	
		end
	end,
	Kicker   = task.PassBall("Kicker","Receiver"),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie(),
},

["KGetBalls"] = {
	switch = function()
		if CBall2RoleDist("Receiver") < 20 and Cbuf_cnt(true,30) then
			return "KGetBallss"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 150,-100, Kickerdir2Receiverdir),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie(),
},

["KGetBallss"] = {
	switch = function()
		if Cbuf_cnt(true,40) then
			return "Rshoot"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 150,-100, Kickerdir2Receiverdir),
	Receiver = task.GetBall("Receiver", "Receiver"),
	Goalie   = task.Goalie(),
},

-----------------------------------------------------------------------------X < 0 Y < 0
["PGetBall4"] = {
	switch = function()
		if CRole2TargetDist("Kicker")<10 and Cbuf_cnt(true,60) then
			return "RPassBall4"
		end
	end,
	Kicker   = task.GotoPos("Kicker", -50, 160, Kickerdir2Receiverdir),
	Receiver = task.GetBall("Receiver","Kicker"),
	Goalie   = task.Goalie(),
},

["RPassBall4"] = {
	switch = function()
		if CBall2RoleDist("Receiver") > 25   and Cbuf_cnt(true, 30) then
			return "KReceBall4"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.PassBall("Receiver","Kicker"),
	Goalie   = task.Goalie(),
},

["KReceBall4"] = {
	switch = function()
		if CRole2TargetDist("Kicker")<10 and Cbuf_cnt(true,30) then
			return "TgetBall4"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.GotoPos("Receiver", 120, -140, Receiver2Kickerdir),
	Goalie   = task.Goalie(),
},

["TgetBall4"] = {
	switch = function()
		if CBall2RoleDist("Kicker") < 20 and Cbuf_cnt(true, 30) then
			return "Kshoot4"
		end
	end,
	Kicker = task.GetBall("Kicker", "Receiver"),
	Receiver   = task.GotoPos("Receiver", 120, -140, Receiver2Kickerdir),
	Goalie   = task.Goalie()
},

["Kshoot4"] = {
	switch = function()
		if CBall2RoleDist("Kicker") > 25 and Cbuf_cnt(true, 30) then
			return "KGetBall2s"	
		end
	end,
	Kicker = task.PassBall("Kicker", "Receiver"),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie(),
},

["KGetBall2s"] = {
	switch = function()
		if CBall2RoleDist("Receiver") < 20 and Cbuf_cnt(true,30) then
			return "KGetBall2ss"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 150,100, Kickerdir2Receiverdir),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie(),
},

["KGetBall2ss"] = {
	switch = function()
		if  CRole2TargetDist("Kicker")<10 and Cbuf_cnt(true,40) then
			return "RPassBall2"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 150,100, Kickerdir2Receiverdir),
	Receiver = task.GetBall("Receiver", "Kicker"),
	Goalie   = task.Goalie(),
},

-----------------------------------------------------------------------------X > 0 Y > 0
["getball"] = {
	switch = function ()
		if CBall2RoleDist("Kicker") > CBall2RoleDist("Receiver") then	-- 球到Kicker距离比Receiver更近
			return "PGetBall"
		else
			return "KGetBall"
		end
	end,
	Kicker   = task.Stop("Kicker",1),
	Receiver = task.Stop("Receiver",3) ,
	Goalie   = task.Stop("Goalie",6),
},

-----中锋离球近-----
["PGetBall"] = {
	switch = function()
		if CRole2TargetDist("Kicker") < 10 and CGetBallX() < 120 and Cbuf_cnt(true,60) then
			--CRole2TargetDist Target由task决定  同时球的x在120以内 同时 等待60个时间单位
			return "RPassBall"
		elseif CRole2TargetDist("Kicker") < 10 and CGetBallX() > 120 and Cbuf_cnt(true,60) then
			return "Rshoot"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 150,-100, Kickerdir2Receiverdir),
	Receiver = task.GetBall("Receiver","Kicker"),
	Goalie   = task.Goalie(),
},

["RPassBall"] = {
	switch = function()
		if CBall2RoleDist("Kicker") > 25 and Cbuf_cnt(true, 30) then
			return "KReceBall2"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.PassBall("Receiver","Kicker"),
	Goalie   = task.Goalie(),
},

["KReceBall"] = {
	switch = function()
		if CIsGetBall("Kicker") then
			return "Kshoot"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.RefDef("Receiver"),
	Goalie   = task.Goalie(),
},

["Kshoot"] = {
	switch = function()
		if CIsBallKick("Kicker") or Cbuf_cnt(true,30)then
			return "xy"	
		end
	end,
	Kicker   = task.KickerTask("shoot"),
	Receiver = task.RefDef("Receiver"),
	Goalie   = task.Goalie(),
},

-----前锋离球近-----
["KGetBall"] = {
	switch = function()
		if CRole2TargetDist("Receiver") < 10 and CGetBallX() < 120 and Cbuf_cnt(true,60) then
			return "KPassBall"
		elseif  CRole2TargetDist("Receiver") < 10 and CGetBallX() > 120 and Cbuf_cnt(true,60) then
			return "Kshoot"
		end
	end,
	Kicker   = task.GetBall("Kicker","Receiver"),
	Receiver = task.GotoPos("Receiver", 150,-110, Receiver2Kickerdir),
	Goalie   = task.Goalie(),
},

["KPassBall"] = {
	switch = function()
		if  CBall2RoleDist("Kicker") > 25 and  Cbuf_cnt(true, 30) then
			return "RReceBall"
		end
	end,
	Kicker   = task.PassBall("Kicker","Receiver"),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie(),
},

["RReceBall"] = {
	switch = function()
		if CIsGetBall("Receiver") then
			return "Rshoot"
		end
	end,
	Kicker   = task.RefDef("Kicker"),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie(),
},

["Rshoot"] = {
	switch = function()
		if CIsBallKick("Receiver") or Cbuf_cnt(true,30)then
			return "xy"	
		end
	end,
	Kicker   = task.RefDef("Kicker"),
	Receiver = task.ReceiverTask("shoot"),
	Goalie   = task.Goalie(),
},

-----------------------------------------------------------------------------X > 0 Y < 0
["getball2"] = {
	switch = function ()
		if CBall2RoleDist("Kicker") > CBall2RoleDist("Receiver") then
			return "PGetBall2"
		else
			return "KGetBall2"
		end
	end,
	Kicker   = task.Stop("Kicker",1),
	Receiver = task.Stop("Receiver",3) ,
	Goalie   = task.Stop("Goalie",6),
},

-----中锋离球近-----
["PGetBall2"] = {
	switch = function()
		if CRole2TargetDist("Kicker")<10 and CGetBallX() < 120 and Cbuf_cnt(true,60) then
			return "RPassBall2"
		elseif CRole2TargetDist("Kicker")<10 and CGetBallX() > 120 and Cbuf_cnt(true,60) then
			return "Rshoot2"
		end
	end,
	Kicker   = task.GotoPos("Kicker", 150,100, Kickerdir2Receiverdir),
	Receiver = task.GetBall("Receiver","Kicker"),
	Goalie   = task.Goalie(),
},

["RPassBall2"] = {
	switch = function()
		if CBall2RoleDist("Kicker") > 25 and Cbuf_cnt(true, 30) then
			return "KReceBall2"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.PassBall("Receiver","Kicker"),
	Goalie   = task.Goalie(),
},

["KReceBall2"] = {
	switch = function()
		if CIsGetBall("Kicker") then
			return "Kshoot2"
		end
	end,
	Kicker   = task.KickerTask("receiveball"),
	Receiver = task.RefDef("Receiver"),
	Goalie   = task.Goalie(),
},

["Kshoot2"] = {
	switch = function()
		if CIsBallKick("Kicker") or Cbuf_cnt(true,30)then
			return "xy"	
		end
	end,
	Kicker   = task.KickerTask("shoot"),
	Receiver = task.RefDef("Receiver"),
	Goalie   = task.Goalie(),
},

-----前锋离球近-----
["KGetBall2"] = {
	switch = function()
		if CRole2TargetDist("Receiver") < 10 and CGetBallX() < 120 and Cbuf_cnt(true,60) then
			return "KPassBall2"
		elseif  CRole2TargetDist("Receiver") < 10 and CGetBallX() > 120 and Cbuf_cnt(true,60) then
			return "Kshoot2"
		end
	end,
	Kicker   = task.GetBall("Kicker","Receiver"),
	Receiver = task.GotoPos("Receiver", 150,110, Receiver2Kickerdir),
	Goalie   = task.Goalie(),
},

["KPassBall2"] = {
	switch = function()
		if CBall2RoleDist("Kicker") > 25 and  Cbuf_cnt(true, 30) then
			return "RReceBall2"
		end
	end,
	Kicker   = task.PassBall("Kicker","Receiver"),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie(),
},

["RReceBall2"] = {
	switch = function()
		if CIsGetBall("Receiver") then
			return "Rshoot2"
		end
	end,
	Kicker   = task.RefDef("Kicker"),
	Receiver = task.ReceiverTask("receiveball"),
	Goalie   = task.Goalie(),
},

["Rshoot2"] = {
	switch = function()
		if CIsBallKick("Receiver") or Cbuf_cnt(true,30)then
			return "xy"	
		end
	end,
	Kicker   = task.RefDef("Kicker"),
	Receiver = task.ReceiverTask("shoot"),
	Goalie   = task.Goalie(),
},

name = "NormalPlayDefend_3v3"
}
