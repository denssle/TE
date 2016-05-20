local triplemodul = {}

tripels = {}

function triplemodul.createTripels(cacheKnotens)
  for i, knot in ipairs(knotens) do
    for j, knot2 in ipairs(cacheKnotens) do
      if knot.name ~= knot2.name then
        trip = triplemodul.createTripel(knot, knot2)
        table.insert(tripels, trip)
      end
    end
    k = triplemodul.getIndexForID(cacheKnotens, knot.name)
    table.remove(cacheKnotens, k)
  end
end

function triplemodul.createTripel(knot, knot2)
  dis = triplemodul.getDistance(knot, knot2)
  options = triplemodul.createOptions(dis)
  print(knot.name, " - ", knot2.name, "short: ", options.short, "distance", dis)
  trip = {}
  trip.knotA = knot
  trip.knotB = knot2
  trip.option = options
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
  op.id = love.math.random(0, 1000000)
  op.distance = dis

  return op
end

function contains(set, key)
  return set[key] ~= nil
end

function triplemodul.getTripleForIDs(table, id1, id2)
  for i, trip in ipairs(table) do
    if(trip.knotA.name == id1 or trip.knotB.name == id1) then
      if(trip.knotA.name == id2 or trip.knotB.name == id2) then
        return trip
      end
    end
  end
  return nil
end

function triplemodul.getIndexForID(table, id)
  for i, knot in ipairs(table) do
    if knot.name == id then
      return i
    end
  end
  return nil
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
    dis = triplemodul.getDistance(trip.knotA, trip.knotB)
    options = triplemodul.createOptions(dis)
    trip.option = options
  end
end

return triplemodul
