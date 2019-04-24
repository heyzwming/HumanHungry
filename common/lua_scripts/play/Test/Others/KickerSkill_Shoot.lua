--desc: myskill2 射门
gPlayTable.CreatePlay{
firstState = "KickerShoot",
switch = function()			--状态跳转函数		一直执行防守状态
	return "KickerShoot"
end,

["KickerShoot"] = {					--状态框架
	--role = task				-- 角色、任务分配
	Kicker = task.KickerTask("KickerShoot"),	
--	Receive = task.ReceiverTask(“def”),	    -- ReceiverTask()函数调用用户自定义的task技能；
                                            -- “def”技能由C++编写设计，生成的def.dll放置在user_skills中;
                                            -- 每一个角色都有固定的自定义task函数；
                                            -- 如KickerTask(),TierTask(),GoalieTask()等

},
name = "KickerSkill_Shoot"    --此处为脚本名
}
