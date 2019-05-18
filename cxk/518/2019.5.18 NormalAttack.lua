-- (ง •_•)ง
-- 1、获得敌我双方 拿球球员编号(见下面的注释)
-- 2、遍历己方球员的时候用全局的Table类型变量来遍历


-- 5.13
-- 1、我不确定在状态机的 role = task 部分 role能用变量代替哈~ 因为状态机中的Kicker = ...中的Kicker是变量，是会被状态机解析脚本解析并调用，但是如果用Spy1 = “Kicker” 那就变成了字符串了...
--reply1:如果用不了的话，是不是要把变量当初Kicker的引用？
-- 2、用到官方数学库的时候要加上 math.   例如 math.sqrt()  math.pow()
-- 3、lua中没有 自增符号 ++ 
-- 4、195行 的 COurRole2OppRoleDist(role1,ID2) = function() 函数的语法写错了 应该改成COurRole2OppRoleDist = function(role1,ID2)
-- 5、在一个状态机下 一个角色只能做一件事情吧..

-- 5.14
-- 1、按照框架来写，先写switch = funtion() 条件跳转函数，如果满足什么条件跳转到什么状态，然后写role = task  给每个角色分配一个任务

--[[

gPlayTable.CreatePlay{ --红色部分为战术框架主结构
firstState = "",
[] = { --紫色部分为状态框架
    switch = function() --蓝色部分为状态跳转函数
        if ... then
        return ...
    end,
    Role = task --绿色部分为角色、任务分配
},
[] = {
    switch = function()
        if ... then
        return ...
    end,
    Role = task
},
[] = {
    switch = function()
        if ... then
        return ..
    end,
    Role = task
},
name = "" --此处为脚本名
}

]]

-- 2、  if Spy == "Kicker" then
--          Kicker = task.GotoPos("Kicker",0,0,Kicker2BallDir)
--      elseif Spy == "Receiver" then
--          Receiver = task.GotoPos("Receiver",0,0,Receiver2BallDir)  
-- 对Spy进行判断然后执行对应的角色任务，这个角色要指明了到底是谁，不要再用Spy了

-- 3、 去掉全局变量i，修改：在函数内声明局部 循环下标 变量i
-- 4、 a是什么？到现在还没解决...这个问题
-- 5、 下面介绍一种更一般的Table类型变量的初始化方式，我们用

--[[
[expression]显示的表示将被初始化的索引：
opnames = {["+"] = "add", ["-"] = "sub",
["*"] = "mul", ["/"] = "div"}
i = 20; s = "-"
a = {[i+0] = s, [i+1] = s..s, [i+2] = s..s..s}
print(opnames[s]) --> sub
print(a[22]) --> ---
]]


-- Table应用方法
--OurPlayer = { ["Kicker"] = 1, ["Receiver"] = 2, ["Tier"] = 3, ["Goalie"] = 4 }
--print(OurPlayer["Kicker"]) --> return 1
--懂了，老哥


-- 5.16 反馈内容
-- 1、 建议：如果像是这样的经常能用到，而且是比较固定的变量，可以声明为全局变量
--    local ourTable = {[1]="Kicker",[2]="Receiver",[3]="Tier",[4]="Goalie"}  
-- 2、 NoOthers函数没有返回值？
-- 3、 
-- 4、



--早晨起来，拥抱太阳，满满的正能量
------------------------------------全局Table---------------------------------------------
OurNumTable ={["Kicker"]=1,["Receiver"]=2,["Tier"]=3,["Goalie"]=4}
OurTable ={[1]="Kicker",[2]="Receiver",["Tier"]=3,["Goalie"]=4}
oppTable = CGetOppNums()

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
--    3、return 语句...当程序运行到return语句就会退出函数，所以我觉得你的return是不是用错了
--reply 3 :无错哈，满足执行条件，直接返回值，跳出函数就可以了。这里只要一个1或2。
WhichGetBall = function()         
    --local OurTable ={[1]="Kicker",[2]="Receiver",["Tier"]=3,["Goalie"]=4}
    --local oppTable = CGetOppNums()
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
    --[[while i < 12 do
        if COppIsGetBall(i) == true then
            result=2
        end
        
        if CIsGetBall(a[i]) == true then
            result = 1
        end
        i = i + 1
    end
    return result]]
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
-- 那这个函数里的
--[[
    if COppIsGetBall(i-1) then    -- CIsGetBall()
		break
    end	]]
-- 有什么意义？
--reply 同上意义。不加也可以啦


GetOurBallerNum = function()
    local ourTable = {[1]="Kicker",[2]="Receiver",[3]="Tier",[4]="Goalie"}      
	for i,val in pairs(ourTable) do -- 遍历 表 oppTable里的所有 key 和 value    
        local Player = val 
        if CIsGetBall(Player) == true then
            return i
        end
        --[[if COppIsGetBall(i-1) then    -- CIsGetBall()
			break
		end	]]	
    end
--------------------------------------------获得己方拿球球员名称---------------------------
--★★  问题：
--我想要达到的效果是，球一到谁手上，WhoGetBall就返回谁的名字。这个在状态机中，可以实现动态地判别吗？
--还是这个程序，只会被使用一次？刚开始检测到谁是WGB了，谁就一直是WGB？
WhoGetBall = function()
  function GetOurName(num)
    return   GetOurName(GetOurBallerNum)
end  
------------------------------------随机变化的三角阵型---------------------------
★★
--先安排了几种站位，瘦三角，宽三角，钝角三角形
function IsoTriFormation(num)
    if num==1 then
    Spy1 = GotoPos(Spy1,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(160,15),COurRole2RoleDir(Spy1,WhoGetBall))
    Spy2 = GotoPos(Spy2,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(160,-15),COurRole2RoleDir(Spy2,WhoGetBall))
    else if num==2 then
        Spy1 = GotoPos(Spy1,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(140,30),COurRole2RoleDir(Spy1,WhoGetBall))
        Spy2 = GotoPos(Spy2,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(140,-30),COurRole2RoleDir(Spy2,WhoGetBall))
    else if num==3 then
        Spy1 = GotoPos(Spy1,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(110,60),COurRole2RoleDir(Spy1,WhoGetBall))
        Spy2 = GotoPos(Spy2,get_our_player_pos(GetOurNum(WhoGetBall))+Polar2Vector(100,0),COurRole2RoleDir(Spy2,WhoGetBall))
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
NoOthers = function(name1,name2)
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
        if COppNum_x(num-1)==(y2-y1)/(x2-x1)*COppNum_y(num-1)+y1-((y2-y1)/(x2-x1))*x1 and ~(COurRole_x(name1)<COppNum_x(num-1)<COurRole_x(name2) or COurRole_x(name1)>COppNum_x(num-1)>COurRole_x(name2)) or COurRole2OppRoleDist(name2,num-1)<20 then
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
    NoOthers = function(name1,name2)
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
OppGoalie = function() --根据敌方位置，判断几号是守门员
    for i,val in pairs(oppTable) do     
        local num=tonumber(val)  
        if COppNum_x(num-1) >= 280.25 and -80 < COppNum_y(num-1) < 80 then
            return num
        end
    end
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

-----------------------------------------状态机------------------------------------
gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
--★★你上次讲的，switch=function()后，在某个位置突然就end了。这个我很不明白诶。        
["Start"] = {
    switch = function ()		
        
        --if CIsGetBall("Kicker") == false or CIsGetBall("Receiver") == false or CIsGetBall("Tier") == false then
        if WhichGetBall==2 then
            return "Defence" --没拿到球，跳出，转到防守战术   
        else if WhichGetBall==0 then
            return "FightForBall"
            --[[ 建议 使用枚举类型 ]]
            --[[ TODO： 细化对 前中后场 的位置 ]]
        else 
           if BallPosition == 1 then --前场
            return "FrontTacticsPos1"

           elseif BallPosition == 2 then --中场
            return "MidTacticsPos1"

           elseif BallPosition == 3 then --后场
            return "BackTacticsPos1"
        end
    end,
},

["FightForBall"]={    --抢球，分为抢到和没抢到两个情况
    switch = function()
      Kicker=task.ReceiveBall("Kicker")   
      Receiver=task.ReceiveBall("Receiver")
      Tier=task.ReceiveBall("Tier")
    if WhichGetBall==2 then
        return "Defence"
    else if WhichGetBall==1 then
        return "Start"  --重新检测球的状态，根据球的位置实行不同的战略
    end
}

--------------------------------------前场战术---------------------------------------

["FrontTacticsPos1"]={ --基于球在自己手上的情况，进行讨论

    switch = function()
        if Shoot2Goal==true then --如果能直接射门（在没有摆阵型的情况下射门）
             WhoGetBall  = task.Shoot(WhoGetBall)--改进：这里也许可以安排一下其他两名成员做捡漏准备
             if COppIsBallKick(OppGoalie)==true or CGetBallX()<302.5 then   --如果球被弹出，捡漏
                return "FightForBall"
            else
                return "Start"
            end 
        else                      --如果不能直接射门
             WhoGetBall  = task.GotoPos(WhoGetBall,565,86.18,CRole2OppGoalDir(WhoGetBall))--无法直接射门，先三角站位
             Spy1        = task.GotoPos(Spy1,565,-86.18,CRole2OppGoalDir(WhoGetBall))
             Spy2        = task.GotoPos(Spy2,525,0,COppNumDir(OppGoalie)-180)
            return "FrontTacticsNo1"--并执行下一步计划
        
        end

}


["FrontTacticsNo1"]={

    switch = function()
        if NoOthers(WhoGetBall,Spy1) then 
            WhoGetBall  = task.PassBall(WhoGetBall,Spy1)
            Spy1        = task.GetBall(Spy1,WhoGetBall)
            --安排队友捡漏
            return "Spy1Shoot"
        else if NoOthers(WhoGetBall,Spy2) then 
            WhoGetBall  = task.PassBall(WhoGetBall,Spy2)
            Spy2        = task.GetBall(Spy2,WhoGetBall)
            --安排队友捡漏
            return "Spy2Shoot"
        else
            while i<4 do
                local i=1
                IsoTriFormation(i)   --变换队形
                if Shoot2Goal==true then --如果能直接射门
                    WhoGetBall  = task.Shoot(WhoGetBall)--改进：这里也许可以安排一下其他两名成员做捡漏准备
                    if COppIsBallKick(OppGoalie)==true or CGetBallX()<302.5 then   --如果球被弹出，捡漏
                       return "FightForBall"
                   else
                       return "Start"
                   end
                else
                     if NoOthers(WhoGetBall,Spy1) then 
                      WhoGetBall  = task.PassBall(WhoGetBall,Spy1)
                      Spy1        = task.GetBall(Spy1,WhoGetBall)
                      --安排队友捡漏
                      return "Spy1Shoot"
                     else if NoOthers(WhoGetBall,Spy2) then 
                      WhoGetBall  = task.PassBall(WhoGetBall,Spy2)
                      Spy2        = task.GetBall(Spy2,WhoGetBall)
                      --安排队友捡漏
                      return "Spy2Shoot"
                     end
                else
                    i=i+1
                end
            end
        end
                
    end
}


["Spy1Shoot"]={
    switch = function()
        if CIsGetBall(Spy1)==true then--存疑，这个接到球的Spy1有无变成WhoGetBall?
        return "FrontTacticsPos1"
        else
            if WhichGetBall==0 then
                return "FightForBall"
            else if WhichGetBall==2 then
                return "Defence"

    end
}

["Spy2Shoot"]={
    switch = function()
        
        switch = function()
            if CIsGetBall(Spy2)==true then
              Spy2        = task.Shoot(Spy2)
              --队友配合站位 Spy1去配合
            return "FrontTacticsNo3"
            else
                if WhichGetBall==0 then
                    return "FightForBall"
                else if WhichGetBall==2 then
                    return "Defence"
    
        end
    end

}


["FrontTacticsNo2"]={

    switch = function()
        if COppIsBallKick(OppGoalie)==true or CGetBallX()<302.5 then   --如果球被弹出，捡漏
            Spy2        = task.ReceiveBall(Spy2) --捡漏队友离目标点最近，去接球
            return "Spy2Shoot"
        else
            return "Start"
        end
    end

}

["FrontTacticsNo3"]={

    switch = function()
        if COppIsBallKick(OppGoalie)==true or CGetBallX()<302.5 then   --如果球被弹出，捡漏
            Spy1        = task.ReceiveBall(Spy1) --捡漏队友离目标点最近，去接球
            return "Spy1Shoot"
        else
            return "Start"    --如果球进了，返回Start
        end
    end

}

--------------------------------------中场战术-------------------------------------------
["MidTacticsPos1"]={
    switch = function()
        if NoOthers(WhoGetBall,OppGoalie)==true then--无障碍，看守门员傻不傻，傻的话从中场就送对方回家
            if Shoot2Goal==true then     --给我滚去写函数
                WhoGetBall=task.Shoot(WhoGetBall)
                --队友跑到前场去接球
                --队友位置要安排好啊啊啊
                if COppIsBallKick(OppGoalie)==true or CGetBallX()<302.5 then   --如果球被弹出，捡漏
                    return "FightForBall"
                else
                    return "Start"
                end 
            else
                WhoGetBall=task.GotoPos(WhoGetBall,COurRole_x+100,COurRole_y,COurRoleDir(WhoGetBall))
                Spy1=task.GotoPos(Spy1,get_our_player_pos(GetOurBallerNum)+Polar2Vector(160,15),COurRole2RoleDir(Spy1,WhoGetBall))
                Spy2=task.GotoPos(Spy2,get_our_player_pos(GetOurBallerNum)+Polar2Vector(160,-15),COurRole2RoleDir(Spy2,WhoGetBall))
            end
        else
            if NoOthers(WhoGetBall,Spy1) == true then
                return "MidWGBAct1"
            else if NoOthers(WhoGetBall,Spy2) == true then  
                return "MidWGBAct2"
    
               else if NoOthers(WhoGetBall,Spy1) == false then
                    if NoOthersInLine(WhoGetBall,Spy1)==true then
                       return "MidTacticsPos2"
                
                    else 
                    if NoOthersInLine(WhoGetBall,Spy2)==true then
                        return "MidTacticsPos3"
                    else if NoOthersInLine(WhoGetBall,Spy2)==false then
                        return "MidTacticsPos4"
                    end
                end
            end
            if WhichGetBall == 2 then  --传球过程中被对方截胡，转为防御模式
                return "Defence"
            else if WhichGetBall ~= 1 and WhichGetBall ~= 2 then--球掉在地上啦，抢！
                return "MidTacticsPos5"
        
}



["MidWGBpos1"]={
    switch = function()
        WhoGetBall=task.GotoPos(WhoGetBall,COurRole_x+100,COurRole_y,COurRoleDir(WhoGetBall))
    end
}



["MidWGBAct1"]={
    switch = function()
        WhoGetBall=task.PassBall(WhoGetBall,Spy1)
    end

}



["MidWGBAct2"]={
    switch = function()
        WhoGetBall=task.PassBall(WhoGetBall,Spy2)
    end

}



["MidTacticsPos2"]={
    switch = function()
        Spy1=task.GotoPos(Spy1,get_our_player_pos(Spy1ID)+Polar2Vector(30,15),COurRole2RoleDir(Spy1,WhoGetBall))
        WhoGetBall=task.PassBall(WhoGetBall,Spy1)
        return "Spy1GetBall"

        
    end

}



["MidTacticsPos3"]={
    switch = function()
        Spy2=task.GotoPos(Spy2,get_our_player_pos(Spy2ID)+Polar2Vector(30,-15),COurRole2RoleDir(Spy2,WhoGetBall))
        WhoGetBall=task.PassBall(WhoGetBall,Spy1)
        return "Spy2GetBall"   
    end

}



["MidTacticsPos4"]={
    switch = function()
        Spy2=task.GotoPos(Spy2,get_our_player_pos(Spy2ID)+Polar2Vector(30,-15),COurRole2RoleDir(Spy2,WhoGetBall))    
    end

}



["Spy1GetBall"]={
    switch = function()
        Spy1=task.GetBall(Spy1,WhoGetBall)    
    end

}



["Spy2GetBall"]={
    switch = function()
    Spy2=task.GetBall(Spy2,WhoGetBall)  
    end

}



["MidTacticsPos5"]={
    switch = function()
        WhoGetBall=ReceiveBall(WhoGetBall)
        Spy1=ReceiveBall(Spy1)
        Spy2=ReceiveBall(Spy2)   
    end

}




["BackTacticsPos1"]={
    switch = function()
         
        Spy1=task.GotoPos(Spy1,-180,50,CRole2BallDir(Spy1))
        Spy2=task.GotoPos(Spy2,0,-50,CRole2BallDir(Spy2))
        if NoOthers(WhoGetBall,Spy1) then
            return "BackAct1"
        else if NoOthers(WhoGetBall,Spy2) then
            return "BackAct2"
        else 
            return "BackAct3"
             
        end
       
        if WhichGetBall == 2 then  --传球过程中被对方截胡，转为防御模式
            return "Defence"
        else if WhichGetBall ~= 1 and WhichGetBall ~= 2 then--球掉在地上啦，抢！
            return "BackAct4"
        
    end
 
}



["BackAct1"]={
    switch = function()
        WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
        Spy1        = task.ReceiveBall(Spy1),
        return "MidSpy1Shoot"
    end
 
}



["MidSpy1Shoot"]={
    switch = function()
        Spy1 = task.Shoot(Spy1)
        
    end
 
}



["BackAct2"]={
    switch = function()
        WhoGetBall  = task.PassBall(WhoGetBall,Spy2),
        Spy2        = task.ReceiveBall(Spy2),
        return "Spy2Shoot"    
    end
 
}



["BackAct4"]={
    switch = function()
        WhoGetBall=ReceiveBall(WhoGetBall)
        Spy1=ReceiveBall(Spy1)
        Spy2=ReceiveBall(Spy2)    
    end
 
}

name = "NormalPlayAttack"

}