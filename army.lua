local armymodul = {}
local armys = {}

function armymodul.getArmys()
  return armys
end

function armymodul.createArmy(knot)
  local army = {}
  army.id = love.math.random(0, 1000000) * love.math.random(0, 1000000)..knot.player.name..knot.id
  army.strength = 1
  army.knot = knot
  army.player = knot.player
  armys[army.id] = army
  return army
end

function armymodul.createArmyFromOld(id, strength, player, knot)
  local army = {}
  army.id = id
  army.strength = strength
  army.knot = knot
  army.player = player
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
  if destination.army == nil then -- no army at the destination
    print("move")
    local a = knot.army
    armymodul.removeArmy(a)
    local newarmy = armymodul.createArmyFromOld(a.id, a.strength, a.player, destination)
    destination.army = newarmy
    knot.army = nil
    destination.player = knot.player
  elseif destination.player.id == knot.player.id then -- destination belongs to the player
    armymodul.combineForces(destination, knot)
    destination.player = knot.player
  else
    armymodul.fight(destination, knot)
  end
end

function armymodul.combineForces(destination, knot)
  local da = destination.army
  local ka = destination.army
  print("combineForces", "destination", da.strength, "origin", ka.strength)
  da.strength = da.strength + ka.strength
  armymodul.removeArmy(ka)
  knot.army = nil
end

function armymodul.fight(destination, knot)
  print("fight")
  -- die angreifer können überlegen, gleichstark oder unterlegen sein
  fort = destination.fortification
  defArmy = destination.army
  attacArmy = knot.army
  defSum = destination.fortification + defArmy.strength
  if defSum  < attacArmy.strength then
    print("angreifer erobert destination")
    defArmy.strength = attacArmy.strength - defArmy.strength
    armymodul.removeArmy(defArmy)
    destination.player = knot.player
    destination.fortification = 0
    knot.army = nil
  elseif defSum == attacArmy.strength then
    print("gleichstark")
    destination.army = nil
    knot.army = nil
    armymodul.removeArmy(defArmy)
    armymodul.removeArmy(attacArmy)
    destination.fortification = 0
  else
    print("angreifer verliert")
    deltaDamage = attacArmy.strength - fort
    if deltaDamage <= 0 then -- fort hat alles aufgehalten
      destination.fortification = destination.fortification - attacArmy.strength
    else
      destination.fortification = 0
      defArmy.strength = defArmy.strength - deltaDamage
    end
    knot.army = nil
    armymodul.removeArmy(attacArmy)
  end
end

return armymodul
