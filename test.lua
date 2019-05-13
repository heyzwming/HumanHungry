
function getNum(role)
    local Table = CGetOppNums()
    local num = 0
    for i, val in pairs(Table) do 
        if math.sqrt((COurRole_y(role)- COppNum_y(val))*(COurRole_y(role)- COppNum_y(val))+ (COurRole_x(role)- COppNum_x(val))*(COurRole_x(role)- COppNum_x(val))) <50 then
            num++
        end
    end
    return num
end


function getOppNum()
    local oppTable = CGetOppNums() --我方球员编号总是知道的吧..或者进行for遍历..或者写个全局table变量 OurPlayerNumber = {1,2,3,4}
    -- pairs 迭代 table元素的迭代器 
    for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value 
        local num = tonumber(val) -- 把 value 字符串转为数字
        if COppIsGetBall(num-1) then -- CIsGetBall()
            break
        end
    end
    return num      -- 返回 拿球球员编号 num
end