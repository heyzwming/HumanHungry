gPlayTable.CreatePlay{

firstState = "initState",

["initState"] = {		-- []里是状态机的名字
	switch = function ()	
		-- 当...返回下一个状态机的状态名
		if CBall2RoleDist("Kicker") > CBall2RoleDist("Receiver") then
			return "doGetBall"
		elseif CIsGetBall("Kicker") then
			return "shoot"
		end
	end,
	Kicker   = task.GetBall("Kicker","Kicker"),
	Receiver = task.ReceiverTask("def"),
	Tier 	 = task.TierTask("def"),
	Goalie   = task.Goalie()
},

["doGetBall"] = {
	switch = function()
		if CIsGetBall("Receiver") and CRole2TargetDist("Kicker") < 5 then
			return "doBackPassBall"
		end
	end,
	Kicker   = task.GoRecePos("Kicker"),
	Receiver = task.GetBall("Receiver","Kicker"),
	Tier	 = task.TierTask("def"),
	Goalie   = task.Goalie()
},


["doBackPassBall"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "shoot"
		end
	end,
	Kicker   = task.GoRecePos("Kicker"),
	Receiver = task.PassBall("Receiver","Kicker"),
	Tier  	 = task.TierTask("def"),
	Goalie   = task.Goalie()
},

["shoot"] = {
	switch = function()
		if CIsBallKick("Kicker") or Cbuf_cnt(true,120)then
			return "initState"	
		end
	end,
	Kicker   = task.Shoot("Kicker"),
	Receiver = task.ReceiverTask("def"),
	Tier 	 = task.TierTask("def"),
	Goalie   = task.Goalie()
},


name = "NormalPlayDefend"
}