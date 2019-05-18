--desc: 
gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
        
["Start"] = {
    switch = function()
        if CGetBall("Kicker") then
            print("######################## 拿到球了#######################")
            --print()
            return "Start"
        end
    end,
    Kicker = task.KickerTask("GetBall2T")    
},

name = "GetBall2TTest"
}