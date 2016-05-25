local triplemodul = {}
local tripels = {}
local radius = 120

function triplemodul.getTriples()
  return tripels
end

function triplemodul.createTripels(cacheKnotens, knotens)
  for i, knot in ipairs(knotens) do
    for j, knot2 in ipairs(cacheKnotens) do
      if knot.id ~= knot2.id then
        triplemodul.createTripel(knot, knot2)
      end
    end
    table.remove(cacheKnotens, knot.id)
  end
end

function triplemodul.createTripel(knot, knot2)
  dis = triplemodul.getDistance(knot, knot2)
  options = triplemodul.createOptions(dis)
  print(knot.name, " - ", knot2.name, "short: ", options.short, "distance", dis)
  trip = {}
  trip.knotA = knot
  trip.knotB = knot2
  trip.killMe = false
  trip.option = options
  table.insert(tripels, trip)
  return trip
end

function triplemodul.getDistance(knot1, knot2)
  x1 = knot1.x
  x2 = knot2.x
  y1 = knot1.y
  y2 = knot2.y
  distance = ((x2-x1)^2+(y2-y1)^2)^0.5
  return math.ceil(distance)
end

function triplemodul.createOptions(dis)
  s = false
  if(dis < radius) then
    s = true
  end

  op = {}
  op.short = s
  op.id = love.math.random(0, 1000000) * love.math.random(0, 1000000)
  op.distance = dis

  return op
end

function triplemodul.getRandomTriple()
  max = table.getn(tripels) + 1
  nbr = love.math.random(0, max)
  trip = tripels[nbr]
  if trip == nil then
    trip = getRandomTriple()
  end
  return trip
end

function triplemodul.updateTriple(triple)
  trip = {}
  trip.knotA = triple.knotA
  trip.knotB = triple.knotB

  dis = getDistance(triple.knotA, triple.knotB)
  options = createOptions(dis)

  print("old", triple.option.distance, "neu", dis)

  trip.option = options
  return trip
end

function triplemodul.updateTriples()
  for i, trip in ipairs(tripels) do
    if trip.knotA.killMe or trip.knotB.killMe then
      trip.killMe = true
      table.remove(tripels, i)
    else
      dis = triplemodul.getDistance(trip.knotA, trip.knotB)
      options = triplemodul.createOptions(dis)
      trip.option = options
    end
  end
end

function triplemodul.deleteAllTriples()
  for k,v in pairs(tripels) do tripels[k]=nil end --delete all tripels
end

function triplemodul.deleteTriplesFromKnot(knot)
  for i, trip in ipairs(tripels) do
    if trip.knotA.id == knot.id or trip.knotB.id == knot.id then
      trip.killMe = true
      table.remove(tripels, i)
    end
  end
end

function triplemodul.killTriples()
  for i, trip in ipairs(tripels) do
    if trip.killMe then
      table.remove(tripels, i)
    end
  end
end


return triplemodul
