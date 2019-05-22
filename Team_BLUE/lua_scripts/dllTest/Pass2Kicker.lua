gPlayTable.CreatePlay{

firstState = "Start",

["Start"] = {
    switch = function()
        return "Start"
    end,

    Receiver = task.ReceiverTask("Pass2Kicker")

},

name = "Pass2Kicker"

}