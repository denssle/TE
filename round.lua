local roundmodul = {}
local round = 1

function roundmodul.getRound()
  return round
end

function roundmodul.incrementRound()
  round = round +1
end

return roundmodul
