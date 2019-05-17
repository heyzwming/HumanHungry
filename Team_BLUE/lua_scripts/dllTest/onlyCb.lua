gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
        
["Start"] = {
    switch = function()
        return "Start"
    end,
    Kicker = task.KickerTask("onlyCb")    
        

},

name = "onlyCb"
}