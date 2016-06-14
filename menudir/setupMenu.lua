local c = require "statics"
local buttonmodul = require "button"

local setUp = {}
local sliders = {}
local buttons = {}
local done = nil
local playermodul = nil

function setUp.init()
  --buttonmodul.createMenuButton(c.continue, false)
  buttonmodul.createSlider(sliders, 400, 5)
  local cont = buttonmodul.createButton(10, 300, c.continue, true)
  buttons[cont.id] = cont
end

function setUp.start(pm)
  done = false
  playermodul = pm
end

function setUp.stop()
  done = true
end

function setUp.done()
  return done
end

function setUp.draw()
  buttonmodul.drawSliders(sliders)
  buttonmodul.drawButtons(buttons, false)
end

function setUp.leftClick(x, y)
  local btn = buttonmodul.getButtonForClick(buttons, x, y)
  if btn ~= nil then --button clicked
    setUp.handeMenuButton(btn)
  else
    buttonmodul.getSliderButtonForClick(sliders, x, y)
  end
end

function setUp.handeMenuButton(btn)
  if btn ~= nil then
    if btn.label == c.continue then
      print("handle", btn.label)
      setUp.stop()
    end
  end
end

function setUp.getPlayerModul()
  return playermodul
end

return setUp
