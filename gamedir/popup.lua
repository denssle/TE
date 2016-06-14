local c = require "statics"
local buttonmodul = require "button"

popupmodul = {}
local buttonIMG = nil

function popupmodul.draw(checkedKnot, player)
  if checkedKnot == nil then
    popupmodul.administrationPopup(player)
  else
    popupmodul.knotPopup(checkedKnot)
  end
end

function popupmodul.knotPopup(checkedKnot)
  local player = checkedKnot.player
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

function popupmodul.administrationPopup(player)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Admin: "..tostring(player.name), 200, 400)
end

function popupmodul.init(img)
  buttonIMG = img
  buttonmodul.createAdministrationButton(c.administration)
  buttonmodul.createAdministrationButton(c.info)

  buttonmodul.createKnotInfoButton(c.updateArmy)
  buttonmodul.createKnotInfoButton(c.buildFort)
  buttonmodul.createKnotInfoButton(c.buildFarm)
end

return popupmodul
