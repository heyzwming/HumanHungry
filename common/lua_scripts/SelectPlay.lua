dofile("./lua_scripts/opponent/"..OPPONENT_NAME..".lua")		-- 打开战术包文件夹下的战术.lua
function RunRefPlay(name)	-- 运行 有裁判干涉情况下的play战术
	--local filename = "./lua_scripts/play/Ref/BackKick/Ref_BackKick.lua"
	local filename = "./lua_scripts/play/Ref/"..name..".lua"
	dofile(filename)
end

function SelectRefPlay()	-- 选择 Ref下的战术
	local curRefMsg --= CGetRefMsg()
	--print("cur msg"..curRefMsg)
	if curRefMsg ~= nil then
		if curRefMsg == "" then
		return false
	    end
	    RunRefPlay(curRefMsg)	-- 运行当前Ref
	end
	return true
end

-- 裁判干涉指的是 点球、任意球、暂停 等等

if SelectRefPlay() and not gFnishRefPlay  then	-- 运行 裁判干涉下的 战术 & 裁判干涉未结束
	 print("do ref "..gCurrentPlay)
else			-- 非 裁判干涉 脚本
	if IS_TEST_MODE then		-- 如果是 测试模式
		gCurrentPlay = gTestPlay		-- 运行 测试 战术
	else						-- 否则
		gCurrentPlay = gNormalPlay		-- 运行 常规 战术
	end
	print("do normal play")
end


Run_Play(gCurrentPlay)		-- 运行当前的play战术脚本
print("cur play "..gCurrentPlay)
