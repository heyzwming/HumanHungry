gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
        
["Start"] = {
    switch = function()
        if CGetBall("Receiver") then
            print("######################## 拿到球了#######################")
            --print()
            return "Start"
        end
    end,
    Receiver = task.ReceiverTask("GetBall2K")    
},

name = "GetBall2KTest"
}