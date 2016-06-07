local buttonmodul = require "button"
local playermodul = require "player"
local c = require "statics"

local menumodul = {}
local isKontext = nil
local inGame = false
local colorButtons = nil
local checkedColorButton = nil

function menumodul.initMenu(buttonIMG, colors)
  -- normal menu buttons
  buttonmodul.createMenuButton(buttonIMG, c.pve, false)
  buttonmodul.createMenuButton(buttonIMG, c.pvp, false)
  -- kontext menu buttons
  buttonmodul.createMenuButton(buttonIMG, c.createPlayer, true)
  buttonmodul.createMenuButton(buttonIMG, c.continue, true)
  -- color buttons
  for name, color in pairs(colors) do
    buttonmodul.createColorButton(color, name)
  end
  colorButtons = colors
end

function menumodul.update()
  return inGame
end

function menumodul.draw()
  local buttons = buttonmodul.getMenuButtons()
  buttonmodul.drawButtons(buttons, isKontext)
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
      isKontext = btn.label
    elseif btn.label == c.continue and isKontext == c.pvp then
      print("handle", c.continue)
      menumodul.startGame()
    elseif menumodul.isColorButton(btn) and isKontext == c.pvp then
      print("handle", btn.label)
      menumodul.checkColorButton(btn)
    elseif btn.label == c.createPlayer and isKontext == c.pvp then
      print("handle", btn.label)
      menumodul.createPlayer()
    end
  end
end

function menumodul.isColorButton(btn)
  for name, color in pairs(colorButtons) do
    if name == btn.name then
      return true
    end
  end
  return false
end

function menumodul.checkColorButton(btn)
  if checkedColorButton ~= nil then
    checkedColorButton.checked = false
  end
  btn.checked = true
  checkedColorButton = btn
end

function menumodul.startGame()
  if playermodul.anyPlayersLeft() then
    inGame = true
  end
end

function menumodul.createPlayer()
  if checkedColorButton ~= nil then
    local btn = checkedColorButton
    local newPlayer = playermodul.createPlayer(btn.label, btn.red, btn.green, btn.blue)
    checkedColorButton.checked = false
  end
end

function menumodul.getPlayerModul()
  return playermodul
end

return menumodul
