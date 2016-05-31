local triplemodul = {}
local tripels = {}
local radius = 200

function triplemodul.getTriples()
  return tripels
end

function triplemodul.createTripels(knotens)
  local cacheKnotens = copyKnotens(knotens)
  for i, knot in ipairs(knotens) do
    for j, cknot in ipairs(cacheKnotens) do
      if knot.id ~= cknot.id then
        triplemodul.createTripel(knot, cknot)
      end
    end
    table.remove(cacheKnotens, 1)
  end
end

function copyKnotens(knotens)
  cacheKnotens = {}
  for i, knot in ipairs(knotens) do
    local cacheKnot = {}
    cacheKnot.x = knot.x
    cacheKnot.y = knot.y
    cacheKnot.name = knot.name
    cacheKnot.id = knot.id
    cacheKnot.check = knot.check
    cacheKnot.killMe = knot.killMe
    cacheKnot.army = knot.army
    cacheKnot.player = knot.player
    cacheKnot.fortification = knot.fortification
    table.insert(cacheKnotens, cacheKnot)
  end
  return cacheKnotens
end

function triplemodul.createTripel(knot, knot2)
  options = triplemodul.createOptions(knot, knot2)
  print(knot.name, " - ", knot2.name, "short: ", options.short, "distance", options.distance, "k1 army", knot.army, "k2 army", knot2.army)
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

function triplemodul.isShort(knot1, knot2)
  if triplemodul.getDistance(knot1, knot2) < radius then
    return true
  end
  return false
end

function triplemodul.createOptions(knotA, knotB)
  local dis = triplemodul.getDistance(knotA, knotB)

  knotCheck = false
  if knotA.check or knotB.check then
    knotCheck = true
  end

  op = {}
  op.short = triplemodul.isShort(knotA, knotB)
  op.id = love.math.random(0, 1000000) * love.math.random(0, 1000000)+dis..knotA.id..knotB.id
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
