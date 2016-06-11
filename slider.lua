slidermodul = {}
local sliders = {}
local plusIMG = nil
local minusIMG = nil
local sliderIMG = nil

function slidermodul.init(plus, minus, sp)
  plusIMG = plus
  minusIMG = minus
  sliderIMG = sp
end

function slidermodul.createSlider(y)
  local px = math.ceil (love.graphics.getWidth() / 1.1 )
  local mx = math.ceil (love.graphics.getWidth() / 20 )
  -- hälfte der strecke minus hälfte des bildes = x
  local middelX = math.ceil ( (mx + px / 2) - ( sliderIMG:getWidth() / 2) )
  print(px, mx, middelX)
  local slider = {}
  slider.position = 2
  slider.points = slidermodul.createMiddlePoints(middelX, y)
  slider.minus = slidermodul.createMinus(mx, y)
  slider.plus = slidermodul.createPlus(px, y)
  slider.id = love.math.random(12, 848471020) + love.math.random(77, 777777) + middelX + px
  sliders[slider.id] = slider
end

function slidermodul.createMiddlePoints(middelX, y)
  local lps = {}
  local half = middelX / 2
  lps[1] = slidermodul.createMiddlePoint(middelX - half, y)
  lps[2] = slidermodul.createMiddlePoint(middelX, y)
  lps[3] = slidermodul.createMiddlePoint(middelX + half, y)
  return lps
end

function slidermodul.createMiddlePoint(sliderX, y)
  local point = {} --{x, y, r, g, b, a}
  point.x = sliderX
  point.y = y
  point.img = sliderIMG
  return point
end

function slidermodul.createMinus(mx, y)
  local minus = {}
  minus.img = minusIMG
  minus.x = mx
  minus.y = y
  return minus
end

function slidermodul.createPlus(px, y)
  local plus = {}
  plus.img = plusIMG
  plus.x = px
  plus.y = y
  return plus
end

function slidermodul.getSliders()
  return sliders
end

function slidermodul.draw()
  for i, sldr in pairs(sliders) do
    slidermodul.drawButtons(sldr)
    slidermodul.drawLine(sldr)
    slidermodul.drawPoints(sldr)
  end
end

function slidermodul.drawButtons(sldr)
  love.graphics.setColor(200, 200, 200)
  love.graphics.draw(sldr.minus.img, sldr.minus.x, sldr.minus.y)
  love.graphics.draw(sldr.plus.img, sldr.plus.x, sldr.plus.y)
end

function slidermodul.drawLine(sldr)
  local plineY = math.ceil ( sldr.plus.img:getHeight() / 2 ) + sldr.plus.y
  local mlineY = math.ceil ( sldr.minus.img:getHeight() / 2 ) + sldr.minus.y
  local plineX = sldr.plus.x
  local mlineX = math.ceil ( sldr.minus.img:getWidth()) + sldr.minus.x
  love.graphics.setColor(200, 200, 200)
  love.graphics.setLineWidth( 3 )
  love.graphics.line(mlineX, mlineY, plineX, plineY)
end

function slidermodul.drawPoints(sldr)
  for i=1, table.getn(sldr.points) do
    love.graphics.setColor(200, 200, 200)
    if i == sldr.position then
      love.graphics.setColor(255, 0, 0)
    end
    local p = sldr.points[i]
    love.graphics.draw(p.img, p.x, p.y)
  end
end

--[[
function slidermodul.getDistance()
  local v1 = ((px-mx)^2+(globalY-globalY)^2)^0.5
  return math.ceil(v1)
end
]]--

return slidermodul
