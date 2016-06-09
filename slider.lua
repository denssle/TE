slidermodul = {}

local plusIMG = nil
local minusIMG = nil
local middelX = nil
local points = nil
local position = 2
local px = math.ceil (love.graphics.getWidth() / 1.1 )
local mx = math.ceil (love.graphics.getWidth() / 20 )
local globalY = math.ceil (love.graphics.getHeight() / 1.1 )

function slidermodul.init(plus, minus, sp)
  plusIMG = plus
  minusIMG = minus
  -- hälfte der strecke minus hälfte des bildes = x
  middelX = math.ceil ( (mx + px / 2) - ( sp:getWidth() / 2) )
  points = slidermodul.createPoints(sp)
end

function slidermodul.draw()
  slidermodul.drawButtons()
  slidermodul.drawLine()
  slidermodul.getDistance()
  slidermodul.drawPoints()
end

function slidermodul.drawButtons()
  love.graphics.setColor(200, 200, 200)
  if plusIMG ~= nil then
    love.graphics.draw(plusIMG, px, globalY)
  end
  if minusIMG ~= nil then
    love.graphics.draw(minusIMG, mx, globalY)
  end
end

function slidermodul.drawLine()
  local plineY = math.ceil ( plusIMG:getHeight() / 2 ) + globalY
  local mlineY = math.ceil ( minusIMG:getHeight() / 2 ) + globalY
  local plineX = px
  local mlineX = math.ceil ( minusIMG:getWidth()) + mx
  love.graphics.setColor(200, 200, 200)
  love.graphics.setLineWidth( 3 )
  love.graphics.line(mlineX, mlineY, plineX, plineY)
  return mlineX
end

function slidermodul.drawPoints()
  for i=1, table.getn(points) do
    love.graphics.setColor(200, 200, 200)
    if i == position then
      love.graphics.setColor(255, 0, 0)
    end
    local p = points[i]
    love.graphics.draw(p.img, p.x, p.y)
  end
end

function slidermodul.createPoints(pointIMG)
  local lps = {}
  local half = middelX / 2
  lps[1] = slidermodul.createPoint(middelX - half, pointIMG)
  lps[2] = slidermodul.createPoint(middelX, pointIMG)
  lps[3] = slidermodul.createPoint(middelX + half, pointIMG)
  --print(points[0].x, points[1].x, points[2].x)
  return lps
end

function slidermodul.createPoint(sliderX, pimg)
  local point = {} --{x, y, r, g, b, a}
  point.x = sliderX
  point.y = globalY
  point.img = pimg
  return point
end

function slidermodul.getDistance()
  local v1 = ((px-mx)^2+(globalY-globalY)^2)^0.5
  return math.ceil(v1)
end

return slidermodul
