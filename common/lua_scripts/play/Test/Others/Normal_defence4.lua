--desc: hello

--Tier、Kicker、Receiver防守转换

Kicker2BallDir = function()
    return CRole2BallDir("Kicker")
end
Receiver2BallDir = function()
    return CRole2BallDir("Receiver")
end
Tier2BallDir = function()
    return CRole2BallDir("Tier")
end
-----使角色朝向球

function getOppNum()
    local oppTable = CGetOppNums()

    -- pairs 迭代 table元素的迭代器

    for i, val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value
        num = tonumber(val) -- 把 value 字符串转为数字

        if COppIsGetBall(num - 1) then
            return true
        end
    end
end
-----获得敌方拿球队员序号num

----------------------------------------------------------------------------------------
--我方球员是否两个及以上在中场前
function IsOurRole_F()
    local OurKicker_x = COurRole_x("Kicker")
    local OurReceiver_x = COurRole_x("Receiver")
    local OurTier_x = COurRole_x("Tier")
    if OurKicker_x > -180 and OurReceiver_x > -180 then
        return true
    elseif OurKicker_x > -180 and OurTier_x > -180 then
        return true
    elseif OurReceiver_x > -180 and OurTier_x > -180 then
        return true
    end
end
--我方球员是否两个及以上在中场后
function IsOurRole_B()
    local OurKicker_x = COurRole_x("Kicker")
    local OurReceiver_x = COurRole_x("Receiver")
    local OurTier_x = COurRole_x("Tier")
    if OurKicker_x < -180 and OurReceiver_x < -180 then
        return true
    elseif OurKicker_x < -180 and OurTier_x < -180 then
        return true
    elseif OurReceiver_x < -180 and OurTier_x < -180 then
        return true
    end
end

-----------------------------------------------------
---拿球球员是否在前半场
function IsOppNum_x_F()
    local OppGetBall_x = COppNum_x(num - 1)

    if OppGetBall_x > 0 then
        return true
    end
end
--
-- function IsOppNum_x1_R()
-- 	local OppGetBall_x = COppNum_x(num-1)
-- 	local OppGetBall_y = COppNum_y(num-1)
-- 	if OppGetBall_x > 180 and OppGetBall_y > 0 then
-- 		return true
-- 	end
-- end
---拿球球员是否在中后场
function IsOppNum_x_M()
    local OppGetBall_x = COppNum_x(num - 1)

    if OppGetBall_x < 0 and OppGetBall_x > -180 then
        return true
    end
end
--
-- function IsOppNum_x2_R()

-- 	local OppGetBall_x = COppNum_x(num-1)
--     local OppGetBall_y = COppNum_y(num-1)
-- 	if OppGetBall_x < 180 and OppGetBall_x > -180 and  OppGetBall_y > 0 then
-- 		return true
-- 	end
-- end
---拿球球员是否在后场
function IsOppNum_x_B()
    local OppGetBall_x = COppNum_x(num - 1)

    if OppGetBall_x < -180 then
        return true
    end
end
--
-- function IsOppNum_x3_R()

-- 	local OppGetBall_x = COppNum_x(num-1)
--     local OppGetBall_y = COppNum_y(num-1)
-- 	if OppGetBall_x < -180 and OppGetBall_y > 0 then
-- 		return true
-- 	end
-- end
------------------------------------------------用在前场\中场情况下
---拿球队员是否在左场
function IsOppNum_y_L()
    local OppGetBall_y = COppNum_y(num - 1)
    if OppGetBall_y < -100 then
        return true
    end
end
---拿球队员是否在中左场
function IsOppNum_y_ML()
    local OppGetBall_y = COppNum_y(num - 1)
    if OppGetBall_y > -100 and OppGetBall_y < 0 then
        return true
    end
end
---拿球队员是否在中右场
function IsOppNum_y_MR()
    local OppGetBall_y = COppNum_y(num - 1)
    if OppGetBall_y > 0 and OppGetBall_y < 100 then
        return true
    end
end
---拿球队员是否在右场
function IsOppNum_y_R()
    local OppGetBall_y = COppNum_y(num - 1)
    if OppGetBall_y > 100 then
        return true
    end
end
------------------------------------------
gPlayTable.CreatePlay {
    firstState = "Start",
    ["Start"] = {
        switch = function()
            getOppNum()
            if COppIsGetBall(num - 1) then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end
    },
    ["Attack"] = {
        switch = function()
            if true then
                return "Defence"
            end
        end
    },
    
    ["Defence"] = {
        switch = function()
            if IsOppNum_x_F() and IsOurRole_B() and IsOppNum_y_L() then
                return "Frontcourt_L"
            elseif IsOppNum_x_F() and IsOurRole_B() and IsOppNum_y_ML() then
                return "Frontcourt_ML"
            elseif IsOppNum_x_F() and IsOurRole_B() and IsOppNum_y_MR() then
                return "Frontcourt_MR"
            elseif IsOppNum_x_F() and IsOurRole_B() and IsOppNum_y_R() then
                --
                return "Frontcourt_R"
            elseif IsOppNum_x_F() and IsOurRole_F() and IsOppNum_y_L() then
                return "Rush_L"
            elseif IsOppNum_x_F() and IsOurRole_F() and IsOppNum_y_ML() then
                return "Rush_ML"
            elseif IsOppNum_x_F() and IsOurRole_F() and IsOppNum_y_MR() then
                return "Rush_MR"
            elseif IsOppNum_x_F() and IsOurRole_F() and IsOppNum_y_R() then
                --
                return "Rush_R"
            elseif IsOppNum_x_M() and IsOppNum_y_L() then
                return "Midfield_L"
            elseif IsOppNum_x_M() and IsOppNum_y_ML() then
                return "Midfield_ML"
            elseif IsOppNum_x_M() and IsOppNum_y_MR() then
                return "Midfield_MR"
            elseif IsOppNum_x_M() and IsOppNum_y_R() then
                --
                return "Midfield_R"
            elseif IsOppNum_x_B() and IsOppNum_y_L() then
                return "Backcourt_L"
            elseif IsOppNum_x_B() and IsOppNum_y_ML() then
                return "Backcourt_ML"
            elseif IsOppNum_x_B() and IsOppNum_y_MR() then
                return "Backcourt_MR"
            elseif IsOppNum_x_B() and IsOppNum_y_R() then
                return "Backcourt_R"
            end
        end
    },
    ------------------------------------------
    --对方拿球队员在前场情况下，我方球员若两个及以上在前场，则上前防卫；若两个及以上在后场，则都退回守门员边界防守。
    ["Rush_L"] = {
        switch = function()
            if IsOppNum_x_M() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_ML() or IsOppNum_y_MR() or IsOppNum_y_R() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
        Tier = task.GotoPos("Tier", -226, -56, Tier2BallDir),
        Goalie = task.Goalie()
    },
    --
    ["Rush_ML"] = {
        switch = function()
            if IsOppNum_x_M() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_L() or IsOppNum_y_MR() or IsOppNum_y_R() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
        Tier = task.GotoPos("Tier", -220, -24, Tier2BallDir),
         ---------------------------------------------------------
        Goalie = task.Goalie()
    },
    --
    ["Rush_MR"] = {
        switch = function()
            if IsOppNum_x_M() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_L() or IsOppNum_y_ML() or IsOppNum_y_R() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
        Tier = task.GotoPos("Tier", -220, 24, Tier2BallDir),
        Goalie = task.Goalie()
    },
    --
    ["Rush_R"] = {
        switch = function()
            if IsOppNum_x_M() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_L() or IsOppNum_y_ML() or IsOppNum_y_MR() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
        Tier = task.GotoPos("Tier", -220, 56, Tier2BallDir),
        Goalie = task.Goalie()
    },
    ---Tier、Kicker、Receiver都在后场左边防守。
    ["Frontcourt_L"] = {
        switch = function()
            --？当先执行⬆，switch不加{}会出现错误警告：'}' expected (to close '{' at line 119) near 'switch'
            if IsOppNum_x_M() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_ML() or IsOppNum_y_MR() or IsOppNum_y_R() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
         ------======
        Receiver = task.GotoPos("Receiver", -220, -63, Receiver2BallDir),
        Tier = task.GotoPos("Tier", -230, -88, Tier2BallDir),
        Goalie = task.Goalie()
    },
    --
    ["Frontcourt_ML"] = {
        switch = function()
            --？当先执行⬆，switch不加{}会出现错误警告：'}' expected (to close '{' at line 119) near 'switch'
            if IsOppNum_x_M() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_L() or IsOppNum_y_MR() or IsOppNum_y_R() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.GotoPos("Receiver", -220, -10, Receiver2BallDir),
        Tier = task.GotoPos("Tier", -220, -44, Tier2BallDir),
        Goalie = task.Goalie()
    },
    ---Tier、Kicker、Receiver都在后场右边防守。
    ["Frontcourt_MR"] = {
        switch = function()
            --？当先执行⬆，switch不加{}会出现错误警告：'}' expected (to close '{' at line 119) near 'switch'
            if IsOppNum_x_M() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_L() or IsOppNum_y_ML() or IsOppNum_y_R() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.GotoPos("Receiver", -220, 10, Receiver2BallDir),
        Tier = task.GotoPos("Tier", -220, 44, Tier2BallDir),
        Goalie = task.Goalie()
    },
    --
    ["Frontcourt_R"] = {
        switch = function()
            --？当先执行⬆，switch不加{}会出现错误警告：'}' expected (to close '{' at line 119) near 'switch'
            if IsOppNum_x_M() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_L() or IsOppNum_y_ML() or IsOppNum_y_MR() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.GotoPos("Receiver", -220, 63, Receiver2BallDir),
        Tier = task.GotoPos("Tier", -230, 88, Tier2BallDir),
        Goalie = task.Goalie()
    },
    -----------
    --Receiver、Tier在守门员边界前偏左，Kicker在前方防守。
    ["Midfield_L"] = {
        switch = function()
            if IsOppNum_x_F() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_ML() or IsOppNum_y_MR() or IsOppNum_y_R() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
         ----------====
        Tier = task.GotoPos("Tier", -220, -50, Tier2BallDir),
        Goalie = task.Goalie()
    },
    ["Midfield_ML"] = {
        switch = function()
            if IsOppNum_x_F() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_L() or IsOppNum_y_MR() or IsOppNum_y_R() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
        Tier = task.GotoPos("Tier", -220, -40, Tier2BallDir),
        Goalie = task.Goalie()
    },
    --Receiver、Tier在守门员边界前偏右，Kicker在前方防守。
    ["Midfield_MR"] = {
        switch = function()
            if IsOppNum_x_F() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_L() or IsOppNum_y_ML() or IsOppNum_y_R() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
        Tier = task.GotoPos("Tier", -220, 40, Tier2BallDir),
        Goalie = task.Goalie()
    },
    ["Midfield_R"] = {
        switch = function()
            if IsOppNum_x_F() or IsOppNum_x_B() then
                return "Defence"
            elseif IsOppNum_y_L() or IsOppNum_y_ML() or IsOppNum_y_MR() then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
        Tier = task.GotoPos("Tier", -220, 50, Tier2BallDir),
        Goalie = task.Goalie()
    },
    -----------
    ---Tier在守门员边界前偏左，Kicker、Receiver在前方防守。
    ["Backcourt_L"] = {
        switch = function()
            if IsOppNum_x_F() or IsOppNum_x_M() then
                -- elseif IsOppNum_y_ML() or IsOppNum_y_MR() or IsOppNum_y_R() then
                -- 	return "Defence"
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
        Tier = task.NormalDef("Tier"),
        Goalie = task.Goalie()
    },
    --
    -- ["Backcourt_ML"] = {
    -- 	Kicker = task.NormalDef("Kicker"),
    -- 	Receiver = task.NormalDef("Receiver"),
    --     Tier = task.GotoPos("Tier",-220,-50,Tier2BallDir),
    --     Goalie = task.Goalie()
    -- {switch = function()
    --     if IsOppNum_x_F() or IsOppNum_x_M() then
    --         return "Defence"
    --     elseif IsOppNum_y_L() or IsOppNum_y_MR() or IsOppNum_y_R() then
    --     	return "Defence"
    -- 	elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
    -- 	    return "Attack"
    --     end
    -- end, }
    -- },
    ---Tier在守门员边界前偏右，Kicker、Receiver在前方防守。
    -- ["Backcourt_MR"] = {
    -- 	Kicker = task.NormalDef("Kicker"),
    -- 	Receiver = task.NormalDef("Receiver"),
    --     Tier = task.GotoPos("Tier",-220,50,Tier2BallDir),
    --     Goalie = task.Goalie()
    -- {switch = function()
    --     if IsOppNum_x_F() or IsOppNum_x_B() then
    --         return "Defence"
    --     elseif IsOppNum_y_L() or IsOppNum_y_ML() or IsOppNum_y_R() then
    --     	return "Defence"
    -- 	elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
    -- 	    return "Attack"
    --     end
    -- end, }
    -- },
    --
    ["Backcourt_R"] = {
        switch = function()
            if IsOppNum_x_F() or IsOppNum_x_M() then
                -- elseif IsOppNum_y_L() or IsOppNum_y_ML() or IsOppNum_y_MR() then
                -- 	return "Defence"
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end,
        Kicker = task.NormalDef("Kicker"),
        Receiver = task.NormalDef("Receiver"),
        Tier = task.NormalDef("Tier"),
        Goalie = task.Goalie()
    },
name = "Normal_defence4"
}
