-- 在进入每一个定位球时，需要在第一次进时进行保持
-- 间接任意球 类型分配脚本
-- 根据 任意球 球的x坐标位置 判断为 角球任意球、前场任意球、中场任意球、后场任意球。
if gFirstField == "" then
	if CGetBallX() > 250 then
		gFirstField = "Corner"
		dofile("./lua_scripts/play/Ref/CornerKick/CornerKick.lua")
	elseif CGetBallX() > 180 then
		gFirstField = "Front"
		dofile("./lua_scripts/play/Ref/FrontKick/FrontKick.lua")
	elseif CGetBallX() > -180 then
		gFirstField = "Middle"
		dofile("./lua_scripts/play/Ref/MiddleKick/MiddleKick.lua")
	else
		gFirstField = "Back"
		dofile("./lua_scripts/play/Ref/BackKick/BackKick.lua")
	end
else
	if gFirstField == "Corner" then
		dofile("./lua_scripts/play/Ref/CornerKick/CornerKick.lua")
	elseif  gFirstField == "Front" then
		dofile("./lua_scripts/play/Ref/FrontKick/FrontKick.lua")
	elseif gFirstField == "Middel" then
		dofile("./lua_scripts/play/Ref/MiddleKick/MiddleKick.lua")
	elseif gFirstField == "Back" then
		dofile("./lua_scripts/play/Ref/BackKick/BackKick.lua")
	end
end

