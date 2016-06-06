local buttonmodul = require "button"
local playermodul = require "player"
local c = require "statics"

local menumodul = {}
checkedKnotID = nil
local inGame = false

function menumodul.initMenu(buttonIMG)
  -- normal menu buttons
  buttonmodul.createMenuButton(buttonIMG, c.pve, false)
  buttonmodul.createMenuButton(buttonIMG, c.pvp, false)
  -- normal menu buttons
  buttonmodul.createMenuButton(buttonIMG, c.continue, true)
  menumodul.createPlayers()
end

function menumodul.update()
  return inGame
end

function menumodul.draw()
  local buttons = buttonmodul.getMenuButtons()
  buttonmodul.drawButtons(buttons, checkedKnotID)
end

function menumodul.leftClick(x, y)
  btn = buttonmodul.getMenuButtonForClick(x, y)
  if btn ~= nil then --button clicked
    menumodul.handeMenuButton(btn)
  end
end

function menumodul.handeMenuButton(btn)
  if btn ~= nil then
    if btn.label == c.pve then
      print("handle", c.pve)
    elseif btn.label == c.pvp then
      checkedKnotID = btn.label
    elseif btn.label == c.continue and checkedKnotID == c.pvp then
      print("handle", c.continue)
      menumodul.startGame()
    end
  end
end

function menumodul.startGame()
  inGame = true
end

function menumodul.createPlayers()
  red = playermodul.createPlayer("RED", 255, 0, 0)
  blue = playermodul.createPlayer("BLUE", 0, 0, 255)
end

function menumodul.getPlayerModul()
  return playermodul
end

return menumodul
