
-- 1、变量的命名规范
-- 2、注释
-- 3、跳过开球部分
-- 4、敌我站位的分析和战术的选择
-- 5、尽可能使用 local声明 本地变量
-- 6、先建立框架，思考战术，再编程=

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

i=1 -- 定义全局 循环下标变量 i

WhichGetBall = function()   --//得知哪方控球       --   注释的符号是 两个减号哦 “-- ...”  多行注释： “--[[ ... ]]”
    while i<5 do
        if COppIsGetBall(i) == true then
            result=2
        end
        
        if CIsGetBall(a[i-1]) == true then
            result = 1
        end
    end
    return result
end


--[[ 
    
????  switch-case 语句是这样子写哒??????

    switch(变量){
        case 1: ...;
                break;
        case 2: ...;
                break;
        default:...;
                break;

    switch (t) {
        case LUA_TSTRING: /* strings */
            printf("`%s'", lua_tostring(L, i));
            break;
        case LUA_TBOOLEAN: /* booleans */
            printf(lua_toboolean(L, i) ? "true" : "false");
            break;
        case LUA_TNUMBER: /* numbers */
            printf("%g", lua_tonumber(L, i));
            break;
        default: /* other values */
            printf("%s", lua_typename(L, t));
            break;
}
    }
case 中可以是字符、字符串、数字等
case 后的值不能重复  建议改成if语句
]]
WhoGetBall=function()
  switch(){
    case CIsGetBall(a[0]) == true:          
    return "Kicker";
    break;

    case CIsGetBall(a[1]) == true:
    return "Reciever";
    break;

    case CIsGetBall(a[2]) == true:
    return "Tier";
    break;
  }
end


Spy1=function()
    if 


WhoCanReceiveBall = function() -- 得知该传给谁 错错错
    while i < 3 do    -- 除去守门员
        if CIfavailable(Whogetball,a[i]) == ture then
            return a[i]
        end
    end
end

CanShoot = function()     -- 可以平射 错错错
    if CIfavailable(Whogetball,Whocanreceiveball) == ture then
        return 1
    end
end
    

CanChip = function()      -- 可以挑射 错错错
    if CIfavailable(Whogetball,Whocanreceiveball) == nil then
        return 1
    end
end

OppGoalie = function() 
    while i < 5 do
        if COppNumx(i) => 582.75 and -80<COppNum_y(i) < 80 then
            return i
        end
    end
end

BallPosition = function()
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

            --[[  这个地方还是没有修改鸭??? ]]

            return "finish" --没拿到球，跳出，转到防守战术   

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

--[[["KickOff"] = {
    switch = function()
        if CGameOn() then
            return "finish"
        elseif CIsGetBall("Kicker") and CBall2PointDist(303,0)>160 and CHoldingtime(Kicker)>15 and CHoldingdist(Kicker)>100 and CIfavailable(Kicker)==ture then	-- 如果kicker拿到球 则 转到 传球状态
            return "passball" -- 需要写holdingtime和holdingdistance和CIfavailable的函数
        end
    end,
    
    Kicker = task.GetBall("Kicker","Kicker"),	-- 朝向球门拿球
    Receiver = task.GotoPos("Receiver",-30,120,Receiver2BallDir),
    Tier = task.GotoPos("Tier",-30,-120,Tier2BallDir),
    Goalie = task.Goalie()  -- //其他3名队员位置不改变
},

["Passball"]={
    switch = function()
       while i<5 do
if COurRole2RoleDist(a[i],opp players)<32 and CanChip(i) == 0 then
                Chip(Whogetball,0000)
            else if CanChip(i)
}]]

-- 前场战术
["FrontCourt"] = {
    switch = function()
    if abs(COppNumDir(OppGoalie)) + abs(COurRoleDir(WhoGetBall)) == 180 then
    WhoGetBall  = task.GotoPos(WhoGetBall,565,86.18,CRole2OppGoalDir(WhoGetBall))
    Spy1        = task.GotoPos(Spy1,565,-86.18,CRole2OppGoalDir(WhoGetBall))
    WhoGetBall  = task.PassBall(WhoGetBall,Spy1),
    Spy1        = task.Shoot(Spy1),    --站左右两个极端，吸引守门员到一端，传球给另一端的接应者进行射门
    --[[ 不一定要极端，极端可能会被断 ]]


    elseif NoOthers == 1 then
        WhoGetBall = task.Shoot(WhoGetBall)
    elseif NoOthers == 0 then
        挑射！！



}

-- 中场战术
["MidCourt"] = {
    switch = function()
        --问题：让Spy1和Spy2站到WhoGetBall左右前方，构成一个腰长1.6m的等腰三角形，顶角角度30°-60°（需要一个函数，能在顶点变化的情况下，
        --保持另两个点与顶点的相对距离）
        --WhoGetBall根据WGB到Spy路线上敌方的位置，决定平射/挑射给谁（此处还应考虑挑射没接到，得写GoRecePos）
        if NoOthers(WhoGetBall,Spy1) == true then
            WhoGetBall=task.PassBall(WhoGetBall,Spy1)
        end

        if NoOthers(WhoGetBall,Spy2) == true then  --函数没写！！
            WhoGetBall=task.PassBall(WhoGetBall,Spy2)
        end

        if NoOthers(WhoGetBall,Spy1) == false then
            --判断在WGB到SPY路径上有几个地方，敌方在SPY的前面还是后面？
            --若前后夹击，SPY需要绕圈移动


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
        若Spy2与WGB之间无阻碍，WGB直接射给S2
        若S2与WGB有阻碍，S1与WGB无阻碍，射给S1
        若给S2与S1均有阻碍，S1转换位置去接球，S1接到球后，若跟S2无阻碍，直接射，若有阻碍三者调整位置
        （考虑传给S1后，WGB何去何从）
        
}