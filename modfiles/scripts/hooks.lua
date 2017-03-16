
package.path = package.path .. ";modfiles/scripts/?.lua"
package.path = package.path .. ";modfiles/config/?.lua"

require ("main")
require ("StationGenerator")
config = require ("config")

--data/scripts/player/eventscheduler.lua
function updateServerHook(timeStep)
    if config.debug then print("updateServerHook"..timeStep) end
    if onServer() then
        iteration(timeStep)
    else
        print("Not on Server, not calling iteration")        
    end
end

--data/scripts/player/eventscheduler.lua
function initializeHook()
    if config.debug then print("initializeHook") end
    if onServer() then
	local player = Player()
        if not validData(player) then
            initPlayerData(player)
        end
    end
end

--data/scripts/lib/SectorGenerator.lua
--    --Inserted Hook
      --onGenerateAsteroidFiledHook(mat)
function onGenerateAsteroidFieldHook(position)
    if config.debug then print("onGenerateAsteroidFieldHook") end
    if math.random(1,100)/100 < config.probabilityPerAsteroidField then
        print("Generated claimable Mine")
        generateClaimableMine(position)
    end
end
