--desc:

gPlayTable.CreatePlay {

firstState = "goto",

["goto"] = {
  switch = function()
    if bufcnt(player.toTargetDist("Tier") < 30, 60) then
      return "pass"
    end
  end,
  Kicker = task.goTouchPos(CGeoPoint:new_local(30, 150)),
  Tier   = task.staticGetBall(CGeoPoint:new_local(300, 0)),
  Goalie = task.goalie(),
  match  = ""
},

["pass"] = {
  switch = function()
    if bufcnt(player.kickBall("Tier") or player.isBallPassed("Tier", "Kicker"), 1) then
      return "kick"
    end
  end,    
  Kicker = task.goTouchPos(CGeoPoint:new_local(30, 150)),
  Tier   = task.goAndTurnKick("Kicker"),
  Goalie = task.goalie(),
  match  = ""
},  

["kick"] = {
    switch = function()
    if bufcnt(player.kickBall("Kicker") or player.kickBall("Goalie"), 1) then            
      return "goto"                                     
    end 
  end,   
  Kicker = task.touch(),
  Tier   = task.stop(), 
  Goalie = task.goalie(),
  match  = ""
},

name = "DemoPlay",
applicable ={
  exp = "a",
  a = true
},

attribute = "attack",
timeout   = 99999
}