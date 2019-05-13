 
-- 1、获得敌我双方 拿球球员编号(见下面的注释)
-- 2、遍历己方球员的时候用全局的Table类型变量来遍历

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

Player[4]={"Kicker","Reciever","Tier","Goalie"} 

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
      return "Reciever"
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
        return "Reciever"
    end

    if WhoGetBall == "Reciever"then
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
        i++
    end
end

     
Spy2 = function() --间谍2号角色安排
    if WhoGetBall == "Kicker" then
        return "Tier"
    end

    if WhoGetBall == "Reciever"then
        return "Kicker"
    end

    if WhoGetBall == "Tier" then
        return "Reciever"
    end
end

Spy2ID = function()
    while i<3 do
        if a[i] == Spy2 then
            return i
        end
        i++
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
    while i<12 do
        if COppNum_x(i) == A*COppNum_y(i)+y1-C and (COurRole_x(name1)<COppNum_x(i)<COurRole_x(name2) or COurRole_x(name1)>COppNum_x(i)>COurRole_x(name2)) and abs((A*COppNum_y(i)+B*COppNum_x(i)+C)/sqr(pow(A,2)+pow(B,2)))<20 then
            return false
        else 
            return true
        endy
    end
end

NoOthersInLine = function(name1,name2)--name1到name2延长线上有无敌方
    
    local x1 = COurRole_y(name1)
    local x2 = COurRole_y(name2)
    local y1 = COurRole_x(name1)
    local y2 = COurRole_x(name2)
    while i < 12 do
        if COppNum_x(i)==(y2-y1)/(x2-x1)*COppNum_y(i)+y1-((y2-y1)/(x2-x1))*x1 and ~(COurRole_x(name1)<COppNum_x(i)<COurRole_x(name2) or COurRole_x(name1)>COppNum_x(i)>COurRole_x(name2)) and COurRole2OppRoleDist(name2,a[i])<20 then
            return false
        else 
            return true
        end
    end
end


COurRole2OppRoleDist(role1,role2) = function()--本队队员到敌方队员的距离
    local x1 = COurRole_y(role1)
    local y1 = COurRole_x(role1)
    local x2 = COppNum_y(role2)
    local y2 = COppNum_x(role2)
    d=sqr(pow(x1-x2,2)+pow(y1-y2,2))
    return d


OppGoalie = function() --根据敌方位置，判断几号是守门员
    while i < 12 do
        if COppNum_x(i) >= 582.75 and -80<COppNum_y(i) < 80 then
            
            return i
        end
        i++
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
           --reply：看x轴坐标划分场地，还不够吗？
           -- reply's reply: 光是三块 前、中、后 还不够的哦~  不过可以先简单的写好前中后，之后再细分
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
        
    if abs(COppNumDir(OppGoalie)) + abs(COurRoleDir(WhoGetBall)) == 180 then
    WhoGetBall  = task.GotoPos(WhoGetBall,565,86.18,CRole2OppGoalDir(WhoGetBall))
    Spy1        = task.GotoPos(Spy1,565,-86.18,CRole2OppGoalDir(WhoGetBall))
    Spy2        = task.GotoPos(Spy2,525,0,COppNumDir(OppGoalie)-180)
    WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
    Spy1        = task.GetBall(Spy1,WhoGetBall),--站左右两个极端，吸引守门员到一端，传球给另一端的接应者进行射门
    Spy1        = task.Shoot(Spy1),
    SPY2最好此时就开启吸球状态
        if COppIsBallKick(OppGoalie)==true or CGetBallX()<3025 then   --捡漏
           Spy2        = task.ReceiveBall(Spy2),
           Spy2        = task.Shoot(Spy2),
        else
            return "finish"
        end
    
    --reply:好滴。机器人可站在1/4圆内的任意点射门，在思考：这个点是定好的，按最优执行；还是随机站点？
    -- reply's reply : 可以先定好，之后有时间再考虑如何找到最优的点
    else
        WhoGetBall        = task.Shoot(WhoGetBall),

  end

end

}

-- 中场战术
["MidCourt"] = {
    switch = function()
        
        --WhoGetBall根据WGB到Spy路线上敌方的位置，决定平射/挑射给谁
        --（此处还应考虑挑射没接到，得写GoRecePos）
        Spy1=GotoPos(Spy1,get_our_player_pos(Spy1ID)+Polar2Vector(160,15),COurRole2RoleDir(Spy1,WhoGetBall))
        Spy1=GotoPos(Spy2,get_our_player_pos(Spy2ID)+Polar2Vector(160,-15),COurRole2RoleDir(Spy2,WhoGetBall))
       
       --重要！！先前要考虑WGB是否到了不得不传球的地步。
        if NoOthers(WhoGetBall,Spy1) == true then
            WhoGetBall=task.PassBall(WhoGetBall,Spy1)
        end

        if NoOthers(WhoGetBall,Spy2) == true then  
            WhoGetBall=task.PassBall(WhoGetBall,Spy2)
        end

        if NoOthers(WhoGetBall,Spy1) == false then
            if NoOthersInLine(WhoGetBall,Spy1)==true then
            绕到另一个点去
           
            --若前后夹击，SPY需要绕圈移动
            --问题：如何实现自动 绕圈找位？
            --解决办法1：搞一个分段路径，与1/4圆的圆心保持80cm距离行走，到达一个点后，与球门保持80cm距离行走，再到达一个点后，与1/4圆的圆心保持80cm距离行走。实现禁区线上行走
            --根据守门员站位和朝向，辨别要在左中右哪个区里站着最好，然后站在那个区域里的随机一坐标点中
            --烦死了，数学问题吔屎

            if NoOthersInLine(WhoGetBall,Spy1)==false then
                if NoOthersInLine(WhoGetBall,Spy2)==true
                SPY2绕到另一个点去接球
                if NoOthersInLine(WhoGetBall,Spy2)==false
                把球射向前场
            


        --平射优先。若WGB与Spy之间有很多障碍，spy可 以WGB为顶点，1.6m为半径，向顶点方向顺时针或逆时针移动
       -- 给哪个Spy
        --传球完毕后，WGB和SPY身份互换，SPY再跑上前构成等腰三角形（考虑这个三角形的朝向）
        --以此实现曲线突进
        
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
       
        若给S2与S1均有阻碍，S1转换位置去接球，S1接到球后，若跟S2无阻碍，直接射，若有阻碍三者调整位置
        （考虑传给S1后，WGB何去何从）
    end
}
name = "NormalPlayAttack"
}




