local c = require "statics"

slidermodul = {}
local menuSliders = {}
local plusIMG = nil
local minusIMG = nil
local sliderIMG = nil

function slidermodul.init(plus, minus, sp)
  plusIMG = plus
  minusIMG = minus
  sliderIMG = sp
end

function slidermodul.createSlider(list, y, nbrOfPoints)
  local px = math.ceil (love.graphics.getWidth() / 1.1 )
  local mx = math.ceil (love.graphics.getWidth() / 20 )
  -- hälfte der strecke minus hälfte des bildes = x
  --local middelX = math.ceil ( (mx + px / 2) - ( sliderIMG:getWidth() / 2) )
  local distance = slidermodul.getDistance(px, mx, y)
  local mpoints = slidermodul.createMiddlePoints(distance, y, nbrOfPoints)
  local slider = {}
  slider.max = nbrOfPoints
  slider.points = mpoints
  slider.checked = mpoints[math.ceil ( nbrOfPoints / 2 )]
  mpoints[math.ceil ( nbrOfPoints / 2 )].check = true
  slider.minus = slidermodul.createMinus(mx, y)
  slider.plus = slidermodul.createPlus(px, y)
  slider.id = love.math.random(12, 848471020) + love.math.random(77, 777777) + distance + px
  list[slider.id] = slider
end

function slidermodul.createMiddlePoints(distance, y, max)
  local lps = {}
  local disX = math.ceil ( distance + ( sliderIMG:getWidth() * 2) )
  local t = math.ceil ( disX / ( max + 1 ) )
  for i=1, max do
    lps[i] = slidermodul.createMiddlePoint(i, t*i, y)
  end
  return lps
end

function slidermodul.createMiddlePoint(nr, sliderX, y)
  local point = {} --{x, y, r, g, b, a}
  point.label = c.point
  point.position = nr
  point.check = false
  point.x = sliderX
  point.y = y
  point.img = sliderIMG
  point.height = point.img:getHeight()
  point.width = point.img:getWidth()
  return point
end

function slidermodul.createMinus(mx, y)
  local minus = {}
  minus.img = minusIMG
  minus.label = c.minus
  minus.x = mx
  minus.y = y
  minus.height = minusIMG:getHeight()
  minus.width = minusIMG:getWidth()
  return minus
end

function slidermodul.createPlus(px, y)
  local plus = {}
  plus.img = plusIMG
  plus.label = c.plus
  plus.x = px
  plus.y = y
  plus.height = plusIMG:getHeight()
  plus.width = plusIMG:getWidth()
  return plus
end

function slidermodul.getmenuSliders()
  return menuSliders
end

function slidermodul.draw(list)
  for i, sldr in pairs(list) do
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
  for i, point in pairs(sldr.points) do
    love.graphics.setColor(200, 200, 200)
    if point.check then
      love.graphics.setColor(255, 0, 0)
    end
    love.graphics.draw(point.img, point.x, point.y)
  end
end

function slidermodul.getDistance(px, mx, y)
  local v1 = ((px-mx)^2+(y-y)^2)^0.5
  return math.ceil(v1)
end

function slidermodul.click(list, x, y)
  if list ~= nil then
    for i, sldr in pairs(list) do
      local response = slidermodul.clickedButton(sldr.minus, x, y, sldr)
      if response == nil then
        response = slidermodul.clickedButton(sldr.plus, x, y, sldr)
      end
      if response == nil then
        for i, point in pairs(sldr.points) do
          response = slidermodul.clickedButton(point, x, y, sldr)
        end
      end
      return response
    end
  end
  return nil
end

function slidermodul.clickedButton(mp, x, y, sldr)
  local xlow = x - mp.width
  local xhigh = x
  local ylow = y - mp.height
  local yhigh = y
  -- print("x",x,"y",y, "\tx",xlow, xhigh,"\ty", ylow, yhigh)
  for xi = xlow, xhigh, 1 do
    for yi = ylow, yhigh, 1 do
      if mp.x == xi and mp.y == yi then
        if mp.label == c.point then
          slidermodul.checkNewPoint(mp, sldr)
        elseif mp.label == c.plus then
          slidermodul.plusClick(mp, sldr)
        elseif mp.label == c.minus then
          slidermodul.minusClick(mp, sldr)
        end
        return mp
      end
    end
  end
  return nil
end

function slidermodul.checkNewPoint(point, sldr)
  sldr.checked.check = false
  sldr.checked = point
  point.check = true
end

function slidermodul.plusClick(point, sldr)
  if sldr.checked.position < sldr.max then
    local old = sldr.checked
    local next = sldr.points[old.position + 1]
    slidermodul.checkNewPoint(next, sldr)
  end
end

function slidermodul.minusClick(point, sldr)
  if sldr.checked.position > 1 then
    local old = sldr.checked
    local next = sldr.points[old.position - 1]
    slidermodul.checkNewPoint(next, sldr)
  end
end

return slidermodul
