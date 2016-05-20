debug = true

knotenmodul = require "knot"
triplemodul = require "triple"

radius = 120
world = nil

function love.load(arg)
  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  createKnotsAndTripels()
end

function love.update(dt)
  world:update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end
  triplemodul.updateTriples()
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then -- the primary button
     knotenmodul.moveAllKnotsALittle()
     knotenmodul.createRandomKnot(x)
   end
end

function love.draw(dt)
  for i, trip in ipairs(tripels) do
    if trip.option.short then
      love.graphics.setColor(255, 0, 0)
    else
      love.graphics.setColor(0, 0, 255)
    end
    love.graphics.line(trip.knotA.x, trip.knotA.y, trip.knotB.x, trip.knotB.y)
  end

  love.graphics.setColor(255, 255, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)

  for i, knot in ipairs(knotens) do
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", knot.x, knot.y, 10, 10) --( mode, x, y, width, height )
    love.graphics.print(knot.name, knot.x, knot.y+20)
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("line", knot.x, knot.y, radius, 100)
  end
end

function createKnotsAndTripels()
  for k,v in pairs(tripels) do tripels[k]=nil end --delete all tripels
  for k,v in pairs(knotens) do knotens[k]=nil end --delete all knotens

  print("logging", table.getn(tripels))
  cacheKnotens = knotenmodul.createKnotens(10)
  triplemodul.createTripels(cacheKnotens)
end
