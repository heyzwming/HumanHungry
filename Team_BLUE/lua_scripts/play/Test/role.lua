
role = "Goalie"

gPlayTable.CreatePlay{
firstState = "goalie",		-- 初始状态  前往初始点

switch = function()
    return "goalie"
end,

["goalie"] = {
    Goalie = task.GotoPos("Goalie",100,100,0),
    
    

    
    --Cbuf_cnt(true,5),

    Goalie = task.GotoPos("Goalie",10,10,0)
	--role = task.GoalieTask("goalie_LSM")
},

name = "role"
}