local roundmodul = {}
local round = 0

function roundmodul.getRound()
  return round
end

function roundmodul.incrementRound()
  round = round +1
end

return roundmodul
