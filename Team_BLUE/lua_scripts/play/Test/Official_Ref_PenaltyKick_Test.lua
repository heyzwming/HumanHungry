kickerdir = function()
	return CRole2BallDir("Kicker")	--获取我方球员到球的朝向角度。
end

ReceiverDir = function()
	return CRole2BallDir("Receiver")
end

gPlayTable.CreatePlay{
firstState = "GotoPos",		-- 初始状态  前往初始点

["GotoPos"] = {
	switch = function ()
		if CNormalStart() then
			return "PenaltyKick"
		elseif CGameOn() then
			return "finish"
		end
	end,
	Kicker = task.GotoPos("Kicker",200,0,kickerdir),
	Receiver = task.NormalDef("Receiver"),
	Goalie = task.Goalie()
},



["PenaltyKick"] = {
	switch = function()
		if CIsBallKick("Kicker") or CGameOn() then
			return "finish"
		end
	end,
	Kicker   = task.PenaltyKick("Kicker"),
	Receiver = task.NormalDef("Receiver"),
	Goalie   = task.Goalie()
},

name = "Ref_PenaltyKick"
}