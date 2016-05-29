debug = true

local knotenmodul = require "knot"
local triplemodul = require "triple"
local armymodul= require "army"
local buttonmodul = require "button"
local roundmodul = require "round"
local playermodul = require "player"

local knotRadius = 15
local checkedKnotID = nil
local knotIMG = nil

function love.load(arg)
  love.graphics.setBackgroundColor( 100 , 100 , 100 )
  knotIMG = love.graphics.newImage( '/assets/ball.png' )
  buttonIMG = love.graphics.newImage( '/assets/buttonEmpty.png' )
  buttonmodul.createButton(20, 700, buttonIMG, "Next round") -- x, y, img, label

  createPlayers()
  createKnotsAndTripels()
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end
  triplemodul.killTriples()
  triplemodul.updateTriples()
  knotenmodul.killKnots()

  if not playermodul.enoughtActionsLeft() then
    playermodul.nextPlayer()
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
  drawTriples()
  drawRoundsAndPlayerAndFPS()
  drawKnotens()
  drawButtons()
end

function createPlayers()
  red = playermodul.createPlayer("RED")
  blue = playermodul.createPlayer("BLUE")
end

function createKnotsAndTripels()
  -- knotenmodul.deleteAllKnots()
  -- triplemodul.deleteAllTriples()
  --cacheKnotens = knotenmodul.createKnotens(1)
  for i, player in pairs(playermodul.getPlayers()) do
    cacheKnotens = knotenmodul.createKnotens( 2 , player )
    knotens = knotenmodul.getKnotens()
    triplemodul.createTripels(cacheKnotens, knotens)
  end
  print("Knots & Triples erstellt. ")
end

function drawTriples()
  local triples = triplemodul.getTriples()
  if triples  ~= nil then
    for i, trip in ipairs(triplemodul.getTriples()) do
      if not trip.killMe then
        love.graphics.setColor(0, 0, 255)
        if trip.option.short then
          love.graphics.setColor(255, 0, 0)
        end

        love.graphics.setLineWidth( 1 )
        if trip.option.check then
          love.graphics.setLineWidth( 3 )
          love.graphics.setColor(0, 250, 0)
        end
        love.graphics.line(trip.knotA.x, trip.knotA.y, trip.knotB.x, trip.knotB.y)
      end
    end
  end
end

function drawRoundsAndPlayerAndFPS()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  love.graphics.print("Round: "..tostring(roundmodul.getRound()), 10, 20)
  love.graphics.print("Player: "..tostring(playermodul.getActivPlayer().name), 10, 30)
  love.graphics.print("Actions: "..tostring(playermodul.getActivPlayer().actions), 10, 40)
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
    -- love.graphics.circle( "line", knot.x, knot.y, knotRadius * 1.5, 25 )
    love.graphics.print(knot.army.strength, knot.x+knotRadius * 2, knot.y)
  end
end

function drawButtons()
  local buttons = buttonmodul.getButtons()
  love.graphics.setColor(255, 255, 255)
  for i, buttn in ipairs(buttons) do
    love.graphics.draw(buttn.img, buttn.x, buttn.y)
    love.graphics.print(buttn.label, buttn.x + (buttn.width / 10), buttn.y+ (buttn.height / 3))
  end
end

function createKnot(x, y)
  name = "x "..x.." y "..y
  knot = knotenmodul.createKnot(x, y, name)
  integradeKnot(knot)
end

function createRandomKnotWithTriple()
  knot = knotenmodul.createRandomKnot()
  integradeKnot(knot)
end

function integradeKnot(knot)
  newKnot = {}
  table.insert(newKnot, knot)
  cacheKnotens = knotenmodul.getKnotens()
  triplemodul.createTripels(cacheKnotens, newKnot)
end

--[[
function deleteClickedKnot(knot)
  if(knot ~= nil) then
    knotenmodul.deleteKnot(knot)
    triplemodul.deleteTriplesFromKnot(knot)
  end
end
]]--

function leftClick(clickedKnot, x,y)
  knotenmodul.uncheckAll()
  if checkedKnotID ~= nil then --We have a checked Knot
    leftClickCheckedKnot(clickedKnot, x,y)
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

function leftClickCheckedKnot(clickedKnot, x,y)
  checkedKnot = knotenmodul.getKnotByID(checkedKnotID)
  if checkedKnot ~= nil and checkedKnot.army ~= nil then
    if checkedKnot.player.id == playermodul.getActivPlayer().id then
      moveCheckedArmy(checkedKnot, clickedKnot, x, y)
    end
  end
  checkedKnotID = nil
end

function leftClickNoCheckedKnot(clickedKnot, x,y)
  if clickedKnot ~= nil then --We clicked a knot
    clickedKnot.check = true --we check the knot
    checkedKnotID = knot.id
  else --Click button or nothing
    local btn = buttonmodul.getButtonForClick(x, y)
    if btn ~= nil then --nothing clicked
      handleButton(btn)
    end
  end
end

function moveCheckedArmy(checkedKnot, clickedKnot, x, y)
  destination = clickedKnot --knotenmodul.getKnotForClick(x, y, knotRadius)
  if destination ~= nil and destination.id ~= checkedKnot.id then
    armymodul.moveArmy(destination, checkedKnot)
    playermodul.makeAction()
  end
end

function createArmy(knot)
  playermodul.makeAction()
  newArmy = armymodul.createArmy(knot)
  knot.army = newArmy
end

function updateArmy(knot)
  playermodul.makeAction()
  knot.army.strength = knot.army.strength + 1
end

function handleButton(btn)
  if btn ~= nil then
    if btn.label == "Next round" then
      nextRound()
    end
  end
end

function nextRound()
  roundmodul.incrementRound()
  playermodul.nextPlayer()
end
