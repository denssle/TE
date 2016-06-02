local playermodul = {}
local players = {}
local activePlayer = nil
local index = 0

function playermodul.createPlayer(name, red, green, blue)
  index = index + 1

  local player = {}
  player.name = name
  player.actions = 0
  player.id = love.math.random(23, 9921312)..name
  player.index = index
  player.color = {}
  player.color.red = red
  player.color.green = green
  player.color.blue = blue
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

function playermodul.useAction(nbr)
  activePlayer.actions = activePlayer.actions - nbr
end

function playermodul.enoughtActionsLeft(nbr)
  if activePlayer == nil then
    return nil
  end

  if activePlayer.actions >= nbr and activePlayer.actions > 0 then
    return true
  end
  return false
end

function playermodul.nextPlayer()
  if activePlayer ~= nil then
    if activePlayer.index == index then
      activePlayer = players[1]
    else
      activePlayer = players[activePlayer.index + 1 ]
    end
  end
  return activePlayer
end

function playermodul.setActions(nbr)
  activePlayer.actions = activePlayer.actions + nbr
end

function playermodul.deletePlayer(playerID)
  for i, player in pairs(players) do
    if player.id == playerID then
      table.remove(players, i)
    end
  end
end

function playermodul.anyPlayersLeft()
  if table.getn(players) >= 2 then
    return true
  end
  return false
end

return playermodul
