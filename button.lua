local slidermodul = require "slider"

local buttonIMG = nil
local buttonmodul = {}
local inGameButtons = {}
local menuButtons = {}
local knotInfoButtons = {}
local administrationButtons = {}
local allButtons = {}
local inGameBX = 20
local menuY = 100
local colorY = 100
local kInfoX = 10
local adminX = 10

function buttonmodul.init(bIMG, p, m, s)
  buttonIMG = bIMG
  slidermodul.init(p, m, s)
end

function buttonmodul.createInGameButton(label, kontext)
  local X = inGameBX + 20 -- abstand zwischen den buttons
  local button = buttonmodul.createButton(inGameBX, 700, label, kontext)
  inGameButtons[button.id] = button
  inGameBX = X + buttonIMG:getWidth()
end

function buttonmodul.createKnotInfoButton(label)
  local x = kInfoX
  local button = buttonmodul.createButton(x, 10, label, false)
  knotInfoButtons[button.id] = button
  kInfoX = math.ceil( x + buttonIMG:getWidth() * 3)
end

function buttonmodul.createAdministrationButton(label)
  local x = adminX
  local button = buttonmodul.createButton(x, 10, label, false)
  administrationButtons[button.id] = button
  adminX = math.ceil( x + buttonIMG:getWidth() * 3)
end

function buttonmodul.createMenuButton(label, kontext)
  local y = menuY + 30
  local xi = math.ceil (love.graphics.getHeight() / 2.5)
  local button = buttonmodul.createButton(xi, y, label, kontext)
  menuButtons[button.id] = button
  menuY = y + buttonIMG:getHeight()
end

function buttonmodul.createButton(xi, yi, label, kontext)
  local button = {}
  button.x = xi
  button.y = yi
  button.img = buttonIMG
  button.height = buttonIMG:getHeight()
  button.width = buttonIMG:getWidth()
  button.label = label
  button.id = love.math.random(2, 5356882) * love.math.random(12, 8899771)..label
  button.kontext = kontext
  return button
end

function buttonmodul.createColorButton(color, name)
  local cy = colorY + 30
  local button = {}
  button.x = math.ceil (love.graphics.getHeight() / 3.1) -- makes it an int
  button.y = cy
  button.img = color.img
  button.height = color.img:getHeight()
  button.width = color.img:getWidth()
  button.kontext = true
  button.label = ""
  button.id = love.math.random(11, 1293029) * love.math.random(122, 777777)..name
  button.checked = false
  button.name = name
  button.red = color.red
  button.blue = color.blue
  button.green  = color.green
  menuButtons[button.id] = button
  colorY = cy + color.img:getHeight()
end

function buttonmodul.getInGameButtons()
  return inGameButtons
end

function buttonmodul.getMenuButtons()
  return menuButtons
end

function buttonmodul.getKnotInfoButtons()
  return knotInfoButtons
end

function buttonmodul.getAdministrationButtons()
  return administrationButtons
end

function buttonmodul.getMenuButtonForClick(x, y)
    return buttonmodul.getButtonForClick(menuButtons, x, y)
end

function buttonmodul.getInGameButtonForClick(x, y)
  return buttonmodul.getButtonForClick(inGameButtons, x, y)
end

function buttonmodul.getButtonForClick(list, x, y)
  if list ~= nil then
    for i, buttn in pairs(list) do
      local xlow = x - buttn.width
      local xhigh = x
      local ylow = y - buttn.height
      local yhigh = y
      --print("x",x,"y",y, "\tx",xlow, xhigh,"\ty", ylow, yhigh)
      for xi = xlow, xhigh, 1 do
        for yi = ylow, yhigh, 1 do
          if buttn.x == xi and buttn.y == yi then
            print("getButtonForClick", buttn.label)
            return buttn
          end
        end
      end
    end
  end
  return nil
end

function buttonmodul.drawButtons(buttons, isKontext)
  for i, buttn in pairs(buttons) do
    love.graphics.setColor(255, 255, 255)
    if not buttn.kontext then -- no a kontext Button
      love.graphics.draw(buttn.img, buttn.x, buttn.y)
      love.graphics.print(buttn.label, buttn.x + (buttn.width / 10), buttn.y+ (buttn.height / 3))
    else -- a kontext Button
      if isKontext ~= nil then --We have a checked Knot, draw kontext menu
        if not buttn.checked then -- Normal Kontext Button, print label
          love.graphics.draw(buttn.img, buttn.x, buttn.y)
          love.graphics.print(buttn.label, buttn.x + (buttn.width / 10), buttn.y+ (buttn.height / 3))
        else -- Clicked Color Button, no label but change color
          love.graphics.setColor(128, 128, 128)
          love.graphics.draw(buttn.img, buttn.x, buttn.y)
        end
      end
    end
  end
end

return buttonmodul
