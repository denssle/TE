local knotenmodul = {}
local knotens = {}
local img = nil

function knotenmodul.getKnotens()
  return knotens
end

function knotenmodul.createKnotens(nbr, owner)
  for i = 1, nbr do
    knot = knotenmodul.createRandomKnot(i, owner)
  end
end

function knotenmodul.createRandomKnot(i, owner)
  local max = love.graphics.getWidth()
  local randX = love.math.random(50, max - 50)
  local randY = love.math.random(50, max - 200)
  local name = owner.name..i
  return knotenmodul.createKnot(randX, randY, name, owner)
end

function knotenmodul.createKnot(randX, randY, name, owner)
  local knot = {}
  knot.x = randX
  knot.y = randY
  knot.name = name
  knot.id = love.math.random(1, 19283776) + love.math.random(23, 9999123)..name
  knot.check = false
  knot.killMe = false
  knot.usedInTrip = false
  knot.army = nil
  knot.player = owner
  knot.fortification = 0
  knot.farm = 0
  print("createKnot", knot.name, "x", knot.x, "y", knot.y, "id", knot.id)
  table.insert(knotens, knot)
  return knot
end

function knotenmodul.getKnotForXY(x, y)
  for i, knot in ipairs(knotens) do
    if knot.x == x and knot.y == y then
      return knot
    end
  end
  return nil
end

function knotenmodul.getKnotByID(id)
  for i, knot in ipairs(knotens) do
    if knot.id == id then
      return knot
    end
  end
  return nil
end

function knotenmodul.getKnotForClick(x, y, param)
  xlow = x - param
  xhigh = x + 5
  ylow = y - param
  yhigh = y + 5

  for xi = xlow, xhigh, 1 do
    for yi = ylow, yhigh, 1 do
      knot = knotenmodul.getKnotForXY(xi, yi)
      if knot ~= nil then
        return knot
      end
    end
  end
  return nil
end

function knotenmodul.moveAllKnotsALittle()
  for i, knot in ipairs(knotens) do
    coin = math.random(2) == 2 and 1 or -1
    nbr = 5 * coin
    knot.x = knot.x + nbr
    knot.y = knot.y + nbr
  end
end

function knotenmodul.deleteAllKnots()
  for k,v in pairs(knotens) do knotens[k]=nil end --delete all knotens
end

function knotenmodul.addKnot(knot)
  table.insert(knotens, knot)
end

function knotenmodul.uncheckAll()
  for i, knot in pairs(knotens) do
    knot.check = false
  end
end

function knotenmodul.deleteKnot(delknot)
  delknot.killMe = true
  for i, knot in pairs(knotens) do
    if knot.id == delknot.id then
      table.remove(knotens, i)
    end
  end
end

function knotenmodul.deleteDeadKnots()
  for i, knot in ipairs(knotens) do
    if knot.killMe then
       table.remove(knotens, i)
     end
   end
end

function knotenmodul.getNumberOfKnots(playerID)
  local nbr = 0
  for i, knot in pairs(knotens) do
    if knot.player.id == playerID then
      nbr = nbr + 1 + knot.farm
    end
  end
  return nbr
end

return knotenmodul
