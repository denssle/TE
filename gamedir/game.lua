local knotenmodul = require "/gamedir/knot"
local triplemodul = require "/gamedir/triple"
local armymodul= require "/gamedir/army"
local roundmodul = require "/gamedir/round"
local buttonmodul = require "button"
local administrationmodul = require "/gamedir/popUps/administrationPopUp"
local knotStatsmodul = require "/gamedir/popUps/knotStatsPopUp"
local c = require "statics"

local gamemodul = {}
local buttons = {}
local playermodul = nil
local knotIMG = nil
local checkedKnotID = nil
local ready = false
local activPopUp = nil

function gamemodul.initGame(pm, kIMG)
  print("Init Game!")
  playermodul = pm
  knotIMG = kIMG
  gamemodul.createButtons()
  gamemodul.createKnotsAndTripels()
  administrationmodul.init()
  knotStatsmodul.init()
  ready = true
end

function gamemodul.createButtons()
  -- 'normal' in game buttons
  local nr = buttonmodul.createButton(300, 200, c.nextRound, false) -- createButton(xi, yi, label, kontext)
  buttons[nr.id] = nr
  local ck = buttonmodul.createButton(300, 300, c.createKnot, false)
  buttons[ck.id] = ck
  local ad = buttonmodul.createButton(300, 400, c.administration, false)
  buttons[ad.id] = ad
  -- kontext buttons
  local info = buttonmodul.createButton(300, 500, c.info, true)
  buttons[info.id] = info
end

function gamemodul.update()
  if ready then
    if playermodul.anyPlayersLeft() then
      knotenmodul.deleteDeadKnots()
      triplemodul.deleteDeadTriples()
      triplemodul.updateTriplesOptions()

      local knotsOfActivPlayer = knotenmodul.getActionsOfPlayerID(playermodul.getActivPlayer().id)
      if knotsOfActivPlayer <= 0 then
        print("No knots left; deletePlayer", playermodul.getActivPlayer().name)
        playermodul.deletePlayer(playermodul.getActivPlayer().id)
        gamemodul.nextRound()
      end
      if not playermodul.enoughtActionsLeft(0) then
        gamemodul.nextRound()
      end
    else -- not enought Players left
      ready = false
      print("END THIS SHIT!")
    end
  end
end

function gamemodul.draw()
  if ready then
    local checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
    if checkedKnot ~= nil then
      checkedKnot.check = true
    end
    if activPopUp ~= nil then --PopUp open
      activPopUp.draw(checkedKnot, playermodul.getActivPlayer())
    else
      gamemodul.drawRoundsAndPlayerAndFPS()
      triplemodul.drawTriples()
      knotenmodul.drawKnotens(knotIMG)
      buttonmodul.drawButtons(buttons, checkedKnotID)
    end
  else
    print("GAME IS OVER!")
    drawMessage("GAME OVER\nTHE WINNER IS: "..tostring(playermodul.getActivPlayer().name))
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
  local knot = knotenmodul.createRandomKnot(nbr, player)
  local newKnot = {}
  table.insert(newKnot, knot)
  cacheKnotens = knotenmodul.getKnotens()
  triplemodul.createTripels(cacheKnotens, newKnot)
end

function gamemodul.leftClick(x, y)
  knotenmodul.uncheckAll()

  if activPopUp == nil then -- PopUp not open
    local btn = buttonmodul.getButtonForClick(buttons, x, y)
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
  else -- PopUp open
    activPopUp.clickedButton(x, y)
  end
end

function gamemodul.leftClickCheckedKnot (clickedKnot)
  local checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
  if checkedKnot ~= nil and checkedKnot.army ~= nil then
    if checkedKnot.player.id == playermodul.getActivPlayer().id then
      print(checkedKnot.player.id, " VS ", playermodul.getActivPlayer().id)
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

function gamemodul.handleInGameButton (btn)
  print("handleInGameButton", checkedKnotID, btn)
  if btn ~= nil then
    if btn.label == c.nextRound then
      gamemodul.nextRound()
    elseif btn.label == c.createKnot then
      gamemodul.createKnotInGame(playermodul.getActivPlayer())
      playermodul.useAction(1)
    elseif btn.label == c.administration then
      checkedKnotID = nil
      activPopUp = administrationmodul
    elseif checkedKnotID ~= nil then
      gamemodul.handleInGameKontextButtons(btn)
    end
  end
end

function gamemodul.handleInGameKontextButtons (btn)
  print("handleInGameKontextButtons")
  local checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
  if checkedKnot.player.id == playermodul.getActivPlayer().id then
    if btn.label == c.info then
      activPopUp = knotStatsmodul
    elseif activPopUp then
      if btn.label == c.buildFort then
        gamemodul.fortificateKnot(checkedKnot)
      elseif btn.label == c.updateArmy then
        if checkedKnot.army ~= nil then
          gamemodul.updateArmy(checkedKnot)
        else
          gamemodul.createArmy(checkedKnot)
        end
      elseif btn.label == c.buildFarm then
        gamemodul.farmificateKnot(checkedKnot)
      end
    end
  end
end

function gamemodul.nextRound ()
  print("Next round")
  if playermodul.anyPlayersLeft() then
    local checkedKnotID = nil
    local activPopUp = false
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

function gamemodul.rightClick(x, y)
  print("Game rightClick")
end

return gamemodul
