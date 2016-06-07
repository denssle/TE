local knotenmodul = require "knot"
local triplemodul = require "triple"
local armymodul= require "army"
local roundmodul = require "round"
local buttonmodul = require "button"
local c = require "statics"

local gamemodul = {}
local playermodul = nil
local knotIMG = nil
local checkedKnotID = nil
local ready = false

function gamemodul.initGame(pm, buttonIMG, kIMG)
  print("Init Game!")
  playermodul = pm
  knotIMG = kIMG
  -- 'normal in game' buttons
  buttonmodul.createInGameButton(buttonIMG, c.nextRound, false) -- img, label, knot kontext
  buttonmodul.createInGameButton(buttonIMG, c.createKnot, false)
  -- kontext buttons
  buttonmodul.createInGameButton(buttonIMG, c.updateArmy, true)
  buttonmodul.createInGameButton(buttonIMG, c.buildFort, true)
  buttonmodul.createInGameButton(buttonIMG, c.buildFarm, true)
  gamemodul.createKnotsAndTripels()
  ready = true
end

function gamemodul.update()
  if ready then
    if playermodul.anyPlayersLeft() then
      triplemodul.deleteDeadTriples()
      triplemodul.updateTriplesOptions()
      knotenmodul.deleteDeadKnots()

      local knotsOfActivPlayer = knotenmodul.getActionsOfPlayerID(playermodul.getActivPlayer().id)
      if knotsOfActivPlayer <= 0 then
        print("No knots left; deletePlayer", playermodul.getActivPlayer().name)
        playermodul.deletePlayer(playermodul.getActivPlayer().id)
        gamemodul.nextRound()
      end
      if not playermodul.enoughtActionsLeft(0) then
        gamemodul.nextRound()
      end
    end
  end
end

function gamemodul.draw()
  if ready then
    gamemodul.drawRoundsAndPlayerAndFPS()
    gamemodul.drawClickedKnotStats()
    triplemodul.drawTriples()
    knotenmodul.drawKnotens(knotIMG)
    local buttons = buttonmodul.getInGameButtons()
    buttonmodul.drawButtons(buttons, checkedKnotID)
  end
end

function gamemodul.createKnotsAndTripels ()
  for i, player in pairs(playermodul.getPlayers()) do
    knotenmodul.createKnotens( 2 , player )
  end
  knotens = knotenmodul.getKnotens()
  triplemodul.createTripels(knotens)
  print("Knots & Triples erstellt. ")
end


function gamemodul.createKnotInGame (player)
  local nbr = knotenmodul.getNumberOfKnotsByID(player.id) + 1
  knot = knotenmodul.createRandomKnot(nbr, player)
  newKnot = {}
  table.insert(newKnot, knot)
  cacheKnotens = knotenmodul.getKnotens()
  triplemodul.createTripels(cacheKnotens, newKnot)
end

function gamemodul.leftClick(x, y)
  knotenmodul.uncheckAll()
  local btn = buttonmodul.getInGameButtonForClick(x, y)
  if btn ~= nil then --button clicked
    gamemodul.handleInGameButton(btn)
  else
    local clickedKnot = knotenmodul.getKnotForClick(x, y)
    if checkedKnotID ~= nil then --We have a checked Knot
      gamemodul.leftClickCheckedKnot(clickedKnot)
    else -- No checked Knot
      gamemodul.leftClickNoCheckedKnot(clickedKnot, x,y)
    end
  end
end

function gamemodul.leftClickCheckedKnot (clickedKnot)
  checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
  if checkedKnot ~= nil and checkedKnot.army ~= nil then
    if checkedKnot.player.id == playermodul.getActivPlayer().id then
      gamemodul.moveCheckedArmy(checkedKnot, clickedKnot)
    end
  end
  checkedKnotID = nil
end

function gamemodul.leftClickNoCheckedKnot (clickedKnot, x,y)
  if clickedKnot ~= nil then --We clicked a knot
    clickedKnot.check = true --we check the knot
    checkedKnotID = knot.id
  end
end


function gamemodul.moveCheckedArmy  (checkedKnot, clickedKnot)
  if checkedKnot ~= nil and clickedKnot ~= nil then
    local triple = triplemodul.getTriple(checkedKnot, clickedKnot)
    if triple ~= nil and clickedKnot.id ~= checkedKnot.id then
      if playermodul.enoughtActionsLeft(triple.option.expense) then
        playermodul.useAction(triple.option.expense)
        armymodul.moveArmy(clickedKnot, checkedKnot)
      end
    end
  end
end

function gamemodul.createArmy  (knot)
  if knot.player.actions >= 2 then
    playermodul.useAction(2)
    local newArmy = armymodul.createArmy(knot)
    knot.army = newArmy
  end
end

function gamemodul.updateArmy (knot)
  if knot.player.actions >= 2 then
    playermodul.useAction(2)
    knot.army.strength = knot.army.strength + 1
  end
end

function gamemodul.handleInGameButton  (btn)
  if btn ~= nil then
    if btn.label == c.nextRound then
      gamemodul.nextRound()
    end
    if btn.label == c.createKnot then
      gamemodul.createKnotInGame(playermodul.getActivPlayer())
      playermodul.useAction(1)
    end
    if checkedKnotID ~= nil then
      gamemodul.handleInGameKontextButtons(btn)
    end
  end
end

function gamemodul.handleInGameKontextButtons (btn)
  local checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
  if btn.label == c.buildFort then
    if checkedKnot.player.id == playermodul.getActivPlayer().id then
      gamemodul.fortificateKnot(checkedKnot)
    end
  end
  if btn.label == c.updateArmy then
    if checkedKnot.army ~= nil then
      gamemodul.updateArmy(checkedKnot)
    else
      gamemodul.createArmy(checkedKnot)
    end
  end
  if btn.label == c.buildFarm then
    gamemodul.farmificateKnot(checkedKnot)
  end
end

function gamemodul.nextRound ()
  if playermodul.anyPlayersLeft() then
    local nextPlayer = playermodul.nextPlayer()
    local nbr = knotenmodul.getActionsOfPlayerID(nextPlayer.id)
    playermodul.setActions(nbr)
    roundmodul.incrementRound()
  end
end

function gamemodul.fortificateKnot (checkedKnot)
  if checkedKnot.farm <= 0 then
    checkedKnot.fortification = checkedKnot.fortification + 1
    playermodul.useAction(1)
  end
end

function gamemodul.farmificateKnot (checkedKnot)
  if checkedKnot.fortification <= 0 then
    checkedKnot.farm = checkedKnot.farm + 1
    playermodul.useAction(1)
  end
end

function gamemodul.drawRoundsAndPlayerAndFPS  ()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  love.graphics.print("Round: "..tostring(roundmodul.getRound()), 10, 20)
  local player = playermodul.getActivPlayer()
  love.graphics.setColor(player.color.red, player.color.green, player.color.blue)
  --text, x, y, Orientation (radians), Scale factor (x-axis), Scale factor (y-axis), Origin offset (x-axis), Origin offset (y-axis)
  love.graphics.print("Player: "..tostring(player.name), 10, 30, 0, 1, 1)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Actions: "..tostring(player.actions).." / "..knotenmodul.getActionsOfPlayerID(player.id) , 10, 40)
end

function gamemodul.drawClickedKnotStats()
  if checkedKnotID ~= nil then --We have a checked Knot
    local checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
    local player = checkedKnot.player
    local y = 650
    local x = 40
    love.graphics.setColor(player.color.red, player.color.green, player.color.blue)
    love.graphics.print("Knot: "..tostring(checkedKnot.name), x, y) -- text, x, y
    if checkedKnot.army ~= nil then
      love.graphics.print("Army: "..tostring(checkedKnot.army.strength), x + 100, y)
    else
      love.graphics.print("Army: "..0, x + 100, y)
    end
    love.graphics.print("Fort: "..tostring(checkedKnot.fortification), x + 200, y)
    love.graphics.print("Farm: "..tostring(checkedKnot.farm), x + 300, y)
  end
end

function gamemodul.drawMessage (msg)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(msg, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

return gamemodul
