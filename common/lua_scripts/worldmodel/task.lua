--[[
本文件夹下的task.lua中包含的是官方的task函数包的调用接口。即二次开发手册6.1的部分

⚫ 6.1.1-6.1.6 函数为官方提供的自定义 task 函数，传入用户编写的 dll 技
能，实现扩展
⚫ 每个自定义 task 函数指定给对应的角色使用，如 KickerTask 对应 Kicker（前锋）、 ReceiverTask 对应 Receiver（中场）等。
⚫ 使用方法示例：
Kicker = KickerTask(“dll 名称” , pos_,dir_,kickflat_,kp_,cp_)

--]]

-- KickerTask  return  KickerSkill


module(..., package.seeall)

function KickerTask(name_,posX,posY,dir_,kickflat_,kp_)
	 return KickerSkill{name=name_,pos_x=posX,pos_y = posY,dir=dir_,kickflat=kickflat_,kp=kp_}
end

function ReceiverTask(name_,posX,posY,dir_,kickflat_,kp_)
	 return ReceiverSkill{name=name_,pos_x=posX,pos_y = posY,dir=dir_,kickflat=kickflat_,kp=kp_}
end

function TierTask(name_,posX,posY,dir_,kickflat_,kp_)
	return TierSkill{name=name_,pos_x=posX,pos_y = posY,dir=dir_,kickflat=kickflat_,kp=kp_}
end

function DefenderTask(name_,posX,posY,dir_,kickflat_,kp_)
	 return DefenderSkill{name=name_,pos_x=posX,pos_y = posY,dir=dir_,kickflat=kickflat_,kp=kp_}
end

function MiddleTask(name_,posX,posY,dir_,kickflat_,kp_)
	return MiddleSkill{name=name_,pos_x=posX,pos_y = posY,dir=dir_,kickflat=kickflat_,kp=kp_}
end

function GoalieTask(name_,posX,posY,dir_,kickflat_,kp_)
	return GoalieSkill{name=name_,pos_x=posX,pos_y = posY,dir=dir_,kickflat=kickflat_,kp=kp_}
end

function GetBall(runner_role,receive)
   return getball{role =runner_role, rec = receive}
end

function Goalie()
	return	goalie{}
end

function GoRecePos(role_name_)
	return goreceivepos{role_name = role_name_}
end	

function RobotHalt(role_name_)
	return halt{role_name = role_name_}
end

function NormalDef(role_name_)
	return normaldef{role_name = role_name_}
end

function PassBall(runner_role_,receive_)
	return passball{runner_role = runner_role_,receive = receive_}	
end

function ReceiveBall(role_name_)
	return receiveball{role_name = role_name_}
end

function Stop(role_name_,role_)
	return stop{exc_role = role_name_,role = role_}
end

function Shoot(role_name_)
	return shoot{role_name = role_name_}
end

function RefDef(role_name_)
	return refdef{role = role_name_}
end

function GotoPos(role_name_,x_,y_,dir_)
	return gotopos{role_name = role_name_, x = x_,y = y_, dir = dir_}
end

function PenaltyDef()
	return penaltydef{}
end

function PenaltyKick(role_name_)
	return penaltykick{role = role_name_}
end

function GetOppNums()
	return getoppnums{}
end
