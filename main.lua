debug = true

local knotenmodul = require "knot"
local triplemodul = require "triple"
local armymodul= require "army"
local knotRadius = 15
local checkedKnotID = nil

function love.load(arg)
  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  createKnotsAndTripels()
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end
  triplemodul.killTriples()
  triplemodul.updateTriples()
  knotenmodul.killKnots()
end

function love.mousepressed(x, y, button, istouch)
  knot = knotenmodul.getKnotForClick(x, y, knotRadius)
   if button == 1 then -- the primary button
     leftClick(knot, x,y)
   end
   if button == 2 then
     rightClick(knot, x,y)
   end
end

function love.draw(dt)
  drawTriples()
  drawFPS()
  drawKnotens()
end

function createKnotsAndTripels()
  knotenmodul.deleteAllKnots()
  triplemodul.deleteAllTriples()

  cacheKnotens = knotenmodul.createKnotens(1)
  knotens = knotenmodul.getKnotens()
  triplemodul.createTripels(cacheKnotens, knotens)
  print("Knots & Triples erstellt. ")
end

function drawTriples()
  triples = triplemodul.getTriples()
  if triples  ~= nil then
    for i, trip in ipairs(triplemodul.getTriples()) do
      if not trip.killMe then
        love.graphics.setColor(0, 0, 255)
        if trip.option.short then
          love.graphics.setColor(255, 0, 0)
        end

        love.graphics.setLineWidth( 1 )
        if trip.option.check then
          love.graphics.setLineWidth( 3 )
          love.graphics.setColor(0, 250, 0)
        end
        love.graphics.line(trip.knotA.x, trip.knotA.y, trip.knotB.x, trip.knotB.y)
      end
    end
  end
end

function drawFPS()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function drawKnotens()
  knotens = knotenmodul.getKnotens()
  for id, knot in ipairs(knotens) do
    if not knot.killMe then
      if knot.check then
        love.graphics.setColor(255, 0, 0)
      else
        love.graphics.setColor(255, 255, 255)
      end
      love.graphics.rectangle("fill", knot.x, knot.y, knotRadius, knotRadius) --( mode, x, y, width, height )
      love.graphics.print(knot.name, knot.x, knot.y+knotRadius+5)
      drawArmy(knot)
    end
  end
end

function drawArmy(knot)
  if knot.army ~= nil then
    love.graphics.circle( "line", knot.x, knot.y, knotRadius * 1.5, 25 )
    love.graphics.print(knot.army.strength, knot.x+knotRadius * 2, knot.y)
  end
end

function createKnot(x, y)
  name = "x "..x.." y "..y
  knot = knotenmodul.createKnot(x, y, name)
  integradeKnot(knot)
end

function createRandomKnotWithTriple()
  knot = knotenmodul.createRandomKnot()
  integradeKnot(knot)
end

function integradeKnot(knot)
  newKnot = {}
  table.insert(newKnot, knot)
  cacheKnotens = knotenmodul.getKnotens()
  triplemodul.createTripels(cacheKnotens, newKnot)
end

function deleteClickedKnot(knot)
  if(knot ~= nil) then
    knotenmodul.deleteKnot(knot)
    triplemodul.deleteTriplesFromKnot(knot)
  end
end

function leftClick(knot, x,y)
  knotenmodul.uncheckAll()
  if checkedKnotID ~= nil then --We have a checked Knot
    checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
    if checkedKnot ~= nil and checkedKnot.army ~= nil then
      moveCheckedArmy(checkedKnot, x, y)
    else
      moveCheckedKnot(checkedKnot, x, y) --We move the knot to new position
    end
    checkedKnotID = nil
  else -- No checked Knot
    if knot ~= nil then --We clicked a knot
      knot.check = true --we check the knot
      checkedKnotID = knot.id
    else --Click nothing
      createKnot(x, y) --create a knot there
    end
  end
end

function moveCheckedKnot(checkedKnot, x, y)
  if checkedKnot ~= nil then
    checkedKnot.x = x
    checkedKnot.y = y
  end
end

function moveCheckedArmy(checkedKnot, x, y)
  destination = knotenmodul.getKnotForClick(x, y, knotRadius)
  if destination ~= nil and destination.id ~= checkedKnot.id then
    if destination.army ~= nil then --We have already an army
      armymodul.combineForces(destination, checkedKnot)
    else
      armymodul.moveArmy(destination, checkedKnot)
    end
  end
end

function rightClick(knot, x, y)
  if knot ~= nil then
    --deleteClickedKnot(knot)
    rclickedArmy(knot)
  else
    createRandomKnotWithTriple(x)
  end
end


function rclickedArmy(knot)
  if knot.army ~= nill then
    updateArmy(knot)
  else
    createArmy(knot)
  end
end

function createArmy(knot)
  newArmy = armymodul.createArmy()
  knot.army = newArmy
end

function updateArmy(knot)
  knot.army.strength = knot.army.strength + 1
end
