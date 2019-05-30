
function defence()	-- 返回不持球的2名球员
	local oppTable = CGetOppNums()	-- 返回存在球员编号
	local NumLeft = -1
	local NumRight = -1
	local OppPlayer = { [0] = 1 }
	for i,val in pairs(oppTable) do 
		local num = tonumber(val)
		if COppNum_x(num-1) > 220 then	-- 守门员
			break
		elseif COppIsGetBall(num-1) then	-- 持球手
            break
		elseif COppNum_y(num-1) < -50 then	-- 左边
			NumLeft = num
		elseif COppNum_y(num-1) > 50 then	-- 右边
			NumRight = num
		end	
	end
end
--COppNum_x(num-1) > 220

Kicker2BallDir = function()
	return CRole2BallDir("Kicker")
end

Receiver2BallDir = function()
	return CRole2BallDir("Receiver")
end

Tier2BallDir = function()
	return CRole2BallDir("Tier")
end


gPlayTable.CreatePlay{

firstState = "Start",
--[[
["start"] = {
	switch = function()
	 	if CGameOn() then
			return "finish"
	 	else
			return "start"
	 	end	
	end,
	Kicker   = task.Stop("Kicker",1) ,
	Receiver = task.Stop("Receiver",3) ,
	Tier     = task.Stop("Tier",5) ,
	Goalie   = task.Stop("Goalie",6)
},
]]
["Start"] = {
	switch = function()
		if CGameOn() then
			return "finish"
		elseif condition then
			-- body
		end
	end,
	Kicker = task.GotoPos("Kicker", 55, 0, Kicker2BallDir),
	Receiver = task.GotoPos("Receiver",70,-10,Receiver2BallDir),
	Tier = task.GotoPos("Tier",70,10,Receiver2BallDir),
	Goalie = task.GoalieTask("Goalie")
},
-- 获得对方存在球员的编号
-- 一对一防守对方除守门员以外的球员

name = "Ref_KickOffDef"
}