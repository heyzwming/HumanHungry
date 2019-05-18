--desc: 
gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
        
["Start"] = {
    switch = function()
            return "Start"
    end,
    Tier = task.TierTask("PassBall2Kicker")    
},

name = "PassBall2Kicker"
}