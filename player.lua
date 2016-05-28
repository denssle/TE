local playermodul = {}
local players = {}
local activePlayer = nil

function playermodul.createPlayer(name)
  local player = {}
  player.name = name
  player.actions = 1

  player.color = {}
  player.color.red = love.math.random(0, 255)
  player.color.green = love.math.random(0, 255)
  player.color.blue = love.math.random(0, 255)
  table.insert(players, player)
  activePlyer = player
end

function playermodul.getActivPlayer()
  return activePlyer
end

function playermodul.getPlayers()
  return players
end

function playermodul.makeAction()
  activePlayer.actions = activePlayer.actions - 1
  if activePlayer.actions <= 0 then
    activePlayer.actions = 2
    playermodul.nextPlayer()
    return true
  end
  return false
end


return playermodul
