package.path = package.path .. ";./lua_scripts/skill/?.lua"
package.path = package.path .. ";./lua_scripts/play/?.lua"
package.path = package.path .. ";./lua_scripts/worldmodel/?.lua"
package.path = package.path .. ";./lua_scripts/opponent/?.lua"

require(OPPONENT_NAME)
require("Skill")
require("Play")
require("task")

for _, value in ipairs(gSkill) do
	local filename = "./lua_scripts/skill/"..value..".lua"
	dofile(filename)
end

for _, value in ipairs(gPlayBotSkill) do
	local filename = "./lua_scripts/skill/PlayBotSkill/"..value..".lua"
	dofile(filename)
end

for _, value in ipairs(gPlay) do
	local filename = "./lua_scripts/play/"..value..".lua"
	dofile(filename)
end
