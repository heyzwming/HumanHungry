--desc: 

gPlayTable.CreatePlay{

firstState = "stop",

["stop"] = {
    switch = function()
		if CGameOn() then 		-- 如果游戏开始 则跳出本 脚本
	        return "finish"
	    else					-- 否则进入stop状态
	    	return "stop"
	    end
	end,
	Kicker   = task.Stop("Kicker",1),
	Receiver = task.Stop("Receiver",3) ,
	Tier	 = task.Stop("Tier",5),
	Goalie   = task.Stop("Goalie",6)
},

name = "Ref_Stop"
}