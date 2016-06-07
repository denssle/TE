local buttonmodul = {}
local inGameButtons = {}
local menuButtons = {}
local inGameBX = 20
local menuY = 100
local colorY = 100


function buttonmodul.createInGameButton(img, label, kontext)
  local X = inGameBX + 20 -- abstand zwischen den buttons
  local button = {}
  button.x = inGameBX
  button.y = 700
  button.img = img
  button.height = img:getHeight()
  button.width = img:getWidth()
  button.label = label
  button.id = love.math.random(2, 53562) * love.math.random(12, 8899771)..label
  button.kontext = kontext
  button.checked = false
  inGameButtons[button.id] = button
  inGameBX = X + img:getWidth()
end

function buttonmodul.createMenuButton(img, label, kontext)
  local y = menuY + 30
  local button = {}
  button.x = math.ceil (love.graphics.getHeight() / 2.5)
  button.y = y
  button.img = img
  button.height = img:getHeight()
  button.width = img:getWidth()
  button.label = label
  button.kontext = kontext
  button.id = love.math.random(2, 120000) * love.math.random(12, 8899771)..label
  button.checked = false
  menuButtons[button.id] = button
  menuY = y + img:getHeight()
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
        love.graphics.draw(buttn.img, buttn.x, buttn.y)
        if not buttn.checked then -- Normal Kontext Button, print label
          love.graphics.print(buttn.label, buttn.x + (buttn.width / 10), buttn.y+ (buttn.height / 3))
        else -- Clicked Color Button, no label but change color
          love.graphics.setColor(128, 128, 128)
        end
      end
    end
  end
end

return buttonmodul
