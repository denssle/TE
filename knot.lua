local knotenmodul = {}
local knotens = {}
local knotRadius = 15

function knotenmodul.getKnotens()
  return knotens
end

function knotenmodul.createKnotens(nbr, owner)
  for i = 1, nbr do
    local knot = knotenmodul.createRandomKnot(i, owner)
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

function knotenmodul.getKnotForClick(x, y)
  local xlow = x - knotRadius
  local xhigh = x + 5
  local ylow = y - knotRadius
  local yhigh = y + 5

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
    local coin = math.random(2) == 2 and 1 or -1
    local nbr = 5 * coin
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

function knotenmodul.getActionsOfPlayerID(playerID)
  local nbr = 0
  for i, knot in pairs(knotens) do
    if knot.player.id == playerID then
      nbr = nbr + 1 + knot.farm
    end
  end
  return nbr
end

function knotenmodul.getNumberOfKnotsByID(playerID)
  local nbr = 0
  for i, knot in pairs(knotens) do
    if knot.player.id == playerID then
      nbr = nbr + 1
    end
  end
  return nbr
end

function knotenmodul.drawKnotens(knotIMG)
  local knotens = knotenmodul.getKnotens()
  for i, knot in ipairs(knotens) do
    if not knot.killMe then
      if knot.check then
        love.graphics.setColor(255, 0, 0)
      else
        love.graphics.setColor(knot.player.color.red, knot.player.color.green, knot.player.color.blue)
      end
      love.graphics.draw(knotIMG, knot.x, knot.y)
      love.graphics.print(knot.name, knot.x, knot.y+knotRadius+5)
      drawArmy(knot)
    end
  end
end

function drawArmy(knot)
  if knot.army ~= nil then
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(knot.army.strength, knot.x+knotRadius * 2, knot.y)
  end
  if knot.fortification > 0 then
    love.graphics.setLineWidth( knot.fortification * 2)
    love.graphics.circle( "line", knot.x, knot.y, 20, 25 )
    love.graphics.print("+"..knot.fortification, knot.x+knotRadius * 2, knot.y + 10)
  end
  if knot.farm > 0 then
    love.graphics.print("+"..knot.farm, knot.x+knotRadius * 2, knot.y + 10)
  end
end

return knotenmodul
