local c = require "statics"
local buttonmodul = require "button"
local playermodul = require "player"

local startMenu = {}
local startMenuButtons = {}
local done = nil
local isKontext = nil
local colorButtons = {}
local checkedColorButton = nil

function startMenu.init(colors)
  startMenu.createButtons()
  -- color buttons
  for name, color in pairs(colors) do
    local cb = buttonmodul.createColorButton(color, name)
    colorButtons[name] = cb
  end
  done = false
end

function startMenu.createButtons()
  local xi = math.ceil (love.graphics.getHeight() / 2.5)
  local yi = 100
  -- normal menu buttons
  local pve = buttonmodul.createButton(xi, yi, c.pve, false)--createButton(xi, yi, label, kontext)
  startMenuButtons[pve.id] = pve
  local pvp = buttonmodul.createButton(xi, yi + 100, c.pvp, false)
  startMenuButtons[pvp.id] = pvp
  -- kontext menu buttons
  local cp = buttonmodul.createButton(xi, yi + 200, c.createPlayer, true)
  startMenuButtons[cp.id] = cp
  local cont = buttonmodul.createButton(xi, yi + 300, c.continue, true)
  startMenuButtons[cont.id] = cont
end

function startMenu.draw()
  buttonmodul.drawButtons(startMenuButtons, isKontext)
  buttonmodul.drawButtons(colorButtons, isKontext)
  startMenu.drawPlayers()
end

function startMenu.drawPlayers()
  local players = playermodul.getPlayers()
  local y = 100
  local x = math.ceil (love.graphics.getHeight() / 1.5)
  for i, player in pairs(players) do
    local yi = y + 30
    love.graphics.setColor(player.color.red, player.color.green, player.color.blue)
    love.graphics.print(i.." "..player.name, x, yi)
    y = yi + 30
  end
end

function startMenu.leftClick(x, y)
  local btn = buttonmodul.getButtonForClick(startMenuButtons, x, y)
  if btn == nil and isKontext ~= nil then --button clicked
    btn = buttonmodul.getButtonForClick(colorButtons, x, y)
  end
  if btn ~= nil then --button clicked
    startMenu.handeMenuButton(btn)
  end
end

function startMenu.handeMenuButton(btn)
  if btn ~= nil then
    if btn.label == c.pve or btn.label == c.pvp then
      print("handle", btn.label)
      isKontext = btn.label
    elseif btn.label == c.continue and isKontext == c.pvp then
      print("handle", c.continue)
      startMenu.stop()
    elseif startMenu.isColorButton(btn) and isKontext == c.pvp then
      print("handle", btn.name)
      startMenu.checkColorButton(btn)
    elseif btn.label == c.createPlayer and isKontext == c.pvp then
      print("handle", btn.label)
      startMenu.createPlayer()
    end
  end
end

function startMenu.isColorButton(btn)
  for name, color in pairs(colorButtons) do
    if name == btn.name then
      return true
    end
  end
  return false
end

function startMenu.checkColorButton(btn)
  if checkedColorButton ~= nil then
    checkedColorButton.checked = false
  end
  btn.checked = true
  checkedColorButton = btn
end


function startMenu.done()
  return done
end

function startMenu.stop()
  if playermodul.anyPlayersLeft() then
    done = true
  end
end

function startMenu.createPlayer()
  if checkedColorButton ~= nil then
    local btn = checkedColorButton
    local newPlayer = playermodul.createPlayer(btn.name, btn.red, btn.green, btn.blue)
    checkedColorButton.checked = false
  end
end

function startMenu.getPlayerModul()
  return playermodul
end

return startMenu
