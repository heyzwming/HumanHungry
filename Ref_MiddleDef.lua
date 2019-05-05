--desc: 
function getOppNum()
    local oppTable = CGetOppNums()
    -- pairs 迭代 table元素的迭代器 
	for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value    
		num = tonumber(val) -- 把 value 字符串转为数字
        if COppIsGetBall(num-1) then
			return true
		end		
	end
end
--nil
--function oppgetball()
--	return COppIsGetBall(0) or COppIsGetBall(1) or COppIsGetBall(2) 
--	       or COppIsGetBall(3) or COppIsGetBall(4) or COppIsGetBall(5) 
--end

gPlayTable.CreatePlay{
firstState = "Test1",

["Test1"] = {
	switch = function()
		--local num = getOppNum()
		if getOppNum() then
			return "Test2"
		end
	end,
	Kicker   = task.RobotHalt("Receiver"),
	Receiver = task.RobotHalt("Receiver"),
	Goalie   = task.RobotHalt("Goalie")
},
["Test2"] = {
	switch = function()
		--return "Test1"
	end,
	Kicker   = task.GotoPos("Kicker",50,50,0),
	Receiver = task.RobotHalt("Receiver"),
	Goalie   = task.RobotHalt("Goalie")
},

name = "Ref_MiddleDef"
}