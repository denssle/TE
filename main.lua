debug = true

local utf8 = require("utf8")

local knotenmodul = require "knot"
local triplemodul = require "triple"
local armymodul= require "army"
local buttonmodul = require "button"
local roundmodul = require "round"
local playermodul = require "player"
local c = require "statics"

local knotCursor = nil
local normalCursor = nil
local checkedKnotID = nil
local knotIMG = nil
local buttonIMG = nil
local text = nil
local ready = false
local knotRadius = 15

function love.load(arg)
  love.graphics.setBackgroundColor( 100 , 100 , 100 )
  knotIMG = love.graphics.newImage( '/assets/ball.png' )
  buttonIMG = love.graphics.newImage( '/assets/buttonEmpty.png' )
  -- 'normal' buttons
  buttonmodul.createButton(buttonIMG, c.nextRound, false) -- img, label, knot kontext
  buttonmodul.createButton(buttonIMG, c.createKnot, false)
  -- kontext buttons
  buttonmodul.createButton(buttonIMG, c.buildFort, true)
  buttonmodul.createButton(buttonIMG, c.updateArmy, true)
  buttonmodul.createButton(buttonIMG, c.buildFarm, true)

  normalCursor = love.mouse.getSystemCursor("arrow")
  knotCursor = love.mouse.getSystemCursor("crosshair")
  love.mouse.setCursor(normalCursor)

  createPlayers()
  createKnotsAndTripels()
  ready = true
end

-- text
function love.textinput(t)
    local text = text .. t
end

function love.keypressed(key)
    if key == c.backspace then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, byteoffset - 1)
        end
    end
    if key == c.escape then
      love.event.push(c.quit)
    end
end

function love.update(dt)
  if ready then
    if playermodul.anyPlayersLeft() then
      triplemodul.deleteDeadTriples()
      triplemodul.updateTriplesOptions()
      knotenmodul.deleteDeadKnots()

      local knotsOfActivPlayer = knotenmodul.getActionsOfPlayerID(playermodul.getActivPlayer().id)
      if knotsOfActivPlayer <= 0 then
        print("No knots left; deletePlayer", playermodul.getActivPlayer().name)
        playermodul.deletePlayer(playermodul.getActivPlayer().id)
        nextRound()
      end
      if not playermodul.enoughtActionsLeft(0) then
        nextRound()
      end
    else
      ready = false --stopp the game
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  local clickedKnot = knotenmodul.getKnotForClick(x, y, knotRadius)
   if button == 1 then -- the primary button
     leftClick(clickedKnot, x,y)
   end
   if button == 2 then
     rightClick(clickedKnot, x,y)
   end
end

function love.draw(dt)
  if ready then
    drawTriples()
    drawRoundsAndPlayerAndFPS()
    drawKnotens()
    drawButtons()
  else --GAME OVER
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("GAME OVER\nTHE WINNER IS: "..tostring(playermodul.getActivPlayer().name), love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  end
end

function createPlayers()
  red = playermodul.createPlayer("RED", 255, 0, 0)
  blue = playermodul.createPlayer("BLUE", 0, 0, 255)
end

function createKnotsAndTripels()
  for i, player in pairs(playermodul.getPlayers()) do
    knotenmodul.createKnotens( 2 , player )
  end
  knotens = knotenmodul.getKnotens()
  triplemodul.createTripels(knotens)
  print("Knots & Triples erstellt. ")
end

function drawTriples()
  local triples = triplemodul.getTriples()
  if triples  ~= nil then
    love.graphics.setLineWidth( 1 )
    for i, trip in ipairs(triplemodul.getTriples()) do
      if not trip.killMe then
        if trip.option.short then
          love.graphics.setColor(255, 0, 0)
          if trip.option.check then
            love.graphics.setLineWidth( 2 )
          end
          love.graphics.line(trip.knotA.x, trip.knotA.y, trip.knotB.x, trip.knotB.y)
        elseif trip.option.medium then
          love.graphics.setColor(255, 255, 255)
          if trip.option.check then
            love.graphics.setLineWidth( 1 )
          end
          love.graphics.line(trip.knotA.x, trip.knotA.y, trip.knotB.x, trip.knotB.y)
        elseif trip.option.long and trip.option.check then
          love.graphics.setColor(20, 20, 255)
          love.graphics.setLineWidth( 1 )
          love.graphics.line(trip.knotA.x, trip.knotA.y, trip.knotB.x, trip.knotB.y)
        end
      end
    end
  end
end

function drawRoundsAndPlayerAndFPS()
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

function drawKnotens()
  local knotens = knotenmodul.getKnotens()
  for i, knot in ipairs(knotens) do
    if not knot.killMe then
      if knot.check then
        love.graphics.setColor(255, 0, 0)
      else
        love.graphics.setColor(knot.player.color.red, knot.player.color.green, knot.player.color.blue)
      end
      --love.graphics.rectangle("fill", knot.x, knot.y, knotRadius, knotRadius) --( mode, x, y, width, height )
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

function drawButtons()
  local buttons = buttonmodul.getButtons()
  love.graphics.setColor(255, 255, 255)
  for i, buttn in pairs(buttons) do
    if not buttn.knotKontext then -- no a kontext Button
      love.graphics.draw(buttn.img, buttn.x, buttn.y)
      love.graphics.print(buttn.label, buttn.x + (buttn.width / 10), buttn.y+ (buttn.height / 3))
    else
      if checkedKnotID ~= nil then --We have a checked Knot, draw kontext menu
        love.graphics.draw(buttn.img, buttn.x, buttn.y)
        love.graphics.print(buttn.label, buttn.x + (buttn.width / 10), buttn.y+ (buttn.height / 3))
      end
    end
  end
end

function createKnotInGame(player)
  local nbr = knotenmodul.getNumberOfKnotsByID(player.id) + 1
  knot = knotenmodul.createRandomKnot(nbr, player)
  newKnot = {}
  table.insert(newKnot, knot)
  cacheKnotens = knotenmodul.getKnotens()
  triplemodul.createTripels(cacheKnotens, newKnot)
end

function leftClick(clickedKnot, x,y)
  knotenmodul.uncheckAll()
  local btn = buttonmodul.getButtonForClick(x, y)
  if btn ~= nil then --button clicked
    handleButton(btn)
  end
  if checkedKnotID ~= nil then --We have a checked Knot
    leftClickCheckedKnot(clickedKnot)
  else -- No checked Knot
    leftClickNoCheckedKnot(clickedKnot, x,y)
  end
end

function rightClick(clickedKnot, x, y)
  if clickedKnot ~= nil  and clickedKnot.player.id == playermodul.getActivPlayer().id then -- we rclicked a knot
    if clickedKnot.army ~= nil then
      updateArmy(clickedKnot)
    else
      createArmy(clickedKnot)
    end
  end
end

function leftClickCheckedKnot(clickedKnot)
  checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
  if checkedKnot ~= nil and checkedKnot.army ~= nil then
    if checkedKnot.player.id == playermodul.getActivPlayer().id then
      moveCheckedArmy(checkedKnot, clickedKnot)
    end
  end
  checkedKnotID = nil
end

function leftClickNoCheckedKnot(clickedKnot, x,y)
  if clickedKnot ~= nil then --We clicked a knot
    clickedKnot.check = true --we check the knot
    checkedKnotID = knot.id
  end
end

function moveCheckedArmy(checkedKnot, clickedKnot)
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

function createArmy(knot)
  if knot.player.actions >= 2 then
    playermodul.useAction(2)
    local newArmy = armymodul.createArmy(knot)
    knot.army = newArmy
  end
end

function updateArmy(knot)
  if knot.player.actions >= 2 then
    playermodul.useAction(2)
    knot.army.strength = knot.army.strength + 1
  end
end

function handleButton(btn)
  if btn ~= nil then
    if btn.label == c.nextRound then
      nextRound()
    end
    if btn.label == c.createKnot then
      createKnotInGame(playermodul.getActivPlayer())
      playermodul.useAction(1)
    end
    if checkedKnotID ~= nil then
      handleKontextButtons(btn)
    end
  end
end

function handleKontextButtons(btn)
  local checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
  if btn.label == c.buildFort then
    if checkedKnot.player.id == playermodul.getActivPlayer().id then
      fortificateKnot(checkedKnot)
    end
  end
  if btn.label == c.updateArmy then
    if checkedKnot.army ~= nil then
      updateArmy(checkedKnot)
    else
      createArmy(checkedKnot)
    end
  end
  if btn.label == c.buildFarm then
    farmificateKnot(checkedKnot)
  end
end

function nextRound()
  local nextPlayer = playermodul.nextPlayer()
  local nbr = knotenmodul.getActionsOfPlayerID(nextPlayer.id)
  playermodul.setActions(nbr)
  roundmodul.incrementRound()
end

function fortificateKnot(checkedKnot)
  if checkedKnot.farm <= 0 then
    checkedKnot.fortification = checkedKnot.fortification + 1
    playermodul.useAction(1)
  end
end

function farmificateKnot(checkedKnot)
  if checkedKnot.fortification <= 0 then
    checkedKnot.farm = checkedKnot.farm + 1
    playermodul.useAction(1)
  end
end
