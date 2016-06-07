
local c = require "statics"
local buttonmodul = require "button"

popupmodul = {}
local buttonIMG = nil

function popupmodul.draw(checkedKnot)
  if checkedKnot ~= nil and buttonIMG ~= nil then
    popupmodul.drawStats(checkedKnot)
  end
end

function popupmodul.drawStats(checkedKnot)
  local player = checkedKnot.player
  local Y = 300
  local X = math.ceil ( love.graphics.getWidth() / 3 )
  local scale_factor_X = 2
  local scale_factor_Y = 2
  love.graphics.setColor(player.color.red, player.color.green, player.color.blue)

  local yi = y + 20
  love.graphics.print("Knot: "..tostring(checkedKnot.name), X, yi, 0, scale_factor_X, scale_factor_Y) -- text, x, y

  local yi = y + 40
  if checkedKnot.army ~= nil then
    love.graphics.print("Army: "..tostring(checkedKnot.army.strength), X, yi, 0, scale_factor_X, scale_factor_Y)
  else
    love.graphics.print("Army: "..0, X, yi, 0, scale_factor_X, scale_factor_Y)
  end

  local yi = y + 60
  love.graphics.print("Fort: "..tostring(checkedKnot.fortification), X, yi, 0, scale_factor_X, scale_factor_Y)

  local yi = y + 80
  love.graphics.print("Farm: "..tostring(checkedKnot.farm), X, yi, 0, scale_factor_X, scale_factor_Y)
end

function popupmodul.setIMG(img)
  buttonIMG = img
  buttonmodul.createPopUpButtons(buttonIMG, c.info)
  buttonmodul.createPopUpButtons(buttonIMG, c.info)
  buttonmodul.createPopUpButtons(buttonIMG, c.info)
end

return popupmodul
