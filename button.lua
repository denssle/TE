local buttonmodul = {}
local buttons = {}
local globalX = 20

function buttonmodul.createButton(img, label)
  local X = globalX + 20 -- abstand zwischen den buttons
  local button = {}
  button.x = globalX
  button.y = 700
  button.img = img
  button.height = img:getHeight()
  button.width = img:getWidth()
  button.label = label
  button.id = love.math.random(2, 53562) * love.math.random(12, 8899771)..label
  buttons[button.id] = button
  globalX = X + img:getWidth()
end

function buttonmodul.getButtons()
  return buttons
end

function buttonmodul.getButtonForClick(x, y)
  for i, buttn in pairs(buttons) do
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
  return nil
end

return buttonmodul
