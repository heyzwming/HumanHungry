timestamp = string.format(os.date("%Y%m%d%H%M"))
--system play
IS_TEST_MODE = false
OPPONENT_NAME = "Other"
gTestPlay = {} --=%TEST_SCRITP_NAME%
gNormalPlay = "NormalPlayDefend"--= %NORMAL_PLAY_NAME%
--IS_SIM = CIsSim()
--print(IS_SIM,"sim")
--role num
gRoleFixNum = {
	["Kicker"]   = {},
	["Middle"]   = {},
	["Goalie"]   = {},
	["Defender"] = {}, 
	["Tier"]     = {},
	["Receiver"] = {}
}

gSkill={
	"TierSkill",
	"ReceiverSkill",
	"MiddleSkill",
	"KickerSkill",
	"GoalieSkill",
	"DefenderSkill"
}

gPlayBotSkill={
	"getball",
	"goalie",
	"goreceivepos",
	"halt",
	"normaldef",
	"passball",
	"receiveball",
	"shoot",
	"stop",
	"refdef",
	"gotopos",
	"penaltydef",
	"penaltykick"
}

gRefPlayTable ={

}

gBayesPlayTable={
	"Nor/NormalPlayDefend"
}

gTestPlayTable = {
--%TEST_SCRITP_FILE_NAME%%
}

for	role,num in pairs(gRoleFixNum)do
	for _,id in pairs(num)do
		print("robot id -------" ..id-1)
		if id ~= nil then
			CRegisterRole(role,id-1)
		end
	end
end
