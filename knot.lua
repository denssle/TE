local knotenmodul = {}
local knotens = {}

function knotenmodul.getKnotens()
  return knotens
end

function knotenmodul.createKnotens(nbr)
  cacheKnotens = {}
  for i = 1, nbr do
    knot = knotenmodul.createRandomKnot(i)
    table.insert(cacheKnotens, knot)
  end
  return cacheKnotens
end

function knotenmodul.createRandomKnot(name)
  max = love.graphics.getWidth()
  randX = love.math.random(1, max)
  randY = love.math.random(1, max)
  knot = knotenmodul.createKnot(randX, randY, name)
  table.insert(knotens, knot)
  return knot
end

function knotenmodul.createKnot(randX, randY, name)
  print("createKnot", name, "x", randX, "y", randY)
  knot = {}
  knot.x = randX
  knot.y = randY
  knot.name = name
  knot.id = love.math.random(0, 1000000) + love.math.random(0, 1000000)
  knot.check = false
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

function knotenmodul.clickCheck(x, y, param)
  xlow = x - param
  xhigh = x -- + param
  ylow = y - param
  yhigh = y -- + param

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


return knotenmodul
