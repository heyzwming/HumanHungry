gPlayTable.CreatePlay{

firstState = "initState",

["initState"] = {		-- []里是状态机的名字
	switch = function ()	
		-- 当...返回下一个状态机的状态名
		if CBall2RoleDist("Kicker") > CBall2RoleDist("Receiver") then		-- 如果 Receiver 距离球更近  转到 doGetBall 状态
			return "doGetBall"		
		elseif CIsGetBall("Kicker") then		-- 如果 Kicker 距离球更近  同时 如果 Kicker 已经拿到了球  进入shoot
			return "shoot"
		end
	end,
	Kicker   = task.GetBall("Kicker","Kicker"),		-- 在initState状态下  Kicker 朝着球门拿球

	-- Receiver 和 Tier 正常防守
	Receiver = task.ReceiverTask("def"),
	Tier 	 = task.TierTask("def"),
	Goalie   = task.Goalie()
},

["doGetBall"] = {
	switch = function()
		-- 如果 Receiver 拿到了球  同时   Kicker 球员距离其目标点的距离小于 5
		if CIsGetBall("Receiver") and CRole2TargetDist("Kicker") < 5 then		
			return "doBackPassBall"		-- 转到 doBackPassBall 状态
		end
	end,
	Kicker   = task.GoRecePos("Kicker"),			-- 去接球点
	Receiver = task.GetBall("Receiver","Kicker"),	-- Receicer 朝向 Kicker 拿球 
	Tier	 = task.TierTask("def"),				-- 防守
	Goalie   = task.Goalie()
},


["doBackPassBall"] = {
	switch = function()
		if CIsBallKick("Receiver") then		-- 如果Receiver 把球传出去  转到 shoot 状态
			return "shoot"
		end
	end,
	Kicker   = task.GoRecePos("Kicker"),		-- Kicker 去到 接球点 
	Receiver = task.PassBall("Receiver","Kicker"),	-- Receiver 朝向 Kicker 传球
	Tier  	 = task.TierTask("def"),
	Goalie   = task.Goalie()
},

["shoot"] = {
	switch = function()
		-- Cbuf_cnt(cond, count)   当 cond 条件为true时，经过 count 个时间单位后 返回true
		if CIsBallKick("Kicker") or Cbuf_cnt(true,120)then	-- 在120个时间单位内没有 球没有射出则 返回 初始状态 initState
			return "initState"				-- 回到初始状态
		end
	end,
	Kicker   = task.Shoot("Kicker"),
	Receiver = task.ReceiverTask("def"),
	Tier 	 = task.TierTask("def"),
	Goalie   = task.Goalie()
},


name = "NormalPlayDefend"
}