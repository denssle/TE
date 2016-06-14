local c = require "statics"
local buttonmodul = require "button"

administrationPopup = {}
local buttons = {}
local player = nil

function administrationPopup.init()
  buttonIMG = img
  --administration
  local am = buttonmodul.createButton(10, 20, c.administration, false) -- createButton(xi, yi, label, kontext)
  buttons[am.id] = am
  local info = buttonmodul.createButton(110, 20, c.info, false)
  buttons[info.id] = info
end

function administrationPopup.start(plr)
  player = plr
end

function administrationPopup.stop()
  player = nil
end

function administrationPopup.draw(checkedKnot, player)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Administation of Player: "..tostring(player.name), 200, 400)
end

function administrationPopup.clickedButton(x, y)
  local btn = buttonmodul.getButtonForClick(buttons, x, y)
end

return administrationPopup
