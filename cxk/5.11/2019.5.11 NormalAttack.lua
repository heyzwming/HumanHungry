
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
    while i<12 do
        if COppIsGetBall(i) == true then
            result=2
        end
        
        if CIsGetBall(a[i]) == true then
            result = 1
        end
    end
    return result
end

WhoGetBall=function() --得知己方哪位控球
  
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


Spy1=function()  --间谍1号角色安排

    if WhoGetBall=="Kicker" then
        return "Reciever"
    end

    if WhoGetBall=="Reciever"then
        return "Tier"
    end

    if WhoGetBall=="Tier" then
        return "Kicker"
    end
end

Spy1ID=function()
    while a[i] do
        if a[i]==Spy1 then
            return i
        end
    end
end

     
Spy2=function() --间谍2号角色安排
    if WhoGetBall=="Kicker" then
        return "Tier"
    end

    if WhoGetBall=="Reciever"then
        return "Kicker"
    end

    if WhoGetBall=="Tier" then
        return "Reciever"
    end
end

Spy2ID=function()
    while a[i] do
        if a[i]==Spy2 then
            return i
        end
    end
end

function WhoCanReceiveBall(WhoGetBall) --得知可传给谁

    while i < 3 do    -- 除去守门员
        if NoOthers(WhoGetBall,a[i]) == ture then
            return a[i]
        end
    end
end

NoOthers=function(name1,name2)--name1到name2路径上有无障碍，以敌方坐标是否在name1与name2线段上，或敌方距此线段距离在20cm内，作为判断标准
    --附近位置如何判断，有点头疼
    local x1=COurRole_y(name1)
    local x2=COurRole_y(name2)
    local y1=COurRole_x(name1)
    local y2=COurRole_x(name2)
    while i<12 do
        if COppNumx(i)==(y2-y1)/(x2-x1)*COppNumy(i)+y1-((y2-y1)/(x2-x1))*x1 and (COurRole_x(name1)<COppNumx(i)<COurRole_x(name2) or COurRole_x(name1)>COppNumx(i)>COurRole_x(name2)) then
            return false
        else 
            return ture
        end
    end
end

NoOthersInLine==function(name1,name2)--name1到name2延长线上有无敌方
    
    local x1=COurRole_y(name1)
    local x2=COurRole_y(name2)
    local y1=COurRole_x(name1)
    local y2=COurRole_x(name2)
    while i<12 do
        if COppNumx(i)==(y2-y1)/(x2-x1)*COppNumy(i)+y1-((y2-y1)/(x2-x1))*x1 and ！(COurRole_x(name1)<COppNumx(i)<COurRole_x(name2) or COurRole_x(name1)>COppNumx(i)>COurRole_x(name2)) and COurRole2OppRoleDist(name2,a[i]) then
            return false
        else 
            return ture
        end
    end
end

--要写一个COurRole2OppRoleDist函数，在官方COurRole2RoleDist(role,role)函数里修改下就好啦

OppGoalie = function() --根据敌方位置，判断几号是守门员
    while i < 12 do
        if COppNumx(i) => 582.75 and -80<COppNum_y(i) < 80 then
            return i
        end
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
firstState = "Start",     --- //球已经发出来了
        
["Start"] = {
    switch = function ()		
        
        if CIsGetBall("Kicker") == false or CIsGetBall("Receiver") == false or CIsGetBall("Tier") == false then

            return "Defence" --没拿到球，跳出，转到防守战术   

            --[[ 建议 使用枚举类型 ]]
            --[[ TODO： 细化对 前中后场 的位置 ]]
           --reply：看x轴坐标划分场地，还不够吗？
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
        --先考虑是不是该传球了，傻逼
    if abs(COppNumDir(OppGoalie)) + abs(COurRoleDir(WhoGetBall)) == 180 then
    WhoGetBall  = task.GotoPos(WhoGetBall,565,86.18,CRole2OppGoalDir(WhoGetBall))
    Spy1        = task.GotoPos(Spy1,565,-86.18,CRole2OppGoalDir(WhoGetBall))
    WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
    Spy1        = task.Shoot(Spy1),    --站左右两个极端，吸引守门员到一端，传球给另一端的接应者进行射门
    --[[ 不一定要极端，极端可能会被断 ]]
    --reply:好滴。机器人可站在1/4圆内的任意点射门，在思考：这个点是定好的，按最优执行；还是随机站点？


    elseif NoOthers(WhoGetBall,WhoCanReceiveBall) == true then
        WhoGetBall = task.Shoot(WhoGetBall)
    elseif NoOthers(WhoGetBall,WhoCanReceiveBall) == false then
        挑射！！
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
            --判断在WGB到SPY路径上有几个敌方，敌方在SPY的前面还是后面？
            --若前后夹击，SPY需要绕圈移动
            问题：如何实现自动 绕圈找位？
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
        三人长距离传球，
        WGB在后场，
        Spy1在后场前端，Spy2在中场（具体坐标随便定个）
        Spy1=
        若Spy2与WGB之间无阻碍，WGB直接射给S2
        若S2与WGB有阻碍，S1与WGB无阻碍，射给S1
        若给S2与S1均有阻碍，S1转换位置去接球，S1接到球后，若跟S2无阻碍，直接射，若有阻碍三者调整位置
        （考虑传给S1后，WGB何去何从）
        
}
name = "NormalPlayAttack"
}