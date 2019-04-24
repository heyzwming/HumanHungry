-- 在进入每一个定位球时，需要在第一次进时进行保持
if gFirstField == "" then
	if CGetBallX() <-200 then
		gFirstField = "Corner"
		dofile("./lua_scripts/play/Ref/CornerDef/CornerDef.lua")
	elseif CGetBallX() < -180 then
		gFirstField = "Back"
		dofile("./lua_scripts/play/Ref/BackDef/BackDef.lua")
	elseif CGetBallX() < 180 then
		gFirstField = "Middle"
		dofile("./lua_scripts/play/Ref/MiddleDef/MiddleDef.lua")
	else
		gFirstField = "Front"
		dofile("./lua_scripts/play/Ref/FrontDef/FrontDef.lua")
	end
else
	if gFirstField == "Corner" then
		dofile("./lua_scripts/play/Ref/CornerDef/CornerDef.lua")
	elseif  gFirstField == "Back" then
		dofile("./lua_scripts/play/Ref/BackDef/BackDef.lua")
	elseif gFirstField == "Middel" then
		dofile("./lua_scripts/play/Ref/MiddleDef/MiddleDef.lua")
	elseif gFirstField == "Front" then
		dofile("./lua_scripts/play/Ref/FrontDef/FrontDef.lua")
	end
end

