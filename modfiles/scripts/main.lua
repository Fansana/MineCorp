package.path = package.path .. ";modfiles/scripts/?.lua"
package.path = package.path .. ";modfiles/config/?.lua"

config = require("config")

local prefix = "MineCorp_"
local time = 0
local ressources  = {"Iron", "Titanium", "Naonite", "Trinium", "Xanion", "Ognite", "Avorion"}

function initPlayerData(player)
    print("MineCorp Init Player")
    player:setValue(prefix .. "Iron" .. "MineAmount",     config.defaultIronMines)
    player:setValue(prefix .. "Titanium" .. "MineAmount", config.defaultTitaniumMines)
    player:setValue(prefix .. "Naonite" .. "MineAmount",  config.defaultNaoniteMines)
    player:setValue(prefix .. "Trinium" .. "MineAmount",  config.defaultTriniumMines)
    player:setValue(prefix .. "Xanion" .. "MineAmount",   config.defaultXanionMines)
    player:setValue(prefix .. "Ognite" .. "MineAmount",   config.defaultOgniteMines)
    player:setValue(prefix .. "Avorion" .. "MineAmount",  config.defaultAvorionMines)
end 

function iteration(timestep)
    if time > config.defaultTime then
        local player = Player()
        if config.debug then print("giving resources to player:"..player.name) end
        for index, material in pairs(ressources) do
            local mines = player:getValue(prefix .. material .. "MineAmount")
            player:receiveResource(Material(index - 1), mines * config.defaultIncome)
        end
      time=0 
    else
      time= time + timestep
    end  
end

function validData(player)
    if(player == nil) then
        return false
    end
    
    for _, material in pairs(ressources) do
        if player:getValue(prefix .. material .. "MineAmount") == nil then return false end
    end
    return true
end

function incrementMine(player, material)
    if config.debug then print("Increment Mine p:"..player.name.."mat:"..material) end
    player:setValue(prefix .. ressources[material] .. "MineAmount", player:getValue(prefix .. ressources[material] .. "MineAmount")+1)
end

