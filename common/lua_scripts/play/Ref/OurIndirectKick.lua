-- 在进入每一个定位球时，需要在第一次进时进行保持
if CGetBallX() > 250 then
	dofile("./lua_scripts/play/Ref/CornerKick/CornerKick.lua")
elseif CGetBallX() > 180 then
	dofile("./lua_scripts/play/Ref/FrontKick/FrontKick.lua")
elseif CGetBallX() > -180 then
	dofile("./lua_scripts/play/Ref/MiddleKick/MiddleKick.lua")
else
	dofile("./lua_scripts/play/Ref/BackKick/BackKick.lua")
end
