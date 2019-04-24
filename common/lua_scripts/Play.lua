table_meta={}
function table_meta.merge(a,b)
	for _,v in ipairs(b)do
		table.insert(a,v)
	end
	return a
end

gPlay = {}
table_meta.merge(gPlay,gBayesPlayTable)
table_meta.merge(gPlay,gRefPlayTable)
table_meta.merge(gPlay,gTestPlayTable)
key = ""
function PrintTable(table , level)
  level = level or 1
  local indent = ""
  for i = 1, level do
    indent = indent.."  "
  end

  if key ~= "" then
    print(indent..key.." ".."=".." ".."{")
  else
    print(indent .. "{")
  end

  key = ""
  for k,v in pairs(table) do
     if type(v) == "table" then
        key = k
        PrintTable(v, level + 1)
     else
        local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
      print(content)  
      end
  end
  print(indent .. "}")

end
PrintTable(gPlay)
gPlayTable = {}
PrintTable(gRefPlayTable)
function gPlayTable.CreatePlay(playmetatable)
	gPlayTable[playmetatable.name] = playmetatable
	--local ta = string.format("%s",tostring(playmetatable))
	--print(ta)
end

gCurrentState = ""
gCurrentPlay = ""
gLastState = ""
gLastPlay = ""
gRealState = ""
gFnishRefPlay = false

function Run_Play(play_name)
	local cur_play = gPlayTable[play_name]
	print("cur gstate " ..gCurrentState)
	--if cur_play ~=nil then
		--PrintTable(cur_play)
	--end
	if cur_play ~= nil then
		if play_name ~= gLastPlay then
			if cur_play.firstState ~= nil then
				gCurrentState = cur_play.firstState
			else
				print("play not init firstState")
			end
		end
		local cur_state
		local state_one 
		local state_two 
		if cur_play.switch ~= nil then
			state_one = cur_play:switch()
		else
			state_two = cur_play[gCurrentState]:switch()
		end
		if state_one ~= nil then
			cur_state = state_one
		elseif state_two ~= nil then
			if state_two ~= "finish" then
				print("cur state ".. state_two)
				cur_state = state_two
				gFnishRefPlay = false
			else
				gFnishRefPlay = true
			end
		else
			
		end
		if cur_state ~=nil and cur_state ~= gLastState then
			CISStateSwitch(true)
		else
			CISStateSwitch(false)
		end
		if cur_state ~= nil then
			gLastState = gCurrentState 
			gCurrentState = cur_state
		end
	gLastPlay = play_name
	if gCurrentState == "exit" or gCurrentState == "finish" then
		gRealState = gLastState
	else
		gRealState = gCurrentState
	end
	for role,v in pairs(cur_play[gRealState])do
		local task = cur_play[gRealState][role]
		if task ~= nil then
			task()
		else
			print("no task")
		end
	end
	else
		print(" run play error , script have syntax error  or script name variable not same with file name in " ..play_name)
	end
end

function Play_Exit(play_name)
	if(gPlayTable[play_name] ~= nil) then
		if gCurrentState == "finish" or gCurrentState == " exit" then
			return true
		else
			return false
		end
	else 
		print("skill error")
	end
end


