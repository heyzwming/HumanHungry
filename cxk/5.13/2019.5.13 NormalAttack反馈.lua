-- (ง •_•)ง
-- 1、获得敌我双方 拿球球员编号(见下面的注释)
-- 2、遍历己方球员的时候用全局的Table类型变量来遍历
--Table暂时还没看，还没做修改（主要是不大会）

-- 5.13
-- 1、我不确定在状态机的 role = task 部分 role能用变量代替哈~ 因为状态机中的Kicker = ...中的Kicker是变量，是会被状态机解析脚本解析并调用，但是如果用Spy1 = “Kicker” 那就变成了字符串了...
-- 2、用到官方数学库的时候要加上 math.   例如 math.sqrt()  math.pow()
-- 3、lua中没有 自增符号 ++ 
-- 4、195行 的 COurRole2OppRoleDist(role1,ID2) = function() 函数的语法写错了 应该改成COurRole2OppRoleDist = function(role1,ID2)
-- 5、在一个状态机下一个角色只能做一件事情吧..

--[[ 极坐标转直角坐标 ]]
function Polar2Vector(length,dir)
    -- math.cos()：传入弧度
    -- math.rad(): 角度制转弧度制
    return length * math.cos(math.rad(dir)),length * math.sin(math.rad(dir))
end
-- 注意函数返回两个值，需要用两个值来接受返回的值   例如：  x,y = function Polar2Vector(length,dir)


--[[ 获得球员朝向球的方向 ]]
Kicker2BallDir = function()
	return CRole2BallDir("Kicker")
end

Receiver2BallDir = function()
	return CRole2BallDir("Receiver")
end

Tier2BallDir = function()
	return CRole2BallDir("Tier")
end

OppPlayer2BallDir1 = function()
	return COppNum2BallDir(1)
end

OppPlayer2BallDir2 = function()
	return COppNum2BallDir(2)
end

OppPlayer2BallDir3 = function()
	return COppNum2BallDir(3)
end

OppPlayer2BallDir4 = function()
	return COppNum2BallDir(4)
end

--[[ 把每个球员放入数组中 ]]

Player[4]={"Kicker","Receiver","Tier","Goalie"} 

i=0 -- 定义全局 循环下标变量 i

WhichGetBall = function()   --//得知哪方控球       --   注释的符号是 两个减号哦 “-- ...”  多行注释： “--[[ ... ]]”
    while i < 12 do
        if COppIsGetBall(i) == true then
            result=2
        end
        
        if CIsGetBall(a[i]) == true then
            result = 1
        end
    end
    return result
end

WhoGetBall = function() --得知己方哪位控球
  
    if CIsGetBall(a[0]) == true then         
      return "Kicker"
    end

    if CIsGetBall(a[1]) == true then
      return "Receiver"
    end 

    if CIsGetBall(a[2]) == true then
      return "Tier"
    end
end
--[[
上面两个函数可以参照
“获得拿球球员编号”

function getOppNum()
    local oppTable = CGetOppNums()      --我方球员编号总是知道的吧..或者进行for遍历..或者写个全局table变量 OurPlayerNumber = {1,2,3,4}
    -- pairs 迭代 table元素的迭代器 
	for i,val in pairs(oppTable) do -- 遍历 表 oppTable里的所有 key 和 value    
		local num = tonumber(val) -- 把 value 字符串转为数字
        if COppIsGetBall(num-1) then    -- CIsGetBall()
			break
		end		
	end
	return num		-- 返回 拿球球员编号 num
end
]]

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

Spy1ID = function()
    while i<3 do       
        if a[i] == Spy1 then
            return i+1
        end
        i = i + 1
        -- lua中没有 ++ 的操作符号
    end
end

     
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

Spy2ID = function()
    while i<3 do
        if a[i] == Spy2 then
            return i
        end
        i = i + 1
    end
end

function WhoCanReceiveBall(WhoGetBall) --得知可传给谁

    --[[ ****************************这个地方可以用全局的Table类型变量来进行遍历，不要用纯数字，全局变量定义在文件开头，如果碰到己方车号变化的情况可以很快的修改 ]]
    while i < 3 do    -- 除去守门员
        if NoOthers(WhoGetBall,a[i]) == ture then
            return a[i]
        end
    end
end

NoOthers = function(name1,name2)--name1到name2路径上有无障碍，以敌方坐标是否在name1与name2线段上，或敌方距此线段距离在20cm内，作为判断标准
   
    local x1 = COurRole_y(name1)
    local x2 = COurRole_y(name2)
    local y1 = COurRole_x(name1)
    local y2 = COurRole_x(name2)
    local A = (y2-y1)/(x2-x1)
    local B = -1
    local C = y1-((y2-y1)/(x2-x1))*x1
    while i < 12 do
        if COppNum_x(i) == A*COppNum_y(i)+y1-C and (COurRole_x(name1)<COppNum_x(i)<COurRole_x(name2) or COurRole_x(name1)>COppNum_x(i)>COurRole_x(name2)) and abs((A*COppNum_y(i)+B*COppNum_x(i)+C)/sqr(pow(A,2)+pow(B,2)))<20 then
            return false
        else 
            return true
        end
    end
end

NoOthersInLine = function(name1,name2)--name1到name2延长线上有无敌方
    
    local x1 = COurRole_y(name1)
    local x2 = COurRole_y(name2)
    local y1 = COurRole_x(name1)
    local y2 = COurRole_x(name2)
    while i < 12 do
        if COppNum_x(i)==(y2-y1)/(x2-x1)*COppNum_y(i)+y1-((y2-y1)/(x2-x1))*x1 and ~(COurRole_x(name1)<COppNum_x(i)<COurRole_x(name2) or COurRole_x(name1)>COppNum_x(i)>COurRole_x(name2)) or COurRole2OppRoleDist(name2,i)<20 then
            return false
        else 
            return true
        end
    end
end


COurRole2OppRoleDist = function(role1,ID2)    --本队队员到敌方队员的距离
    local x1 = COurRole_y(role1)
    local y1 = COurRole_x(role1)
    local x2 = COppNum_y(ID2)
    local y2 = COppNum_x(ID2)
    local d = math.sqrt(math.pow(x1-x2,2)+math.pow(y1-y2,2))
    return d
end

OppGoalie = function() --根据敌方位置，判断几号是守门员
    while i < 12 do
        if COppNum_x(i) >= 582.75 and -80<COppNum_y(i) < 80 then
            --！！ 这个判断条件有问题 COppNum_x(i) >= 582.75 ？？ 整场长也就600cm  这个数值应该再考虑一下 
            return i
        end
        i = i + 1
    end
end

BallPosition = function()--根据球的位置，确定前场中场后场
    if COurRole_x("Kicker") > 180 then
        return 1
    elseif COurRole_x("Kicker") > -180 then
        return 2
    else
        return 3
    end
end


gPlayTable.CreatePlay{
firstState = "Start",     -- 球已经发出来了
        
["Start"] = {
    switch = function ()		
        
        if CIsGetBall("Kicker") == false or CIsGetBall("Receiver") == false or CIsGetBall("Tier") == false then

            return "Defence" --没拿到球，跳出，转到防守战术   

            --[[ 建议 使用枚举类型 ]]
            --[[ TODO： 细化对 前中后场 的位置 ]]
    
        elseif BallPosition == 1 then --前场
            return "FrontCourt"

        elseif BallPosition == 2 then --中场
            return "MidCourt"

        elseif BallPosition == 3 then --后场
            return "BackCourt"
        end
    end,
},

["FrontCourt"] = {
    switch = function()
        
    if abs(COppNumDir(OppGoalie)) + abs(COurRoleDir(WhoGetBall)) == 180 then --如果持球者被守门员盯死，则传球搭配战术
    WhoGetBall  = task.GotoPos(WhoGetBall,565,86.18,CRole2OppGoalDir(WhoGetBall))
    Spy1        = task.GotoPos(Spy1,565,-86.18,CRole2OppGoalDir(WhoGetBall))
    Spy2        = task.GotoPos(Spy2,525,0,COppNumDir(OppGoalie)-180)
    WhoGetBall  = task.PassBall(WhoGetBall,Spy1)
    Spy1        = task.GetBall(Spy1,WhoGetBall)--站左右两个极端，吸引守门员到一端，传球给另一端的接应者进行射门
    Spy1        = task.Shoot(Spy1)
    --SPY2最好此时就开启吸球状态
    --★★★问题：不会写怎么控制指定一辆车 开启吸球状态
        if COppIsBallKick(OppGoalie)==true or CGetBallX()<302.5 then   --如果球被弹出，捡漏
           Spy2        = task.ReceiveBall(Spy2)
           Spy2        = task.Shoot(Spy2)
        else
            return "finish"
        end
    
    --★改良：机器人可站在1/4圆内的任意点射门，在思考：这个点是定好的，按最优执行；还是随机站点？
    --问题：如何实现自动 绕圈找位？
            --解决办法1：搞一个分段路径，与1/4圆的圆心保持80cm距离行走，到达一个点后，与球门保持80cm距离行走，再到达一个点后，与1/4圆的圆心保持80cm距离行走。实现禁区线上行走
            --根据守门员站位和朝向，辨别要在左中右哪个区里站着最好，然后站在那个区域里的随机一坐标点中
            --烦死了，数学问题吔屎
    else
        WhoGetBall        = task.Shoot(WhoGetBall),  --如果持球者没被盯死，射射射

  end
         if WhichGetBall == 2 then  --传球过程中被对方截胡，转为防御模式
                return "Defence"
            else if WhichGetBall ~= 1 and WhichGetBall ~= 2 then--球掉在地上啦，抢！
                WhoGetBall=ReceiveBall(WhoGetBall)
                Spy1=ReceiveBall(Spy1)
                Spy2=ReceiveBall(Spy2)
    end

}

-- 中场战术
["MidCourt"] = {
    switch = function()
        
       --持球者在中场啦，SPY1、SPY2站到距持球者半径160cm，角度15°的左右两边。 
        Spy1=GotoPos(Spy1,get_our_player_pos(Spy1ID)+Polar2Vector(160,15),COurRole2RoleDir(Spy1,WhoGetBall))
        Spy2=GotoPos(Spy2,get_our_player_pos(Spy2ID)+Polar2Vector(160,-15),COurRole2RoleDir(Spy2,WhoGetBall))
        if NoOthers(WhoGetBall,OppGoalie)==true then--无障碍，看守门员傻不傻，傻的话从中场就送对方回家
            if 守门员没站在拿球者朝向的直线上 then     --给我滚去写函数
                WhoGetBall=task.Shoot(WhoGetBall)
            else
            WhoGetBall=task.GotoPos(WhoGetBall,COurRole_x+100,COurRole_y,COurRoleDir(WhoGetBall))
            end
            --★改良：这里可以有个检测持球行驶路程和持球行驶时间的函数，如果对手是白痴给我们让路，我们也不能犯规哦
        else --有障碍，考虑传球
           if NoOthers(WhoGetBall,Spy1) == true then
            WhoGetBall=task.PassBall(WhoGetBall,Spy1)
    

           else if NoOthers(WhoGetBall,Spy2) == true then  
            WhoGetBall=task.PassBall(WhoGetBall,Spy2)

           else if NoOthers(WhoGetBall,Spy1) == false then
                if NoOthersInLine(WhoGetBall,Spy1)==true then
                   Spy1=task.GotoPos(Spy1,get_our_player_pos(Spy1ID)+Polar2Vector(30,15),COurRole2RoleDir(Spy1,WhoGetBall))
                   WhoGetBall=task.PassBall(WhoGetBall,Spy1)
                   Spy1=task.GetBall(Spy1,WhoGetBall)
            

                else 
                if NoOthersInLine(WhoGetBall,Spy2)==true then
                    Spy2=task.GotoPos(Spy2,get_our_player_pos(Spy2ID)+Polar2Vector(30,-15),COurRole2RoleDir(Spy2,WhoGetBall))
                    WhoGetBall=task.PassBall(WhoGetBall,Spy1)
                    Spy2=task.GetBall(Spy2,WhoGetBall)
                else if NoOthersInLine(WhoGetBall,Spy2)==false then
                    Spy2=task.GotoPos(Spy2,get_our_player_pos(Spy2ID)+Polar2Vector(30,-15),COurRole2RoleDir(Spy2,WhoGetBall))
                end
            end
        end
    

    
            if WhichGetBall == 2 then  --传球过程中被对方截胡，转为防御模式
                return "Defence"
            else if WhichGetBall~==1 and WhichGetBall~==2 then--球掉在地上啦，抢！
                WhoGetBall=ReceiveBall(WhoGetBall)
                Spy1=ReceiveBall(Spy1)
                Spy2=ReceiveBall(Spy2)
            --★★★问题：ReceiveBall(role_name_)这个函数的功能是到达接球点就完事儿了，还是到接球点去吸球呀？？

            --★改良：传球是完成了呢，前进完成了吗？所有只传球不往前场突进的行为都是傻逼行为呢（手动微笑）
}

-- 后场战术
["BackCourt"] = {
    switch = function()
        --三人长距离传球，
        
        Spy1=task.GotoPos(Spy1,-180,50,CRole2BallDir(Spy1))
        Spy2=task.GotoPos(Spy2,0,-50,CRole2BallDir(Spy2))
        if NoOthers(WhoGetBall,Spy1) then
            WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
            Spy1        = task.ReceiveBall(Spy1),
            Spy1 = task.Shoot(Spy1)
        else if NoOthers(WhoGetBall,Spy2) then
            WhoGetBall  = task.PassBall(WhoGetBall,Spy2),
            Spy2        = task.ReceiveBall(Spy2),
            Spy2 = task.Shoot(Spy2)
        else 
            --调整队形！！！
            --还得写一个灵活可变的队形，站位怎么定，在移动中找到最佳点，然后停住。还是直接定个位置？
            --怎么找最佳点呢，判别条件又是什么呢。Fxxk
            --首先他俩之间得没人，这个NoOthers可以实现。他俩线段路径附近不允许有人，要是有人，请接球者麻溜地滚到前面去，确保没人能抢老娘的球，再让传球者射
            --要是哪哪儿都有一个傻逼挡着怎么办？接球者往后退，传球者挑射，越过傻逼传球。这里得保证落球点离接球者更近，而不是离傻逼更近，这意味着傻逼得站在传球者与接球者线段前面部分
             
        end
       
        if WhichGetBall == 2 then  --传球过程中被对方截胡，转为防御模式
            return "Defence"
        else if WhichGetBall~==1 and WhichGetBall~==2 then--球掉在地上啦，抢！
            WhoGetBall=ReceiveBall(WhoGetBall)
            Spy1=ReceiveBall(Spy1)
            Spy2=ReceiveBall(Spy2)
        --说好的打配合战，写到这里只实现了WGB传球给两个SPY。那两个SPY怎么配合呢，弟弟，你完了。你写不完了。
        --要配合前进呢，亲亲，再忽略这点可以把脑子捐给有需要的人哦
        -- 傻逼（¯﹃¯）
    end
}
name = "NormalPlayAttack"
}