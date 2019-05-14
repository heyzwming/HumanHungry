--[[ 极坐标转直角坐标 ]]
function Polar2Vector(length,dir)
    -- math.cos()：传入弧度
    -- math.rad(): 角度制转弧度制
    return length * math.cos(math.rad(dir)),length * math.sin(math.rad(dir))
end


function round(role)
    -- 假设某球员在(-605/2,-35/2-80)的点上，现在要沿着禁区左半弧线移动

    -- [[ 需要定的变量 ]]
    local DeltaAngle = 1    -- 角度的变化量
    local AngleIsAdd = nil   -- 角度变化是 + 还是 -
    local PlayerAngle = COurRoleDir(role)
    local IsClockWise = nil     -- 顺时针移动  

    local Target = {nil,nil}
    local Center = {-605/2,-35/2}
    -- [[ 首先判断当前的角度还能不能再 加减 ]]

    if COurRole_y(role) < 0 then 
        if PlayerAngle >= -85 or PlayerAngle <= 0 then
            -- 在 可以沿弧移动的范围
            if 判断是顺时针移动还是逆时针移动 then
                IsClockWise = true
            end
        end
    else -- 在y轴正半场
        if PlayerAngle <= 85 or PlayerAngle >= 0 then
            -- 在 可以沿弧移动的范围
            if 判断是顺时针移动还是逆时针移动 then
                IsClockWise = false
            end
        end
    end    

    if IsClockWise then -- 顺时针移动 delta个角度
        Target = Polar2Vector(80+10,球员当前的角度 + DeltaAngle)
        -- 目标点还要加上圆心的 坐标
        Target[1] = Target[1] + Center[1]
        Target[2] = Target[2] + Center[2]
    else        -- 逆时针移动 delta 个角度
        Target = Polar2Vector(80+10,球员当前的角度 - DeltaAngle)
        -- 目标点还要加上圆心的 坐标
        Target[1] = Target[1] + Center[1]
        Target[2] = Target[2] + Center[2]
    end
    return Target
end