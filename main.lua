debug = true
local utf8 = require("utf8")
local menumodul = require "menu"
local gamemodul = require "game"
local c = require "statics"

--local knotCursor = nil
--local normalCursor = nil
local knotIMG = nil
local buttonIMG = nil
local inGame = false
local inMenu = false
local text = nil

function love.load(arg)
  love.graphics.setBackgroundColor( 100 , 100 , 100 )
  knotIMG = love.graphics.newImage( '/assets/ball.png' )
  buttonIMG = love.graphics.newImage( '/assets/buttonEmpty.png' )
  colors = {}
  colors.red = love.graphics.newImage( '/assets/red.png' )
  colors.green = love.graphics.newImage( '/assets/green.png' )
  colors.blue = love.graphics.newImage( '/assets/blue.png' )
  
  --normalCursor = love.mouse.getSystemCursor("arrow")
  --knotCursor = love.mouse.getSystemCursor("crosshair")
  --love.mouse.setCursor(normalCursor)

  inMenu = true
  menumodul.initMenu(buttonIMG, colors)
end

function love.update(dt)
  if inGame then
    gamemodul.update()
  elseif inMenu then
    if menumodul.update() then
      inGame = true
      inMenu = false
      gamemodul.initGame(menumodul.getPlayerModul(), buttonIMG, knotIMG)
    end
  end
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 then -- the primary button
     leftClick(x,y)
   end
   if button == 2 then
     rightClick(x,y)
   end
end

function love.draw(dt)
  if inGame then
    gamemodul.draw()
  elseif inMenu then
    menumodul.draw()
  else --GAME OVER
    drawMessage("GAME OVER\nTHE WINNER IS: "..tostring(playermodul.getActivPlayer().name))
  end
end

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

function leftClick(x,y)
  if inGame then
    gamemodul.leftClick(x, y)
  elseif inMenu then
    menumodul.leftClick(x, y)
  end
end

function rightClick(x, y)
  if inGame then
    gamemodul.rightClick(x, y)
  elseif inMenu then
    menumodul.rightClick(x, y)
  end
end
