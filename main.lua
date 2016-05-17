debug = true

knotens = {}
tripels = {}
shortRangeTripels = {}
longRangeTripels={}
radius = 100

function love.load(arg)
  knotenIMG = love.graphics.newImage('assets/ball.png')
  cacheKnotens = {}
  for i = 1, 7   do
    max = love.graphics.getWidth()
    min = i
    randX = love.math.random(min, max)
    randY = love.math.random(min, max)
    knot = { x = randX, y = randY, name = i, img = knotenIMG }
    table.insert(knotens, knot)
    table.insert(cacheKnotens, knot)
  end
  createTripels(cacheKnotens)
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end
end

function love.draw(dt)
  for i, knot in ipairs(knotens) do
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(knot.img, knot.x, knot.y)
    love.graphics.print(knot.name, knot.x, knot.y+20)
  end

  for i, trip in ipairs(tripels) do
    if trip.option.short == true then
      love.graphics.setColor(255, 0, 0)
    else
      love.graphics.setColor(0, 0, 255)
    end
    love.graphics.line(trip.knotA.x, trip.knotA.y, trip.knotB.x, trip.knotB.y)
  end
end

function getDistance(knot1, knot2)
  x1 = knot1.x
  x2 = knot2.x
  y1 = knot1.y
  y2 = knot2.y
  distance = ((x2-x1)^2+(y2-y1)^2)^0.5
  return math.ceil(distance)
end

function createTripels(cacheKnotens)
  for i, knot in ipairs(knotens) do
    for j, knot2 in ipairs(cacheKnotens) do
      if knot.name ~= knot2.name then
        trip = createTripel(knot, knot2)
        table.insert(tripels, trip)
      end
    end
    k = getIndexForID(cacheKnotens, knot.name)
    table.remove(cacheKnotens, k)
  end
end

function createTripel(knot, knot2)
  dis = getDistance(knot, knot2)
  options = createOptions(dis)
  print(knot.name, " - ", knot2.name, "short: ", options.short, "distance", dis)
  trip = {
    knotA = knot,
    knotB = knot2,
    option = options
  }
  return trip
end

function createOptions(dis)
  s = false
  if(dis < radius) then
    s = true
  end

  op = {
    short = s,
    id = love.math.random(0, 1000000),
    distance = dis
  }
  return op
end

function contains(set, key)
  return set[key] ~= nil
end

function getTripleForIDs(table, id1, id2)
  for i, trip in ipairs(table) do
    if(trip.knotA.name == id1 or trip.knotB.name == id1) then
      if(trip.knotA.name == id2 or trip.knotB.name == id2) then
        return trip
      end
    end
  end
  return nil
end

function getIndexForID(table, id)
  for i, knot in ipairs(table) do
    if knot.name == id then
      return i
    end
  end
  return nil
end
