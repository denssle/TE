local c = require "statics"
local startmodul = require "/menudir/startMenu"
local setupmodul = require "/menudir/setupMenu"

local menumodul = {}
local playermodul = nil

function menumodul.initMenu(colors)
  startmodul.init(colors)
  setupmodul.init()
end

function menumodul.update()
  if startmodul.done() and setupmodul.done() == nil then
    setupmodul.start(startmodul.getPlayerModul())
  elseif startmodul.done() and setupmodul.done() then
    playermodul = setupmodul.getPlayerModul()
    return true -- returns true if Menu is done
  end
end

function menumodul.getPlayerModul()
  return playermodul
end

function menumodul.draw()
  if not startmodul.done() then
    startmodul.draw()
  elseif startmodul.done() and not setupmodul.done() then
    setupmodul.draw()
  end
end

function menumodul.leftClick(x, y)
  if not startmodul.done() then
    startmodul.leftClick(x, y)
  elseif startmodul.done() and not setupmodul.done() then
    setupmodul.leftClick(x, y)
  end
end

function menumodul.rightClick(x, y)
end

return menumodul
