gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
        
["Start"] = {
    switch = function()
        if true then
            
            return "Start"
        end
    end,
    Kicker = task.KickerTask("GetBall2Goal")    
},

name = "GetBall2GoalTest"
}