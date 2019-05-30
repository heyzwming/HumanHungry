
------------------------------极坐标转直角坐标
function Polar2Vector(length,dir)
    -- math.cos()：传入弧度
    -- math.rad(): 角度制转弧度制
    return length * math.cos(math.rad(dir)),length * math.sin(math.rad(dir))
end

local GR = CIsGetBall("Receiver")
local GK = CIsGetBall("Kicker")
local GT = CIsGetBall("Tier") 
local cx = nil
local cy = nil
local cxr = COurRole_x("Receiver")
local cyr = COurRole_y("Receiver")
local cxk = COurRole_x("Kicker")
local cyk = COurRole_y("Kicker")
local cxt = COurRole_x("Tier")
local cyt = COurRole_y("Tier")

function RandPoint(role)

	if GR then
		cx = cxr
		cy = cyr
	elseif GK then
		cx = cxk
		cy = cyk
	elseif GT then
		cx = cxt
		cy = cyt
	else
		cx = 100
		cy = 100
	end	
	--and  isStopDir(role,i)
	--for i=1,180,1 do
	--	local x,y = Polar2Vector(50,i)
	--	if (cx + x < 210) and math.abs(cy + y < 210) then
	--		return (cx+ x ),(cy+ y )
	--	end
	--end
	 return (cx+100),(cx+100)
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
	local dir1 = math.deg(math.atan(COppNum_x(id)/COppNum_y(id)))
	return dir1
end





function  isStopDirtoGoal(dir)   
	local flag = 0     
	local opptable = CGetOppNums()                   --是否有阻挡
	for i, val in pairs(opptable) do 
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
	local flag = 0    
	local opptable = CGetOppNums()                      --是否有阻挡
	for i, val in pairs(opptable)do 
		local val1 = tonumber(val)
		if (COppNum2BallDir(val1)-dir)<3 then
			return 1
		end
	end
	if flag ==  1 then
		return 1
	else
		return 0
	end
end 

function  isStop(role1,role2)                           --是否有阻挡
	local dir1 = COurRole2RoleDir(role1,role2)
	local mindir = 180
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
	local dir = CRole2OppGoalDir(role) 
	for i, val in pairs(opptable)do 
		local val1 = tonumber(val)
		if COppNum2BallDir(val1) < dir then
			return false
		end
	end
	return true
end


local  R2Tdir = function()
	return COurRole2RoleDir("Tier","Receiver") 
end
--local dir =CRole2BallDir("Receiver")

local dir1 = function()
	return COurRole2RoleDir("Tier","Receiver")
end

-- local x,y = function()
-- 	return RandPoint("Receiver")
-- end



local x,y = RandPoint("Receiver")




gPlayTable.CreatePlay{
firstState = "Ready",

["Ready"] = {
	switch = function()
		--local x,y = RandPoint("Receiver")
		local dir1 = COurRole2RoleDir("Kicker","Receiver")
		if CBall2RoleDist("Receiver") < 30 then
			return "FlatPassR2T"
		end
	end,
    --Kicker   = task.GoRecePos("Kicker"),
    Kicker = task.GotoPos("Kicker",200,-100,dir1),
    Receiver = task.GetBall("Receiver","Receiver"),
	--Receiver = task.GotoPos("Receiver",200,100,CRole2BallDir("Kicker")),
	Tier = task.GotoPos("Tier",x,y,R2Tdir),
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

		if CIsBallKick("Receiver") then
			return "Rshoot"
		end

		if CIsBallKick("Kicker") then
			return "FlatPassR2T"
		end
	end,

	--Kicker = ("FlatPass2Receiver"),
	--Receiver = ReceiverTask("接球函数"),
	Tier = task.GotoPos("Tier",x1,y1,z1),
	Goalie = task.Goalie()
},


["FlatPassR2T"] = {
	switch = function()
		--local x,y,z=RandPoint("Kicker")
		-- if isStopToGoal("Tier") == 0 and CBall2RoleDist("Tier") < 10 then
		-- 	return "Tshoot"
		-- end
		if  CIsBallKick("Receiver") then
			return "Tshoot"
		end
		-- if CIsBallKick("Receiver") then
		-- 	return "FlatPassT2K"
		-- end
	end,

	Kicker = task.GotoPos("Kicker",200,-100,CRole2BallDir("Receiver")),
	Receiver = task.PassBall("Receiver","Tier"),
	Tier = task.GoRecePos("Tier"),
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
	Tier = task.Shoot("Tier"),
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
	Receiver = task.Shoot("Receiver"),
	Tier = task.RefDef("Tier"),
	Goalie = task.Goalie()

},
	

name = "Ref_MiddleKick"
}











































