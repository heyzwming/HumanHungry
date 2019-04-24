-- 在进入每一个定位球时，需要在第一次进时进行保持
--need to modify
if CGetBallX() <-200 then
	dofile("./lua_scripts/play/Ref/CornerDef/CornerDef.lua")
elseif CGetBallX() > 180 then
	dofile("./lua_scripts/play/Ref/FrontDef/FrontDef.lua")
elseif CGetBallX() > -180 then
	dofile("./lua_scripts/play/Ref/MiddleDef/MiddleDef.lua")
else
	dofile("./lua_scripts/play/Ref/BackDef/BackDef.lua")
end
