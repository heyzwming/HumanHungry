--desc: 
function getOppNum()
    local oppTable = CGetOppNums()
    -- pairs 迭代 table元素的迭代器 
	for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value    
		local num = tonumber(val) -- 把 value 字符串转为数字
        if COppIsGetBall(num-1) then
			break
		end		
	end
	return num		-- 返回 拿球球员编号 num
end
--nil
--function oppgetball()
--	return COppIsGetBall(0) or COppIsGetBall(1) or COppIsGetBall(2) 
--	       or COppIsGetBall(3) or COppIsGetBall(4) or COppIsGetBall(5) 
--end

-- 获取对方没有拿球的球员编号
-- 暂时先把守门员也考虑进去了
-- 使用方法： local NoBallNum = OppNotGetBallNum()	声明一个本地变量 接收函数返回值（table类型）
function OppNotGetBallNum()
    local oppTable = CGetOppNums()  -- 敌方所有上场球员编号
    -- pairs 迭代 table元素的迭代器 
	for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value    
        local number = tonumber(val) -- 把 value 字符串转为数字
        local NoBallTable = {-1,-1,-1}
        if ~COppIsGetBall(number-1) then    -- number编号的球员没有拿到球
			NoBallTable[i] = number
        end	    	
    end
    return NoBallTable	-- 返回table类型
end

--[[ 获得没有拿到球的对方球员的位置 ]]
function NoBallX1()
	local NoBallTable = OppNotGetBallNum()
	return COppNum_x(NoBallTable[1]) 
end

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