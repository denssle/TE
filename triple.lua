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
  options = triplemodul.createOptions(knot, knot2)
  print(knot.name, " - ", knot2.name, "short: ", options.short, "distance", dis)
  local trip = {}
  trip.knotA = knot
  trip.knotB = knot2
  trip.option = options
  table.insert(tripels, trip)
  return trip
end

function triplemodul.getDistance(knot1, knot2)
  local x1 = knot1.x
  local x2 = knot2.x
  local y1 = knot1.y
  local y2 = knot2.y
  distance = ((x2-x1)^2+(y2-y1)^2)^0.5
  return math.ceil(distance)
end

function triplemodul.createOptions(knotA, knotB)
  local dis = triplemodul.getDistance(knotA, knotB)

  s = false
  if(dis < radius) then
    s = true
  end

  knotCheck = false
  if knotA.check or knotB.check then
    knotCheck = true
  end

  op = {}
  op.short = s
  op.id = love.math.random(0, 1000000) * love.math.random(0, 1000000)
  op.distance = dis
  op.killMe = false
  op.check = knotCheck
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

  options = createOptions(triple.knotA, triple.knotB)

  print("old", triple.option.distance, "neu", dis)

  trip.option = options
  return trip
end

function triplemodul.updateTriples()
  for i, trip in ipairs(tripels) do
    if trip.knotA.killMe or trip.knotB.killMe then
      trip.option.killMe = true
      table.remove(tripels, i)
    else
      options = triplemodul.createOptions(trip.knotA, trip.knotB)
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
      trip.option.killMe = true
      table.remove(tripels, i)
    end
  end
end

function triplemodul.killTriples()
  for i, trip in ipairs(tripels) do
    if trip.option.killMe then
      table.remove(tripels, i)
    end
  end
end


return triplemodul
