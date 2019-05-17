
gPlayTable.CreatePlay{

firstState = "stop",

["stop"] = {
    switch = function()
		if CGameOn() then 
	        return "finish"
	    else
	    	return "stop"
	    end
	end,
	Kicker   = task.Stop("Kicker",1),
	Receiver = task.Stop("Receiver",3) ,
	Tier 	 = Task.Stop("Tier",5),
	Goalie   = task.Stop("Goalie",6)
},

name = "Ref_Stop"
}