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
  button.id = love.math.random(2, 99998) * love.math.random(12, 8899771)..label

  menuButtons[button.id] = button
  menuY = y + img:getHeight()
end

function buttonmodul.createColorButton(cimg, label)
  local cy = colorY + 30
  local button = {}
  button.x = math.ceil (love.graphics.getHeight() / 3.1) -- makes it an int
  button.y = cy
  button.img = cimg
  button.height = cimg:getHeight()
  button.width = cimg:getWidth()
  button.kontext = true
  button.label = ""
  button.id = love.math.random(11, 1293029) * love.math.random(122, 777777)..label
  menuButtons[button.id] = button
  colorY = cy + cimg:getHeight()
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
            print("getButtonForClick", buttn.id)
            return buttn
          end
        end
      end
    end
  end
  return nil
end

function buttonmodul.drawButtons(buttons, checkedKnotID)
  love.graphics.setColor(255, 255, 255)
  for i, buttn in pairs(buttons) do
    if not buttn.kontext then -- no a kontext Button
      love.graphics.draw(buttn.img, buttn.x, buttn.y)
      love.graphics.print(buttn.label, buttn.x + (buttn.width / 10), buttn.y+ (buttn.height / 3))
    else -- a kontext Button
      if checkedKnotID ~= nil then --We have a checked Knot, draw kontext menu
        love.graphics.draw(buttn.img, buttn.x, buttn.y)
        love.graphics.print(buttn.label, buttn.x + (buttn.width / 10), buttn.y+ (buttn.height / 3))
      end
    end
  end
end

return buttonmodul
