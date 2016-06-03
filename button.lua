local buttonmodul = {}
local inGameButtons = {}
local menuButtons = {}
local inGameBX = 20
local menuY = 100

function buttonmodul.createInGameButton(img, label, knotKontext)
  local X = inGameBX + 20 -- abstand zwischen den buttons
  local button = {}
  button.x = inGameBX
  button.y = 700
  button.img = img
  button.height = img:getHeight()
  button.width = img:getWidth()
  button.label = label
  button.id = love.math.random(2, 53562) * love.math.random(12, 8899771)..label
  button.knotKontext = knotKontext
  inGameButtons[button.id] = button
  inGameBX = X + img:getWidth()
end

function buttonmodul.createMenuButton(img, label, kontext)
  local y = menuY + 30
  local button = {}
  button.x = love.graphics.getHeight() / 2.5
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
      for xi = xlow, xhigh, 1 do
        for yi = ylow, yhigh, 1 do
          if buttn.x == xi and buttn.y == yi then
            print("pressed button", buttn.id)
            return buttn
          end
        end
      end
    end
  end
  return nil
end

return buttonmodul
