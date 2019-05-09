--desc: 前锋_点球

ReceiverDir = function()
	return CRole2BallDir("Receiver")
end

TierDir = function()
	return CRole2BallDir("Tier")
end

GoalieDir = function()
	return CRole2BallDir("Goalie")
end

gPlayTable.CreatePlay{
firstState = "PenaltyKick",
switch = function()				-- 状态跳转函数，一直执行点球防守状态
	return "PenaltyKick"
end,

["PenaltyKick"] = {		-- 状态框架
 -- role     = task.#$^%^&%^&@#(^&*^&$%)		-- 角色任务分配
	Kicker   = task.KickerTask("KickerPenaltyKick"),	
	Receiver = task.GotoPos("Receiver",150,-30,ReceiverDir), 
	Tier     = task.GotoPos("Tier",150,30,TierDir),
	Goalie   = task.GotoPos("Goalie",-310,0,GoalieDir)

},

name = "Ref_PenaltyKick_Kicker"	 -- 脚本名
}