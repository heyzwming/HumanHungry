
--祈祷收工

--加油，蔡徐坤！你是最棒的！就算要修改again，你也是最靓的篮球王子！
--坤坤放心飞，ikun永相随
--改代码的坤坤，才散发着迷人的美丽，才是当之无愧的九亿少女的梦！！

------------------------------------全局Table---------------------------------------------
OurNumTable ={["Kicker"]=1,["Receiver"]=2,["Tier"]=3,["Goalie"]=4}
OurTable ={[1]="Kicker",[2]="Receiver",["Tier"]=3,["Goalie"]=4}
oppTable = function()
    return CGetOppNums()
end
--oppTable = CGetOppNums()

------------------------------------- 极坐标转直角坐标---------------------------------------

function Polar2Vector(length,dir)
    -- math.cos()：传入弧度
    -- math.rad(): 角度制转弧度制
    return length * math.cos(math.rad(dir)), length * math.sin(math.rad(dir))
end
-- 注意函数返回两个值，需要用两个值来接受返回的值   例如：  x,y = function Polar2Vector(length,dir)


------------------------------获得己方球员到球的方向--------------------------------------
--★

function GetOurDir2Ball(role)
    local OurDir2BallTable = {["Kicker"] = CRole2BallDir("Kicker"),["Receiver"] = CRole2BallDir("Receiver"),["Tier"] = CRole2BallDir("Tier"),["Goalie"] = CRole2BallDir("Goalie")}      
    return OurDir2BallTable[role]       -- 返回存储四个角色朝向球的方向的table
end


-------------------------------获得敌方球员到球的方向-------------------------------------
--★★

function GetOppDir2Ball(num)
    local OppPlayerDirTable ={[1]=CGetOppNum2BallDir(tonumber(CGetOppNums[0])),[2]=CGetOppNum2BallDir(tonumber(CGetOppNums[1])),[3]=CGetOppNum2BallDir(tonumber(CGetOppNums[2])),[4]=CGetOppNum2BallDir(tonumber(CGetOppNums[3]))}
        return OppPlayerDirTable(num)	
end
------------------------------------获得己方球员编号--------------------------------------
--★    

function GetOurNum(role)
  --  local OurNumTable ={["Kicker"]=1,["Receiver"]=2,["Tier"]=3,["Goalie"]=4}
    return OurNumTable[role]
end     

-------------------------------------获得敌方球员编号-------------------------------------
--★★
function GetOppNum()
    --local oppTable = CGetOppNums()      
	for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value    
		local num = tonumber(val) -- 把 value 字符串转为数字
        oppTable[i-1] = num   --{[0] = "n1"]}--> {[0] = n1}
	end
	return oppTable		
end
--把 {[0] = "n1"]} 形式的返回值  转换成  {[0] = n1} 形式
-------------------------------------获得己方球员名称------------------------------------
--★★
function GetOurName(num)
    --local OurTable ={[1]="Kicker",[2]="Receiver",["Tier"]=3,["Goalie"]=4}
    return OurTable[num]
end
-------------------------------------判断哪方持球----------------------------------------
--★★
WhichGetBall = function()
	for i,val in pairs(OurTable) do    --己方持球，返回1
        if CIsGetBall(OurTable[i]) == true then
            return 1
        end
    end    
    for i,val in pairs(oppTable) do  --敌方持球，返回2
        local num = tonumber(val)   
        if COppIsGetBall(num-1) == true then
            return 2
        end
    end
    return 0             --无人持球，返回0
end


-----------------------------获得对方持球球员编号num--------------------------------------
--★★
-- if CIsGetBall(num-1) then    -- CIsGetBall() 
--			break
--        end	
-- 为什么一个获得对方持球球员编号的num要用CIsGetBall检查我方球员有没有持球？ （可以删掉）
--reply:因为如果我方球员持球了，对方就不存在持球球员，就可以不用执行了。
GetOppBallerNum = function()
    --local oppTable = CGetOppNums()      
	for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value    
		local num = tonumber(val) -- 把 value 字符串转为数字
        if CIsGetBall(num-1) then    -- CIsGetBall() 
			break
        end	
        if COppIsGetBall(num-1) == true then
            return 	num
        end
	end
			
end


---------------------------------------返回己方拿球球员编号----------------------------------------------
--★★

GetOurBallerNum = function()
    local ourTable = {[1]="Kicker",[2]="Receiver",[3]="Tier",[4]="Goalie"}      
	for i,val in pairs(ourTable) do -- 遍历 表 oppTable里的所有 key 和 value    
        local Player = val 
        if CIsGetBall(Player) == true then
            return i
        end
    end
end
--------------------------------------------获得己方拿球球员名称---------------------------
--★★  问题：
--我想要达到的效果是，球一到谁手上，WhoGetBall就返回谁的名字。这个在状态机中，可以实现动态地判别吗？
--还是这个程序，只会被使用一次？刚开始检测到谁是WGB了，谁就一直是WGB？
WhoGetBall = function()
    return GetOurName(GetOurBallerNum)
end  
------------------------------------随机变化的三角阵型---------------------------
--★★
-- ★★★★★★★★★★★★★★
--先安排了几种站位，瘦三角，宽三角，钝角三角形

--[[

function IsoTriFormation(num)
    if num == 1 then
        Spy1 = GotoPos(Spy1,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(160,15),COurRole2RoleDir(Spy1,WhoGetBall))
        Spy2 = GotoPos(Spy2,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(160,-15),COurRole2RoleDir(Spy2,WhoGetBall))
    elseif num == 2 then
        Spy1 = GotoPos(Spy1,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(140,30),COurRole2RoleDir(Spy1,WhoGetBall))
        Spy2 = GotoPos(Spy2,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(140,-30),COurRole2RoleDir(Spy2,WhoGetBall))
    elseif num==3 then
        Spy1 = GotoPos(Spy1,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(110,60),COurRole2RoleDir(Spy1,WhoGetBall))
        Spy2 = GotoPos(Spy2,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(100,0),COurRole2RoleDir(Spy2,WhoGetBall))
    end
end

]]

------------------------------------1号间谍角色安排-------------------------
--想问一下这个Spy1是不是一直在变化的？
Spy1 = function()  --间谍1号角色安排             

    if WhoGetBall == "Kicker" then
        return "Receiver"
    end

    if WhoGetBall == "Receiver"then
        return "Tier"
    end

    if WhoGetBall == "Tier" then
        return "Kicker"
    end
end
------------------------------------获取1号间谍的号码------------------------------------------
--★
Spy1ID = function()
    local ourTable = {[1]="Kicker",[2]="Receiver",[3]="Tier",[4]="Goalie"}      
	for i,val in pairs(ourTable) do -- 遍历 表 oppTable里的所有 key 和 value    
        local num = i    
        if ourTable[num] == Spy1 then
            return num
        end
    end
end

----------------------------------2号间谍角色安排------------------------------------------     
Spy2 = function() --间谍2号角色安排
    if WhoGetBall == "Kicker" then
        return "Tier"
    end

    if WhoGetBall == "Receiver"then
        return "Kicker"
    end

    if WhoGetBall == "Tier" then
        return "Receiver"
    end
end
------------------------------------------获取2号间谍的号码---------------------------------
--★
Spy2ID = function()
    local ourTable = {[1] = "Kicker",[2] = "Receiver",[3] = "Tier",[4] = "Goalie"}      
	for i,val in pairs(ourTable) do -- 遍历 表 oppTable里的所有 key 和 value    
        local num = i      
        if ourTable[num] == Spy2 then
            return num
        end
        
    end
end

------------------------------------两个角色之间无障碍----------------------------------------------
--★★
function NoOthers(name1,name2)
    --name1到name2路径上有无障碍，以敌方坐标是否在name1与name2线段上，或敌方距此线段距离在20cm内，作为判断标准
   
    local x1 = COurRole_y(name1)
    local x2 = COurRole_y(name2)
    local y1 = COurRole_x(name1)
    local y2 = COurRole_x(name2)
    local A = (y2-y1)/(x2-x1)
    local B = -1
    local C = y1-((y2-y1)/(x2-x1))*x1
    for i,val in pairs(oppTable) do
        local num = tonumber(val)
        if COppNum_x(num-1) == A*COppNum_y(num-1)+y1-C and (COurRole_x(name1)<COppNum_x(num-1)<COurRole_x(name2) or COurRole_x(name1)>COppNum_x(num-1)>COurRole_x(name2)) and math.abs((A*COppNum_y(num-1)+B*COppNum_x(num-1)+C)/math.sqr(math.pow(A,2)+math.pow(B,2)))<20 then
            return false
        else 
            return true
        end
    end

end
-------------------------------------两个角色所构成直线上有无敌方--------------------------------------
--★★
NoOthersInLine = function(name1,name2)--name1到name2延长线上有无敌方
    
    local x1 = COurRole_y(name1)
    local x2 = COurRole_y(name2)
    local y1 = COurRole_x(name1)
    local y2 = COurRole_x(name2)
    for i,val in pairs(oppTable) do
        local num = tonumber(val)
        if COppNum_x(num-1) == (y2-y1)/(x2-x1)*COppNum_y(num-1)+y1-((y2-y1)/(x2-x1))*x1 and not(COurRole_x(name1)<COppNum_x(num-1)<COurRole_x(name2) or COurRole_x(name1)>COppNum_x(num-1)>COurRole_x(name2)) or COurRole2OppRoleDist(name2,num-1)<20 then
            return false
        else 
            return true
        end
    end
end

--------------------------------------可以传给谁/谁可以接球----------------------------------------
--★★
-- NoOther函数的定义和声明应该要在使用以前
--reply:是这么声明的吗？
function WhoCanReceiveBall(WhoGetBall) --得知可传给谁
    --local ourTable = {[1]="Kicker",[2]="Receiver",[3]="Tier",[4]="Goalie"}      
	for i,val in pairs(ourTable) do     
        local Player = val     
        if NoOthers(WhoGetBall,Player) == true then
            return Player
        end
    end
end
    

-------------------------------------------------本队队员到敌方队员的距离-------------------------------

COurRole2OppRoleDist = function(role1,ID2)    
    local x1 = COurRole_y(role1)
    local y1 = COurRole_x(role1)
    local x2 = COppNum_y(ID2)
    local y2 = COppNum_x(ID2)
    local d = math.sqrt(math.pow(x1-x2,2)+math.pow(y1-y2,2))
    return d
end

--------------------------------------------------敌方守门员编号-----------------------------------------
--★★
--OppGoalie = 4
OppGoalie = function() --根据敌方位置，判断几号是守门员
    for i,val in pairs(oppTable) do    
        local num = tonumber(val)  
        if COppNum_x(num-1) >= 280.25 and -80 < COppNum_y(num-1) < 80 then
            return num
        end
    end
    return 4
end

---------------------------------------球在前(1) 中(2) 后(3)场----------------------------
BallPosition = function()--根据球的位置，确定前场中场后场
    if CGetBallX() > 180 then
        return 1
    elseif CGetBallX() > -180 then
        return 2
    else
        return 3
    end
end
----------------------------------------是否能直接射门-----------------------------------------------
--★★
Shoot2Goal = function()
    local x1 = COurRole_y(WhoGetBall)
    local x2 = CGetBallY()
    local y1 = COurRole_x(WhoGetBall)
    local y2 = CGtBllX()
    local k = math.cot(COurRoleDir(WhoGetBall))
    local b=y1-k*x1
    if y2==k*x2+b then
        return false
    else
        return true
    end
end

--------------------------------------DefenceFunction---------------------------------------------------------
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

-----------------------------------------状态机------------------------------------
gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
--★★ 
-- 先跳转，再分配        
["Start"] = {
    switch = function ()
        if WhichGetBall == 2 then   -- 对方持球
            return "Defence" --没拿到球，跳出，转到防守战术   
        elseif WhichGetBall == 0 then --
            return "FightForBall"
        else 
            if BallPosition == 1 then --前场
                return "FrontTacticsPos1"

            elseif BallPosition == 2 then --中场
                    return "MidTacticsPos1"

            elseif BallPosition == 3 then --后场
                return "BackTacticsPos1"
            end
        end
    end,
},

["FightForBall"] = {    --抢球，分为抢到和没抢到两个情况
    switch = function()  
        if WhichGetBall == 2 then
            return "Defence"
        elseif WhichGetBall == 1 then
            return "Start"  --重新检测球的状态，根据球的位置实行不同的战略  
        end
    end,

        Kicker=task.ReceiveBall("Kicker"),
        Receiver=task.ReceiveBall("Receiver"),
        Tier=task.ReceiveBall("Tier"),
        Goalie = task.Goalie()


},

--------------------------------------前场战术---------------------------------------

["FrontTacticsPos1"]={ --基于球在自己手上的情况，进行讨论

    switch = function()
        if Shoot2Goal==true then --如果能直接射门（在没有摆阵型的情况下射门）
            return "WGBShoot" 
    
        else                      --如果不能直接射门
            --[[ WhoGetBall  = task.GotoPos(WhoGetBall,565,86.18,CRole2OppGoalDir(WhoGetBall))--无法直接射门，先三角站位
             Spy1        = task.GotoPos(Spy1,565,-86.18,CRole2OppGoalDir(WhoGetBall))
             Spy2        = task.GotoPos(Spy2,525,0,COppNumDir(OppGoalie)-180)]]
            return "FrontTacticsNo1"--并执行下一步计划
        
        end
    end,
},

["WGBShoot"]={
    switch = function()
        local i = 0
        if i == 1 then
         if COppIsBallKick(OppGoalie)==true or CGetBallX()<302.5 then   --如果球被弹出，捡漏
          return "FightForBall"
         else
         return "Start"
         end 
        end
    end,

    WhoGetBall  = task.Shoot(WhoGetBall),--改进：这里也许可以安排一下其他两名成员做捡漏准备   
    i = 1     
},

["FrontTacticsNo1"]={

    switch = function()
        local i = 0
        local positon = OppGoalie - 180
        if i == 1 then
            if Shoot2Goal==true then
                return "WGBShoot"
            else  
                if NoOthers(WhoGetBall,Spy1) then --可传给1
            --[[WhoGetBall  = task.PassBall(WhoGetBall,Spy1)
            Spy1        = task.GetBall(Spy1,WhoGetBall)
            --安排队友捡漏]]
                    return "Spy1ShootReady"
                elseif NoOthers(WhoGetBall,Spy2) then --不可传给1，但可传给2
            --[[WhoGetBall  = task.PassBall(WhoGetBall,Spy2)
            Spy2        = task.GetBall(Spy2,WhoGetBall)
            --安排队友捡漏]]
                    return "Spy2ShootReady"
                else --不可传给1，也不可传给2
                    return "MoveAroundCir"
                end
            end
        end       
    end,

    WhoGetBall  = task.GotoPos(WhoGetBall,565,86.18,CRole2OppGoalDir(WhoGetBall)),--无法直接射门，先三角站位
    Spy1        = task.GotoPos(Spy1,565,-86.18,CRole2OppGoalDir(WhoGetBall)),
    --Spy2        = task.GotoPos(Spy2,525,0,COppNumDir(OppGoalie)-180), --站在禁区最左，最右，最中间3个点上
    Spy2        = task.GotoPos(Spy2,525,0,position), --站在禁区最左，最右，最中间3个点上
    i = 1
},
--存疑
["FrontSpy1ShootReady"]={
    switch = function()
        local i=0
        if i == 1 then
            return "Spy1Shoot"
        end
    end,
        WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
        Spy1        = task.GetBall(Spy1,WhoGetBall),
        i = 1
},

["FrontSpy1Shoot"]={
    switch = function()
        local i = 0
        if i == 1 then
            if WhichGetBall==1 then --接到球了，此时原先的SPY1变成了WGB
                return "FrontTacticsPos1"
            else
                if WhichGetBall==0 then
                    return "FightForBall"
                elseif WhichGetBall==2 then
                    return "Defence"
                end
            end
        end
    end,
    WhoGetBall = task.Shoot("WhoGetBall"),
    i = 1
},

--存疑
["FrontSpy2ShootReady"]={
    switch = function()
        if CIsBallKick(WhoGetBall)==true then
            return "Spy2Shoot"
        end
    end,
        WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
        Spy2        = task.GetBall(Spy2,WhoGetBall)

},

["FrontSpy2Shoot"]={
    switch = function()
        local i = 0
        if i == 1 then
            if WhichGetBall==1 then --接到球了，此时原先的SPY2变成了WGB
                return "FrontTacticsPos1"
            else
                if WhichGetBall==0 then
                    return "FightForBall"
                elseif WhichGetBall==2 then
                    return "Defence"
                end
            end
        end
    end,
    WhoGetBall = task.Shoot("WhoGetBall"),
    i = 1
},

---存疑 
--存疑 写的不对，我要的是一个随机位置。不然会陷入死循环
["MoveAroundCir"]={
    switch = function()
        local position = COppNumDir(OppGoalie) - 180
        local i = 0
        if i == 1 then
            return "FrontTacticsNo1"
        end
    end,
    WhoGetBall  = task.GotoPos(WhoGetBall,540,80,CRole2OppGoalDir(WhoGetBall)),--无法直接射门，先三角站位
    Spy1        = task.GotoPos(Spy1,540,-80,CRole2OppGoalDir(WhoGetBall)),
    Spy2        = task.GotoPos(Spy2,525,0,position),
    i = 1

},

["FrontTacticsNo2"]={

    switch = function()
        if COppIsBallKick(OppGoalie)==true or CGetBallX()<302.5 then   --如果球被弹出，捡漏
            Spy2        = task.ReceiveBall(Spy2) --捡漏队友离目标点最近，去接球
            return "Spy2Shoot"
        else
            return "Start"
        end
    end

},

["FrontTacticsNo3"]={

    switch = function()
        if COppIsBallKick(OppGoalie)==true or CGetBallX()<302.5 then   --如果球被弹出，捡漏
            Spy1        = task.ReceiveBall(Spy1) --捡漏队友离目标点最近，去接球
            return "Spy1Shoot"
        else
            return "Start"    --如果球进了，返回Start
        end
    end

},

--------------------------------------中场战术-------------------------------------------
["MidTacticsPos1"]={
    switch = function()
        if NoOthers(WhoGetBall,OppGoalie)==true then--持球者到守门员这段路上无障碍
            if Shoot2Goal==true then     --守门员不在持球者的射门直线上
                return "WGBShoot"
            else      --守门员在持球者的射门直线上，持球者变化位置
                return "MidTacticsNo1"
            end
        else --持球者到守门员这段路有障碍
            return "MidTacticsNo1"
        end
    end,
},

["MidTacticsNo1"]={
    switch = function()
        local i = 0
        local Spy1_x,Spy1_y = Polar2Vector(160,15)
        local Spy2_x,Spy2_y = Polar2Vector(160,-15)

        Spy1_x = Spy1_x + COurRole_X(GetOurBallerNum) 
        Spy1_y = Spy1_y + COurRole_Y(GetOurBallerNum)
        Spy2_x = Spy2_x + COurRole_X(GetOurBallerNum)
        Spy2_y = Spy2_y + COurRole_Y(GetOurBallerNum)

        local dir1 = COurRole2RoleDir(Spy1,WhoGetBall)
        local dir2 = COurRole2RoleDir(Spy2,WhoGetBall)
        if i==1 then
            if NoOthers(WhoGetBall,Spy1) == false and  NoOthers(WhoGetBall,Spy2) == true then --到Spy1的路上有敌方,到SPy2的路上无敌方
                return "MidSpy2ShootReady"
            elseif NoOthers(WhoGetBall,Spy1) == true and  NoOthers(WhoGetBall,Spy2)== false then
                return "MidSpy1ShootReady"
            elseif  NoOthers(WhoGetBall,Spy1) == true and  NoOthers(WhoGetBall,Spy2) == true then
                return "MidSpy1ShootReady"
            elseif  NoOthers(WhoGetBall,Spy1) == false and  NoOthers(WhoGetBall,Spy2) == false then
                return "MidTacticsPos1"
            end
        end
    end,
        Spy1=task.GotoPos(Spy1,Spy1_x,Spy1_y,dir1),
        Spy2=task.GotoPos(Spy2,Spy2_x,Spy2_y,dir2),
        i=1 
},

["MidSpy1ShootReady"]={
    switch = function()
        local i=0
        if i == 1 then
            return "MidSpy1Shoot"
        end
    end,
        WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
        Spy1        = task.GetBall(Spy1,WhoGetBall),
        i = 1
},

["MidSpy1Shoot"]={
    switch = function()
        local i = 0
        if i == 1 then
            if WhichGetBall==1 then --接到球了，此时原先的SPY1变成了WGB
                return "MidTacticsPos1"
            end
         else
            if WhichGetBall==0 then
                return "FightForBall"
            elseif WhichGetBall==2 then
                return "Defence"
            end
        end
    end,
    WhoGetBall = task.Shoot("WhoGetBall"),
    i = 1
},

--存疑
["MidSpy2ShootReady"]={
    switch = function()
        if CIsBallKick(WhoGetBall)==true then
            return "MidSpy2Shoot"
        end
    end,
        WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
        Spy2        = task.GetBall(Spy2,WhoGetBall)
},

["MidSpy2Shoot"]={
    switch = function()
        local i = 0
        if i == 1 then
            if WhichGetBall==1 then --接到球了，此时原先的SPY2变成了WGB
                return "MidTacticsPos1"
            else
                    if WhichGetBall==0 then
                        return "FightForBall"
                    elseif WhichGetBall==2 then
                        return "Defence"
            end
         end
        end
    end,
    WhoGetBall = task.Shoot("WhoGetBall"),
    i = 1
},

["MidTacticsPos2"]={
    switch = function()

        local Who_x,Who_y = Polar2Vector(50,0)
        local Spy1_x,Spy1_y = Polar2Vector(30,15)
        local Spy2_x,Spy2_y = Polar2Vector(30,-15)


        Who_x = Who_x + COurRole_X(GetOurBallerNum)
        Who_y = Who_y + COurRole_Y(GetOurBallerNum)
        Spy1_x = Spy1_x + COurRole_X(GetOurBallerNum) 
        Spy1_y = Spy1_y + COurRole_Y(GetOurBallerNum)
        Spy2_x = Spy2_x + COurRole_X(GetOurBallerNum)
        Spy2_y = Spy2_y + COurRole_Y(GetOurBallerNum)

        local dirWho = COurRole2RoleDir(WhoGetBall,Spy1) 
        local dir1 = COurRole2RoleDir(Spy1,WhoGetBall)
        local dir2 = COurRole2RoleDir(Spy2,WhoGetBall)
    
        local i=0
        if i==1 then        
            return "MidTacticsPos1"
        end
    end,

    WhoGetBall  = task.GotoPos(WhoGetBall,Who_x,Who_y,dirWho),
    Spy1        = task.GotoPos(Spy1,Spy1_x,Spy1_y,dir1),
    Spy2        = task.GotoPos(Spy2,Spy2_x,Spy2_y,dir2),
    i=1
    

},





-------------------------------------后场战术------------------------------------------------

["BackTacticsPos1"]={

    switch = function()
        if NoOthers(WhoGetBall,OppGoalie)==true then--持球者到守门员这段路上无障碍
            if Shoot2Goal==true then     --守门员不在持球者的射门直线上
                return "WGBShoot"
                   
            else      --守门员在持球者的射门直线上，持球者变化位置
                    
                 return "BackTacticsNo1"
            end
        else --持球者到守门员这段路有障碍
            return "BackTacticsNo1"
        end
    end,
 
},


["BackTacticsNo1"]={
    switch = function()
        local i = 0
        if i==1 then
            if NoOthers(WhoGetBall,Spy1) == true  then --Spy1在后场前端，是第一接应位
                return "BackSpy1ShootReady"
            else
                return "BackChangePos1"
            end
        end
    end,

    Spy1=task.GotoPos(Spy1,-180,50,CRole2BallDir(Spy1)),
    Spy2=task.GotoPos(Spy2,0,-50,CRole2BallDir(Spy2)),
    i=1 

},

["BackSpy1ShootReady"]={
    switch = function()
        local i=0
        if i == 1 then
            return "BackSpy1Shoot"
        end
    end,
        WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
        Spy1        = task.GetBall(Spy1,WhoGetBall),
        i = 1
},

["BackSpy1Shoot"]={
    switch = function()
        local i = 0
        if i == 1 then
            if WhichGetBall==1 then --接到球了，此时原先的SPY1变成了WGB
                return "BackSpy2ShootReady"
            else
                if WhichGetBall==0 then
                    return "FightForBall"
                elseif WhichGetBall==2 then
                    return "Defence"
                end
            end
        end
    end,
    WhoGetBall = task.Shoot("WhoGetBall"),
    i = 1
},

["BackSpy2ShootReady"]={
    switch = function()
        if CIsBallKick(WhoGetBall)==true then
            return "BackSpy2Shoot"
        end
    end,
        WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
        Spy2        = task.GetBall(Spy2,WhoGetBall)

},

["BackSpy2Shoot"]={
    switch = function()
        
        if WhichGetBall==1 then --接到球了，此时原先的SPY2变成了WGB
            return "MidTacticsPos1"
        else
            if WhichGetBall==0 then
                return "FightForBall"
            elseif WhichGetBall==2 then
                return "Defence"
            end
        end
    end,

},


["BackChangePos1"] = {
    switch = function()
        local i = 0
        if i==1 then
            if NoOthers(WhoGetBall,Spy1) == true  then --Spy1在后场前端，是第一接应位
                return "BackSpy1ShootReady"
            else
                return "BackChangePos2"
            end
        end
    end,
    Spy1=task.GotoPos(Spy1,-180,25,CRole2BallDir(Spy1)),
    i = 1
},

["BackChangePos2"]={
    switch = function()

    local Spy1_x,Spy1_y = Polar2Vector(100,15)
    local Spy2_x,Spy2_y = Polar2Vector(100,-15)

    Spy1_x = Spy1_x + COurRole_X(GetOurBallerNum) 
    Spy1_y = Spy1_y + COurRole_Y(GetOurBallerNum)
    Spy2_x = Spy2_x + COurRole_X(GetOurBallerNum)
    Spy2_y = Spy2_y + COurRole_Y(GetOurBallerNum)

    local dir1 = COurRole2RoleDir(Spy1,WhoGetBall)
    local dir2 = COurRole2RoleDir(Spy2,WhoGetBall)


    local i = 0
        if i==1 then
            return "BackTacticsPos1"
        end
    end,

        Spy1=task.GotoPos(Spy1,Spy1_x,Spy1_y,dir1),
        Spy2=task.GotoPos(Spy2,Spy2_x,Spy2_y,dir2),
        i = 1
},


----------------------------------------------------------Defence----------------------------------------------------------------



    --[[ ["Start"] = {
        switch = function()
            getOppNum()
            if COppIsGetBall(num - 1) then
                return "Defence"
            elseif CIsGetBall("Kicker") or CIsGetBall("Receiver") or CIsGetBall("Tier") then
                return "Attack"
            end
        end
--    },
    ]]
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



name = "2019.5.19 NormalAttack"
}



















