local c = require "statics"
local buttonmodul = require "button"

knotStats = {}
local buttons = {}
local checkedKnot = nil

function knotStats.init()
  local ua = buttonmodul.createButton(10, 20, c.updateArmy, false) -- createButton(xi, yi, label, kontext)
  buttons[ua.id] = ua
  local bfort = buttonmodul.createButton(110, 20, c.buildFort, false)
  buttons[bfort.id] = bfort
  local bfarm = buttonmodul.createButton(210, 20, c.buildFarm, false)
  buttons[bfarm.id] = bfarm
end

function administrationPopup.start(kn)
  checkedKnot = kn
end

function administrationPopup.stop()
  checkedKnot = nil
end

function knotStats.draw(checkedKnot, player)
  local Y = 300
  local X = math.ceil ( love.graphics.getWidth() / 3 )
  local scale_factor_X = 2
  local scale_factor_Y = 2
  love.graphics.setColor(player.color.red, player.color.green, player.color.blue)

  local yi = Y + 20
  love.graphics.print("Knot: "..tostring(checkedKnot.name), X, yi, 0, scale_factor_X, scale_factor_Y) -- text, x, y

  local yi = Y + 40
  if checkedKnot.army ~= nil then
    love.graphics.print("Army: "..tostring(checkedKnot.army.strength), X, yi, 0, scale_factor_X, scale_factor_Y)
  else
    love.graphics.print("Army: "..0, X, yi, 0, scale_factor_X, scale_factor_Y)
  end

  local yi = Y + 60
  love.graphics.print("Fort: "..tostring(checkedKnot.fortification), X, yi, 0, scale_factor_X, scale_factor_Y)

  local yi = Y + 80
  love.graphics.print("Farm: "..tostring(checkedKnot.farm), X, yi, 0, scale_factor_X, scale_factor_Y)
end

function knotStats.clickedButton(x, y)
  local btn = buttonmodul.getButtonForClick(buttons, x, y)
end

return knotStats
