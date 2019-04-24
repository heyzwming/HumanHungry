--desc: 点球大战，前锋点球 KickerSkill_PenaltyKick
gPlayTable.CreatePlay{

firstState = "PenaltyKick",
switch = function()			--状态跳转函数		一直执行防守状态
	return "PenaltyKick"
end,

["PenaltyKick"] = {					--状态框架
	--role = task				-- 角色、任务分配
	Kicker = task.KickerTask("KickerPenaltyKick"),			-- Kicker 执行防守任务
--	Receive = task.ReceiverTask(“def”),	    -- ReceiverTask()函数调用用户自定义的task技能；
                                            -- “def”技能由C++编写设计，生成的def.dll放置在user_skills中;
                                            -- 每一个角色都有固定的自定义task函数；
                                            -- 如KickerTask(),TierTask(),GoalieTask()等
--	Goalie = task.Goalie()
},
name = "KickerSkill_PenaltyKick"    --此处为脚本名
}
