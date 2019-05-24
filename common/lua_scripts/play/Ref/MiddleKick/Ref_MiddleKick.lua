function Polar2Vector(length,dir)
    -- math.cos()：传入弧度
    -- math.rad(): 角度制转弧度制
    return length * math.cos(math.rad(dir)),length * math.sin(math.rad(dir))
end



function RandPoint(role)
	local cx
	local cy
	if CIsGetBall("Receiver")~=nil then
		cx = COurRole_x("Receiver")
		cy = COurRole_y("Receiver")
	elseif CIsGetBall("Kicker")~=nil then
		 cx = COurRole_x("Kicker")
		 cy = COurRole_y("Kicker")
	elseif CIsGetBall("Tier")~=nil then
		 cx = COurRole_x("Tier")
		 cy = COurRole_y("Tier")
	end
		
	for i=1,360,1 do
		local x,y = Polar2Vector(100,i)
		if (cx + x < 210) and abs((cy+ y < 210)) < 200 and  isStopDir(role,i) then
			return (cx+ x < 210),(cy+ y < 210),(CRole2BallDir(role))
		end
	end
	 return (cx+100),(cx+100),COurRoleDir(role)
end



function RandPointShoot(role)
	for i=-105,-180,-1 do
		local x,y = Polar2Vector(100,i)
		if  isStopDirtoGoal(i) == 0 then
			return  x+300,0+y,(CRole2BallDir(role))
		end
	end
	for i=105,180,1 do
		local x,y = Polar2Vector(100,i)
		if  isStopDirtoGoal(i) == 0 then
			return  x+300,0+y,(CRole2BallDir(role))
		end
	end
end


function jiaoduzhuanhuan(id)
	dir = math.deg(math.atan(COppNum_x(id)/COppNum_y(id)))
	return dir
end


function getBallNum()                                  --拿球人员
    local oppTable = CGetOppNums()      
	for i,val in pairs(ourtable) do    
        if COppIsGetBall(val) then    
			break
		end		
	end
	return val		
end

function  isStopDirtoGoal(dir)   
	local flag = 0                        --是否有阻挡
	for i, val in pairs(opptable)do 
		local val1 = tonumber(val)
		if (jiaoduzhuanhuan(val1)-dir)<3 then
		     flag = 1
		end
	end
	if flag ==  1 then
		return 1
	else
		return 0
	end
end 


function  isStopDir(role1,dir)   
	local flag = 0                        --是否有阻挡
	for i, val in pairs(opptable)do 
		local val1 = tonumber(val)
		if (COppNum2BallDir(val1)-dir)<3 then
		     flag = 1
		end
	end
	if flag ==  1 then
		return 1
	else
		return 0
	end
end 

function  isStop(role1,role2)                           --是否有阻挡
	dir1 = COurRole2RoleDir(role1,role2)
	mindir = 180
	for i, val in pairs(opptable)do 
		local val1 = tonumber(val)
		if COppNum2BallDir(val1)<mindir then
		mindir = COppNum2BallDir(val1)
		end
	end
	if mindir < dir1 then
		return 1
	else
		return 0
	end
end 


function isStopToGoal(role)                                 ---射门阻挡
	dir = CRole2OppGoalDir(role) 
	for i, val in pairs(opptable)do 
		local val1 = tonumber(val)
		if COppNum2BallDir(val1) < dir then
			return false
		end
	end
	return true
end






 gPlayTable.CreatePlay{
firstState = "Ready",
	
["Ready"] = {
	switch = function()
		local x,y,z=RandPoint("Kicker")
		if CIsBallKick("Receiver") then
			return "FlatPassK2R"
		end
	end,
	
	Receiver = task.GotoPos("Receiver",x,y,z),
	
    Kicker = task.GetBall("Kicker","Kicker"),
    
	--Kicker = task.GotoPos("Kicker",100,100,CRole2BallDir("Kicker")),
	--Receiver = task.GotoPos("Receiver",200,100,CRole2BallDir("Kicker")),
	Tier = task.GotoPos("Tier",-100,100,CRole2BallDir("Kicker")),
	Goalie = task.Goalie()
},

-- ["KickerGetBall"] = {
-- 	switch = function()
-- 		local x,y,z=RandPoint("Kicker")
-- 		local x1,y1,z1=RandPointShoot("Tier")
	
-- 		if CIsGetBall("Kicker") and isStop("Kicker","Receiver")  then
-- 			return "FlatPassK2R"
-- 		end
-- 	end,

-- 		Kicker = task.GetBall("Kicker","Kicker"),
-- 		Receiver   = task.GoRecePos("Receiver"),
-- 		Tier = task.GotoPos("Tier",x1,y1,z1),
-- 		Goalie = task.Goalie()
-- },

["FlatPassK2R"] = {
	switch = function()
		local x1,y1,z1=RandPointShoot("Tier")
		if isStopToGoal("Receiver") == 0 and CBall2RoleDist("Receiver") < 10 then
			return "Rshoot"
		end
		if CIsBallKick("Kicker") then
			return "FlatPassR2T"
		end
	end,

	Kicker = ("FlatPass2Receiver"),
	--Receiver = ReceiverTask("接球函数"),
	Tier = task.GotoPos("Tier",x1,y1,z1),
	Goalie = task.Goalie()
},


["FlatPassR2T"] = {
	switch = function()
		local x,y,z=RandPoint("Kicker")
		if isStopToGoal("Tier") == 0 and CBall2RoleDist("Tier") < 10 then
			return "Tshoot"
		end
		if CIsBallKick("Receiver") then
			return "FlatPassT2K"
		end
	end,

	Kicker = task.GotoPos("Kicker",x,y,z),
	--Receiver = ReceiverTask("FlatPass2Receiver"),
	--Tier = TierTask("接球函数"),
	Goalie = task.Goalie()
},

["FlatPassT2K"] = {
	switch = function()
		local x1,y1,z1 =RandPointShoot("Receiver")
		if isStopToGoal("Receiver") == 0 and CBall2RoleDist("Receiver") < 10 then
			return "Kshoot"
		end
		if CIsBallKick("Tier") then
			return "KickerGetBall"
		end
	end,
	--Kicker = KickerTask("接球函数"),
	Receiver = task.GotoPos("Receiver",x1,y1,z1 ),
	--Tier = TierTask("FlatPass2Receiver"),
	Goalie = task.Goalie()

},




["Tshoot"]  = {
	switch = function()
		if CIsBallKick("Tier") then
			return "finish"
		end
	end,
	Kicker = task.RefDef("Kicker"),
	Receiver = task.RefDef("Receiver"),
	--Tier = TierTask("射门函数"),
	Goalie = task.Goalie()

},
["Kshoot"]  = {
	switch = function()
		if CIsBallKick("Kicker") then
			return "finish"
		end
	end,
	Kicker =  task.Shoot("Kicker"),
	Receiver = task.RefDef("Receiver"),
	Tier = task.RefDef("Tier"),
	Goalie = task.Goalie()

},
["Rshoot"]  = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "finish"
		end
	end,
	Kicker = task.RefDef("Kicker"),
	--Receiver = ReceiverTask("射门函数"),
	Tier = task.RefDef("Tier"),
	Goalie = task.Goalie()

},
	

name = "Ref_MiddleKick"
}











































