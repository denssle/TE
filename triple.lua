local triplemodul = {}
local tripels = {}
local shortRadius = 180
local mediumRadius = 360

function triplemodul.getTriples()
  return tripels
end

function triplemodul.createTripels(knotens)
  for i, knot in ipairs(knotens) do
    knot.usedInTrip = true
    for j, cknot in ipairs(knotens) do
      if cknot.usedInTrip then
        if knot.id ~= cknot.id then
          triplemodul.createTripel(knot, cknot)
        end
      end
    end
  end
end

function triplemodul.createTripel(knot, knot2)
  options = triplemodul.createOptions(knot, knot2)
  print(knot.name, " - ", knot2.name, "distance", options.distance, "short: ", options.short, "medium", options.medium, "long", options.long)
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
  if triplemodul.getDistance(knot1, knot2) < shortRadius then
    return true
  end
  return false
end

function triplemodul.isMedium(knot1, knot2)
  if triplemodul.getDistance(knot1, knot2) < mediumRadius then
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
  op.medium = triplemodul.isMedium(knotA, knotB)
  if not op.shortRadius and not op.medium then
    op.long = true
  else
    op.long = false
  end
  op.id = love.math.random(2, 748293412) * love.math.random(9, 776345112)+dis..knotA.id..knotB.id
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

function triplemodul.updateTriplesOptions()
  for i, trip in ipairs(tripels) do
    if trip.knotA.killMe or trip.knotB.killMe or trip.dis == 0 then
      trip.option.killMe = true
      table.remove(tripels, i)
    else
      trip.option = triplemodul.createOptions(trip.knotA, trip.knotB)
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

function triplemodul.deleteDeadTriples()
  for i, trip in ipairs(tripels) do
    if trip.option.killMe then
      table.remove(tripels, i)
    end
  end
end


return triplemodul
