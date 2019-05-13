


opptable = CGetOppNums();
function getnum(role)    --敌方球员dist<50个数
	num = 0;
	for i, val in pairs(opptable)do 
		local val1 = tonumber(val)
		if Opp2ourDist(role,val1) <50
		num++;
	end
return num
end


function isBlocked(role)   --是否被敌方防守
	if getnum(role)>0 then
		return 1
	else
		return 0
	end
end


function Opp2ourDist(role1,role2)   --距离函数
	local role1_x = COurRole_x(role1)
	local role1_y = COurRole_y(role1)
	local role2_x = COppNum_x(role2)
	local role2_y = COppNum_y(role2)
	local dist = sqrt((role1_x-role2_x)*(role1_x-role2_x)+(role1_y-role2_y)*(role1_y-role2_y))
	return  dist
end



ourtable = {"Kicker","Tier","Receiver","Goalie"}
function MinOurDist(role)                             --最近传球人员
	for i, val in pairs(table) do 
		mindist = 9999， 
		if COurRole2RoleDist(role,val) < mindist and (COurRole2RoleDist(role,val) == 0） then
			mindist = COurRole2RoleDist(role,val)
			minour = val
		end
		return minour
	end
end

function getOppNum()                                  --拿球人员
    local oppTable = CGetOppNums()      
	for i,val in pairs(ourtable) do    
        if COppIsGetBall(val) then    
			break
		end		
	end
	return val		
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






function  isCeyi(role)                           ---特殊情况：进攻是出现大量防守需要侧移
	dir1 = CRole2OppGoalDir(role)                --对方三球员全来防守
	local i=0
	for i, val in pairs(opptable)do 
		local val1 = tonumber(val)
		if abs(COppNum2BallDir(val1)-dir1) < 30 then
			i++
		end
		if i==4 then
			return true
		else
			return false
		end
	end
end      



["pretendShoot"] = {                                                 -------佯装射门
			switch = function()
				if isStopToGoal(getOppNum())   and then
	  			 		return "shoot"
   				end
			end,

			





}
















gPlayTable.CreatePlay{
firstState = "GetBall",

["Start"] = {
	switch = function()
	     if CBall2RoleDist("Kicker") < 30 and then
			return "PassBall"
		end
	end,
	Kicker   = task.GetBall("Kicker"),
	Tier     = task.GotoPos("Tier",-10,80,(CRole2BallDir("Tier"))),                        
	Receiver = task.GotoPos("Receiver",-10,-80,(CRole2BallDir("Receiver"))),
	Goalie   = task.Goalie()
},

["PassBall"] = {
	switch = function()
		if  getnum("Tier") >=  getnum("Receiver")    then      --判断是否回传
			return "PassBallback"
		end
		if CIsBallKick("Receiver") then
			return "Shoot"
		end
	end,


	if getnum("Tier") >= getnum("Receiver") then					
			Kicker	 = task.PassBall("Kicker","Receiver"),	     --有人阻挡则用跳球
			Receiver = task.task.GoRecePos("Receiver")，
			Tier   = task.GotoPos("Tier",100,80,(CRole2BallDir("Tier"))),
			Goalie   = task.Goalie()
	else
			Kicker	 = task.PassBall("Kicker","Tier")	,
			Receiver = task.task.GoRecePos("Tier")，
			Tier   = task.GotoPos("Kicker",100,-80,(CRole2BallDir("Kicker"))),	
			Goalie   = task.Goalie()
	end     

},




["PassBallback"] = {                          --回传  左右判断对方球员人数 往人少半场回传
	switch = function()
		if CIsBallKick("Receiver") then
			return "Shoot"
		end
	end,
	Kicker = task.PassBall("Kicker","Receiver"),       
	Receiver = task.task.GoRecePos("Receiver")，
	Tier   = task.GotoPos("Tier",100,80,(CRole2BallDir("Tier"))),
	Goalie   = task.Goalie()
},



["Shoot"] = {
	switch = function()
		if CIsBallKick("Receiver") then
			return "finish"
		end
	end,
	Kicker = task.Shoot("Kicker"),
	Receiver = task.RefDef("Receiver"),
	Goalie = task.Goalie()
},

name = "Ref_MiddleKick"
}