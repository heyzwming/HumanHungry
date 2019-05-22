--desc: 
gPlayTable.CreatePlay{

firstState = "Start",

["Start"] = {
    switch = function()
        if true then
            return "Start" 
        end
    end,
    --Kicker = task.KickerTask("myskill")
    Kicker = task.KickerTask("wjnskill005")
},
name = "wjnshoot"
}