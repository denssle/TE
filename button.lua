local slidermodul = require "slider"

local buttonmodul = {}
local buttonIMG = nil
local colorY = 100

function buttonmodul.init(bIMG, p, m, s)
  buttonIMG = bIMG
  slidermodul.init(p, m, s)
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
  button.id = love.math.random(11, 1293029) * love.math.random(122, 7777778)..name
  button.checked = false
  button.name = name
  button.red = color.red
  button.blue = color.blue
  button.green  = color.green
  colorY = cy + color.img:getHeight()
  return button
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
            print("getButtonForClick", buttn.label, buttn.id)
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

function buttonmodul.drawSliders(list)
  slidermodul.draw(list)
end

function buttonmodul.createSlider(list, y, max)
  slidermodul.createSlider(list, y, max)
end

function buttonmodul.getSliderButtonForClick(list, x, y)
  return slidermodul.click(list, x, y)
end

return buttonmodul
