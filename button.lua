local buttonmodul = {}
local buttons = {}

function buttonmodul.createButton(x, y, img, label)
  button = {}
  button.x = x
  button.y = y
  button.img = img
  button.height = img:getHeight()
  button.width = img:getWidth()
  button.label = label
  button.id = love.math.random(2, 53562) * love.math.random(12, 8899771)
  table.insert(buttons, button)
end

function buttonmodul.getButtons()
  return buttons
end

function buttonmodul.getButtonForClick(x, y)
--[[
xlow = x - param
xhigh = x -- + param
ylow = y - param
yhigh = y -- + param

for xi = xlow, xhigh, 1 do
  for yi = ylow, yhigh, 1 do
    for i, buttn in ipairs(buttons) do
      if buttn.x == x and buttn.y == y then
        return buttn
      end
    end
  end
end
return nil
]]--
  for i, buttn in ipairs(buttons) do
    local xlow = x - buttn.width
    local xhigh = x -- + param
    local ylow = y - buttn.height
    local yhigh = y -- + param
    for xi = xlow, xhigh, 1 do
      for yi = ylow, yhigh, 1 do
        if buttn.x == xi and buttn.y == yi then
          print("buttn", buttn.label)
          return buttn
        end
      end
    end
    return nil
  end
end

return buttonmodul
