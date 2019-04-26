gSkillTable = {}		-- 技能表（table）

function gSkillTable.CreateSkill(spec)
	assert(type(spec.name) == "string")	-- 断言 spec.name的类型为 string 类型
	print("Init Skill: "..spec.name)	
	gSkillTable[spec.name] = spec
	return spec
end
