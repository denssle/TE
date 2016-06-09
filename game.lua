local knotenmodul = require "knot"
local triplemodul = require "triple"
local armymodul= require "army"
local roundmodul = require "round"
local buttonmodul = require "button"
local popupmodul = require "popup"
local c = require "statics"

local gamemodul = {}
local playermodul = nil
local knotIMG = nil
local checkedKnotID = nil
local ready = false
local popupActiv = false

function gamemodul.initGame(pm, buttonIMG, kIMG)
  print("Init Game!")
  playermodul = pm
  knotIMG = kIMG
  -- 'normal' in game buttons
  buttonmodul.createInGameButton(buttonIMG, c.nextRound, false) -- img, label, knot kontext
  buttonmodul.createInGameButton(buttonIMG, c.createKnot, false)
  buttonmodul.createInGameButton(buttonIMG, c.administration, false)
  -- kontext buttons
  buttonmodul.createInGameButton(buttonIMG, c.info, true)
  gamemodul.createKnotsAndTripels()
  popupmodul.init(buttonIMG)
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
    local buttons = buttonmodul.getInGameButtons()
    if popupActiv then
      popupmodul.draw(checkedKnot, playermodul.getActivPlayer())
      local popupButtons = nil
      if checkedKnotID == nil then
        popupButtons = buttonmodul.getAdministrationButtons()
      else
        popupButtons = buttonmodul.getKnotInfoButtons()
      end
      buttonmodul.drawButtons(popupButtons, checkedKnotID)
    else
      gamemodul.drawRoundsAndPlayerAndFPS()
      triplemodul.drawTriples()
      knotenmodul.drawKnotens(knotIMG)
    end
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
  btn = gamemodul.getButton(x, y)
  if btn ~= nil then --button clicked
    gamemodul.handleInGameButton(btn)
  else
    if not popupActiv then
      local clickedKnot = knotenmodul.getKnotForClick(x, y)
      if checkedKnotID ~= nil then --We have a checked Knot
        gamemodul.leftClickCheckedKnot(clickedKnot)
      else -- No checked Knot
        gamemodul.leftClickNoCheckedKnot(clickedKnot, x,y)
      end
    else -- open PopUp
      popupActiv = false
      checkedKnotID = nil
    end
  end
end

function gamemodul.getButton(x, y)
  local btn = nil
  if popupActiv and checkedKnotID == nil then
     btn = buttonmodul.getButtonForClick(buttonmodul.getAdministrationButtons(), x, y)
  elseif popupActiv and checkedKnotID ~= nil and btn == nil then
    btn = buttonmodul.getButtonForClick(buttonmodul.getKnotInfoButtons(), x, y)
  else
    btn = buttonmodul.getInGameButtonForClick(x, y)
  end
  return btn
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

function gamemodul.handleInGameButton  (btn)
  print("handleInGameButton", checkedKnotID, btn)
  if btn ~= nil then
    if btn.label == c.nextRound then
      gamemodul.nextRound()
    elseif btn.label == c.createKnot then
      gamemodul.createKnotInGame(playermodul.getActivPlayer())
      playermodul.useAction(1)
    elseif btn.label == c.administration then
      checkedKnotID = nil
      popupActiv = true
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
      popupActiv = true
    elseif popupActiv then
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
    local popupActiv = false
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

function gamemodul.drawMessage (msg)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(msg, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function gamemodul.rightClick(x, y)

end

return gamemodul
