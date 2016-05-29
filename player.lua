local playermodul = {}
local players = {}
local activePlayer = nil
local index = 0

function playermodul.createPlayer(name)
  index = index + 1

  local player = {}
  player.name = name
  player.actions = 2
  player.id = love.math.random(23, 9921312)..name
  player.index = index
  player.color = {}
  player.color.red = love.math.random(0, 255)
  player.color.green = love.math.random(0, 255)
  player.color.blue = love.math.random(0, 255)
  players[index] = player
  activePlayer = player
end

function playermodul.getActivPlayer()
  return activePlayer
end

function playermodul.getPlayers()
  return players
end

function playermodul.makeAction()
  activePlayer.actions = activePlayer.actions - 1
end

function playermodul.enoughtActionsLeft()
  if activePlayer == nil then
    return nil
  end

  if activePlayer.actions <= 0 then
    return false
  end
  return true
end

function playermodul.nextPlayer()
  if activePlayer ~= nil then
    activePlayer.actions = 2
    if activePlayer.index == index then
      activePlayer = players[1]
    else
      activePlayer = players[activePlayer.index + 1 ]
    end
  end
end

return playermodul
