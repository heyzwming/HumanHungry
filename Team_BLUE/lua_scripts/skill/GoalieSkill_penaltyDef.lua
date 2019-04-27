gPlayTable.CreatePlay{
firstState = "GoaliePenaltyDef",
switch = function()			--状态跳转函数		一直执行防守状态
	return "GoaliePenaltyDef"
end,

["GoaliePenaltyDef"] = {					--状态框架
	--role = task				-- 角色、任务分配
	Goalie = task.GoalieTask("GoaliePenaltyDef"),			-- Kicker 执行防守任务
--	Receive = task.ReceiverTask(“def”),	    -- ReceiverTask()函数调用用户自定义的task技能；
                                            -- “def”技能由C++编写设计，生成的def.dll放置在user_skills中;
                                            -- 每一个角色都有固定的自定义task函数；
                                            -- 如KickerTask(),TierTask(),GoalieTask()等
--	Goalie = task.Goalie()
},
name = "Ref_penaltyDef_Goalieskill"    --此处为脚本名
}
