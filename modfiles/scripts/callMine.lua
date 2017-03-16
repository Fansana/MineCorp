package.path = package.path .. ";data/scripts/lib/?.lua"
package.path = package.path .. ";modfiles/config/?.lua"
package.path = package.path .. ";modfiles/scripts/?.lua"
require ("stringutility")
require ("main")
config = require("config")

local resources  = {"Iron", "Titanium", "Naonite", "Trinium", "Xanion", "Ognite", "Avorion"}

-- if this function returns false, the script will not be listed in the interaction window,
-- even though its UI may be registered
function interactionPossible(playerIndex, option)
    local player = Player(playerIndex)
    local self = Entity()

    local craft = player.craft
    if craft == nil then return false end

    local dist = craft:getNearestDistance(self)

    if dist < 200 then
        return true
    end

    return false, "You are not close enough to scan the object!"%_t
end

-- create all required UI elements for the client side
function initUI()
    print("initUI")
    local res = getResolution()
    local size = vec2(400, 200)
    
    local menu = ScriptUI()
    window = menu:createWindow(Rect(res * 0.5 - size * 0.5, res * 0.5 + size * 0.5))--getRect

    window.caption = "Refurbish resource Mine"%_t
    window.showCloseButton = 1
    window.moveable = 1
    

    local split = UIHorizontalSplitter(Rect(vec2(10, 10), size - 10), 10, 0, 0.8) 
    local explanation = window:createMultiLineTextBox(split.top)
    local resource = resources[Entity(Player().selectedObject):getValue("MineMaterial")]
    local cost = config.refurbishingCost[resource]
    explanation.text = "This mine looks pretty intact, a few supplies should get it back in working order. I think it will cost ".. cost .."$. But why is it empty in the first place. What drove the owners away? Do I really want to invest in here?"
    explanation.setFontSize = 16
    explanation.editable = false
    explanation.active = false
    
    local buttons = UIVerticalSplitter(split.bottom, 10, 0, 0.5)
    local refurbishButton = window:createButton(buttons.left, "I am sure", "callRefurbish")
    local abortButton = window:createButton(buttons.right, "HELL NO!", "abort") 
    menu:registerWindow(window, "Refurbish"%_t);
end

function onShowWindow()

end

function displayCost()
    local player = Player(callingPlayer)
    local material = Entity():getValue("MineMaterial")
    player:sendChatMessage("", 2, "refurbishing this station will cost: " .. config.refurbishingCost[resources[material]] .. "$")   

end

function callRefurbish()
    invokeServerFunction("refurbish")
end
function abort()
    ScriptUI():stopInteraction()
end


function refurbish()
    local player = Player(callingPlayer)
    local ok, msg = interactionPossible(callingPlayer)
    if ok then
        local material = Entity():getValue("MineMaterial")
        if player:canPayMoney(config.refurbishingCost[resources[material]]) then
            player:payMoney(config.refurbishingCost[resources[material]])
            local material = Entity():getValue("MineMaterial")
            Entity().title = "Working ".. resources[material] .. " Mine"
		if not validData(player) then
		    initPlayerData(player)
		end
            incrementMine(player,material)
            terminate()
        else
            player:sendChatMessage("", 1, "You are missing " .. config.refurbishingCost[resources[material]] - player.money .. "$") 
        end
        return
    end
end
