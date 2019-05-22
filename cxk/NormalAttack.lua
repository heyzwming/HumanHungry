
--祈祷收工

--加油，蔡徐坤！你是最棒的！就算要修改again，你也是最靓的篮球王子！
--坤坤放心飞，ikun永相随
--改代码的坤坤，才散发着迷人的魅力，才是当之无愧的九亿少女的梦！！

--Attack的部分交给小胡来改啦！Defence部分，小何要认真改好哦！

--5.20 22:11 现在开启自检模式，不许Say No，不许呕吐。对待自己的代码，要充满爱心。
--代码是我写的，我要，好好，操，我欣赏不来，我想死。
--不行，看完状态机。必须看完。看不完不是人。
------------------------------------全局Table---------------------------------------------
OurNumTable = {["Kicker"] = 1, ["Receiver"] = 2, ["Tier"] = 3, ["Goalie"] = 4}
OurTable = {[1] = "Kicker", [2] = "Receiver", [3] = "Tier", [4] = "Goalie"}
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
-- 修改： 变量名 OurDirTable -> OurDir2BallTable
-- emmmmmmmm这个函数直接返回OurDir2BallTable不就好了不用迭代返回吧？

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
    local y2 = CGetBallX()
    local k = math.cot(COurRoleDir(WhoGetBall))
    local b = y1-k*x1
    if y2 == k*x2+b then
        return false
    else
        return true
    end
end
-----------------------------------------状态机------------------------------------
---------------------------------cxk部分--------------------------------------------
gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
--★★ 
-- 先跳转，再分配        
["Start"] = {
    switch = function ()
        if WhichGetBall == 2 then   -- 地方持球
            return "Defence" --没拿到球，跳出，转到防守战术   
        elseif WhichGetBall == 0 then
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

["FightForBall"]={    --抢球，分为抢到和没抢到两个情况
    switch = function()  
        if WhichGetBall == 2 then
            return "Defence"
        elseif WhichGetBall == 1 then
            return "Start"  --重新检测球的状态，根据球的位置实行不同的战略  
        end
    end,

    Kicker   = task.ReceiveBall("Kicker"),
    Receiver = task.ReceiveBall("Receiver"),
    Tier     = task.ReceiveBall("Tier") 
},
--------------------------------------前场战术---------------------------------------
["FrontTacticsPos1"] = { --基于球在自己手上的情况，进行讨论
    switch = function()
        if Shoot2Goal == true then --如果能直接射门（在没有摆阵型的情况下射门）
            return "WGBShoot" 
    
        else                      --如果不能直接射门
            return "FrontTacticsNo1"--并执行下一步计划
        
        end
    end,
},
-- 问题： local i = 0  if的判断是进不去的，即使后面有i = 1  因为i是局部变量，每一次执行这个状态机，i都会被重新赋值1
-- CGetBallX() < 302.5  是 或判断  这是...去禁区抢球的意思吗...
["WGBShoot"] = {
    switch = function()
        local i = 0
        if i == 1 then
            if COppIsBallKick(OppGoalie) == true or CGetBallX() < 302.5 then   --如果球被弹出，捡漏
                return "FightForBall"
            else
                return "Start"
            end 
        end
    end,

    WhoGetBall  = task.Shoot(WhoGetBall),--改进：这里也许可以安排一下其他两名成员做捡漏准备   
    i = 1     
},
["FrontTacticsNo1"] = {
    switch = function()
        local i = 0
        local positon = OppGoalie - 180
        if i == 1 then
            if Shoot2Goal == true then
                return "WGBShoot"
            else  
                if NoOthers(WhoGetBall,Spy1) then --可传给1
                    return "FrontSpy1ShootReady"
                elseif NoOthers(WhoGetBall,Spy2) then --不可传给1，但可传给2
                    return "FrontSpy2ShootReady"
                else --不可传给1，也不可传给2
                    return "MoveAroundCir"
                end
            end
        end       
    end,
    WhoGetBall  = task.GotoPos(WhoGetBall, 565, 86.18, CRole2OppGoalDir(WhoGetBall)),--无法直接射门，先三角站位
    Spy1        = task.GotoPos(Spy1, 565, -86.18, CRole2OppGoalDir(WhoGetBall)),
    Spy2        = task.GotoPos(Spy2, 525, 0, position), --站在禁区最左，最右，最中间3个点上
    i = 1
},
--存疑
["FrontSpy1ShootReady"] = {
    switch = function()
        local i = 0
        if i == 1 then
            return "FrontSpy1Shoot"
        end
    end,
        WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
        Spy1        = task.GetBall(Spy1,WhoGetBall),
        i = 1
},
["FrontSpy1Shoot"] = { 
    switch = function()
        local i = 0
        if i == 1 then
            if WhichGetBall == 1 then --接到球了，此时原先的SPY1变成了WGB
                return "FrontTacticsPos1"
            else
                if WhichGetBall == 0 then
                    return "FightForBall"
                elseif WhichGetBall == 2 then
                    return "Defence"
                end
            end
        end
    end,
    WhoGetBall = task.Shoot("WhoGetBall"),
    i = 1
},
--存疑
["FrontSpy2ShootReady"] = {
    switch = function()
        if CIsBallKick(WhoGetBall) == true then
            return "FrontSpy2Shoot"
        end
    end,
        WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
        Spy2        = task.GetBall(Spy2,WhoGetBall)

},
["FrontSpy2Shoot"] = {
    switch = function()
        local i = 0
        if i == 1 then
            if WhichGetBall == 1 then --接到球了，此时原先的SPY2变成了WGB
                return "FrontTacticsPos1"
            else
                if WhichGetBall == 0 then
                    return "FightForBall"
                elseif WhichGetBall == 2 then
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
--------------------------------------中场战术-------------------------------------------
["MidTacticsPos1"] = {
    switch = function()
        if NoOthers(WhoGetBall, OppGoalie) == true then--持球者到守门员这段路上无障碍
            if Shoot2Goal == true then     --守门员不在持球者的射门直线上
                return "WGBShoot"
            else      --守门员在持球者的射门直线上，持球者变化位置
                return "MidTacticsNo1"
            end
        else --持球者到守门员这段路有障碍
            return "MidTacticsNo1"
        end
    end,
},
["MidTacticsNo1"] = {
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
        if i == 1 then
            if NoOthers(WhoGetBall,Spy1) == false and  NoOthers(WhoGetBall,Spy2) == true then --到Spy1的路上有敌方,到SPy2的路上无敌方
                return "MidSpy2ShootReady"
            elseif NoOthers(WhoGetBall,Spy1) == true and  NoOthers(WhoGetBall,Spy2)== false then
                return "MidSpy1ShootReady"
            elseif  NoOthers(WhoGetBall,Spy1) == true and  NoOthers(WhoGetBall,Spy2) == true then
                return "MidSpy1ShootReady"
            elseif  NoOthers(WhoGetBall,Spy1) == false and  NoOthers(WhoGetBall,Spy2) == false then
                return "MidTacticsPos2"
            end
        end
    end,
        Spy1 = task.GotoPos(Spy1,Spy1_x,Spy1_y,dir1),
        Spy2 = task.GotoPos(Spy2,Spy2_x,Spy2_y,dir2),
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
            elseif WhichGetBall==0 then
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
["MidSpy2ShootReady"] = {
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
            elseif WhichGetBall==0 then
                return "FightForBall"
            elseif WhichGetBall==2 then
                return "Defence"
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


name = "NormalAttack"
}



















