
GoalieDir = function()
	return CRole2BallDir("Goalie")
end

gPlayTable.CreatePlay{
firstState = "goalie",		-- 初始状态  前往初始点

switch = function()
    return "goalie"
end,

["goalie"] = {
    
	Goalie = task.GoalieTask("goalie_LSM")
},

name = "goalie_LSM"
}