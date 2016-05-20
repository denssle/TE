local knotenmodul = {}
knotens = {}

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
  knot = {}
  knot.x = randX
  knot.y = randY
  knot.name = name
  knot.body = love.physics.newBody(world, randX, randY, "static") -- dynamic or static
  knot.shape = love.physics.newRectangleShape(25,25)         -- set size to 25,25 (x,y)
  knot.fix = love.physics.newFixture(knot.body, knot.shape)
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

function knotenmodul.moveAllKnotsALittle()
  for i, knot in ipairs(knotens) do
    coin = math.random(2) == 2 and 1 or -1
    nbr = 5 * coin
    knot.x = knot.x + nbr
    knot.y = knot.y + nbr
  end
end

return knotenmodul