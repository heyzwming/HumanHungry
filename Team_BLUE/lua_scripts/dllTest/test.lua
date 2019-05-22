gPlayTable.CreatePlay{
firstState = "Ready",

["Ready"] = {
	switch = function()     
		if true then
			return "Ready"
		end
	end,
	Goalie = task.GoalieTask("Goalie")
},

name = "test"
}