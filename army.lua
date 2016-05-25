local armymodul = {}
local armys = {}

function armymodul.getArmys()
  return armys
end

function armymodul.createArmy(knot)
  local army = {}
  army.id = love.math.random(0, 1000000) * love.math.random(0, 1000000)
  army.strength = 1
  army.knot = knot
  table.insert(armys, army)
  return army
end

function armymodul.createArmyFromOld(id, strength, knot)
  local army = {}
  army.id = id
  army.strength = strength
  army.knot = knot
  table.insert(armys, army)
  return army
end

function armymodul.removeArmy(delarmy)
  for i, army in ipairs(armys) do
    if army.id == delarmy.id then
      table.remove(armys, i)
    end
  end
end

function armymodul.moveArmy(destination, knot)
  print("d army", destination.army, "k army", knot.army)
  local a = knot.army
  armymodul.removeArmy(a)
  local newarmy = armymodul.createArmyFromOld(a.id, a.strength, destination)
  destination.army = newarmy
  knot.army = nil
  print("d army", destination.army, "k army", knot.army)
end

function armymodul.combineForces(destination, knot)
  local da = destination.army
  local ka = destination.army
  da.strength = da.strength + ka.strength
  armymodul.removeArmy(ka)
  knot.army = nil
end

return armymodul
