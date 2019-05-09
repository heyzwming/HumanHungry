dofile("./lua_scripts/opponent/"..OPPONENT_NAME..".lua")
function RunRefPlay(name)
	--local filename = "./lua_scripts/play/Ref/BackKick/Ref_BackKick.lua"
	local filename = "./lua_scripts/play/Ref/"..name..".lua"
	dofile(filename)
end

function SelectRefPlay()
	local curRefMsg --= CGetRefMsg()
	--print("cur msg"..curRefMsg)
	if curRefMsg ~= nil then
		if curRefMsg == "" then
		return false
	    end
	    RunRefPlay(curRefMsg)
	end
	return true
end

if SelectRefPlay() and not gFnishRefPlay  then
	 print("do ref "..gCurrentPlay)
else
	if IS_TEST_MODE then
		gCurrentPlay = gTestPlay
	else
	
		gCurrentPlay = gNormalPlay
	end
	print("do normal play")
end


Run_Play(gCurrentPlay)
print("cur play "..gCurrentPlay)
