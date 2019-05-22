gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
--★★你上次讲的，switch=function()后，在某个位置突然就end了。这个我很不明白诶。  
-- 我讲了啥？？我也忘了诶....      
["Start"] = {
    switch = function()		
        if true then
            return "and"
        end
    end,
    Kicker = task.GotoPos("Kicker",100,100,0)
},


["and"] = {
    switch = function()
        if true then
            return "and"
        end
    end,
    Kicker = task.GotoPos("Kicker",-100,-100,0)
},

name = "justtest"
}

