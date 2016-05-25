debug = true

local knotenmodul = require "knot"
local triplemodul = require "triple"
local knotRadius = 15

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
  --
  knot = knotenmodul.clickCheck(x, y, knotRadius)
  knotenmodul.uncheckAll()
   if button == 1 then -- the primary button
     if knot ~= nil then
       markKnot(knot)
     else
       createKnot(x, y)
     end
   end
   if button == 2 then
     if knot ~= nil then
       deleteClickedKnot(knot)
     else
       createRandomKnotWithTriple(x)
     end
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
    end
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
  knotenmodul.addKnot(knot)
end

function deleteClickedKnot(knot)
  if(knot ~= nil) then
    knotenmodul.deleteKnot(knot)
    triplemodul.deleteTriplesFromKnot(knot)
  end
end

function markKnot(knot)
  knot.check = true
end
