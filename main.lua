debug = true
local utf8 = require("utf8")
local menumodul = require "menu"
local gamemodul = require "game"
buttonmodul = require "button"
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

  local minusIMG = love.graphics.newImage( '/assets/minus.png' )
  local plusIMG = love.graphics.newImage( '/assets/plus.png' )
  local sliderPoint = love.graphics.newImage( '/assets/null.png' )


  --normalCursor = love.mouse.getSystemCursor("arrow")
  --knotCursor = love.mouse.getSystemCursor("crosshair")
  --love.mouse.setCursor(normalCursor)
  buttonmodul.init(buttonIMG, plusIMG, minusIMG, sliderPoint)
  inMenu = true
  local colors = createColors()
  menumodul.initMenu(colors)
end

function love.update(dt)
  if inGame then
    gamemodul.update()
  elseif inMenu then
    if menumodul.update() then
      inGame = true
      inMenu = false
      gamemodul.initGame(menumodul.getPlayerModul(), knotIMG)
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
    print("stuff")
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

function createColors()
  local colors = {}
  local red = {}
  red.img = love.graphics.newImage( '/assets/red.png' )
  red.red = 255
  red.green = 0
  red.blue = 0
  colors.red = red

  local green = {}
  green.img = love.graphics.newImage( '/assets/green.png' )
  green.red = 0
  green.green = 255
  green.blue = 0
  colors.green = green

  local blue = {}
  blue.img = love.graphics.newImage( '/assets/blue.png' )
  blue.red = 0
  blue.green = 0
  blue.blue = 255
  colors.blue = blue

  return colors
end
