--desc: 点球防守_守门员
KickerDir = function()		-- 用全局变量KickerDir存储函数的返回值
	return CRole2BallDir("Kicker")	-- 返回角色到球的方向
end

ReceiverDir = function()
	return CRole2BallDir("Receiver")
end

TierDir = function()
	return CRole2BallDir("Tier")
end

gPlayTable.CreatePlay{
firstState = "PenaltyDef",
switch = function()				-- 状态跳转函数，一直执行点球防守状态
	return "PenaltyDef"
end,

["PenaltyDef"] = {		-- 状态框架
-- role     = task.#$^%^&%^&@#(^&*^&$%)		-- 角色任务分配
	Kicker   = task.GotoPos("Kicker",0,80,KickerDir),	
	Receiver = task.GotoPos("Receiver",0,0,ReceiverDir),
	Tier     = task.GotoPos("Tier",0,-80,TierDir),
	Goalie   = task.GoalieTask("GoaliePenaltyDef")
  	-- GoalieTask()函数调用用户自定义的task技能；
    -- “PenaltyDef”技能由C++编写设计，生成的Penalty.dll放置在user_skills中;
    -- 每一个角色都有固定的自定义task函数；
    -- 如KickerTask(),TierTask(),ReceiveTask()等
},

name = "Ref_PenaltyDef_Goalie"	 -- 脚本名
}