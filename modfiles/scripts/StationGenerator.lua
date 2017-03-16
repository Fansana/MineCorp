package.path = package.path .. ";data/scripts/lib/?.lua"

require ("randomext")
require ("utility")
require ("galaxy")

PlanGenerator = require ("plangenerator")
local resources  = {"Iron", "Titanium", "Naonite", "Trinium", "Xanion", "Ognite", "Avorion"}

function generateClaimableMine(position)
    local desc = StationDescriptor()

    local material = getAsteroidType(Sector():getCoordinates())

    local stationPlan = LoadPlanFromFile("modfiles/templates/Extractor2.xml")
    stationPlan:scale(vec3(0.5, 0.5, 0.5))
    desc:removeComponent(ComponentType.MineableMaterial)
    desc:addComponents(
       ComponentType.Owner,
       ComponentType.FactionNotifier
    )

    desc.position = position or getPositionInSector(3000)
    desc:setPlan(addAsteroidPlan(stationPlan))

    desc:addScript("modfiles/scripts/callMine.lua")
    local entity = Sector():createEntity(desc)

    entity.crew = entity.minCrew
    entity.shieldDurability = entity.shieldMaxDurability


    entity.title = "Abandoned ".. resources[material] .. " Mine"
    entity:setValue("MineMaterial", material)
    entity:setValue("MineOwner", material)
end

function addAsteroidPlan(plan)

    local asteroid = PlanGenerator.makeBigAsteroidPlan(getFloat(80, 100), 0, Material(MaterialType.Iron), 10)

    -- make sure the station isn't too big, this looks weird in combination with the asteroid;
    -- 250 seems to be a good visually pleasing max height/width/depth
    local box = plan:getBoundingBox()
    local highest = math.max(box.size.x, math.max(box.size.y, box.size.z))

    if highest > 250 then
        local scale = 250 / highest
        plan:scale(vec3(scale, scale, scale))

        highest = 250
    end

    -- scale the asteroid so it's at maximum half as big as the station
    local scale = highest / 2.0
    local size = scale / asteroid.radius*2.5
    asteroid:scale(vec3(size, size, size))

    -- now place the asteroid at the root of the station
    local block = plan:getBlock(0)
    plan:addPlanDisplaced(block.index, asteroid, 0, block.box.center + vec3(0, asteroid:getBoundingBox().size.y * 0.5, 0))

    -- update plan
    return plan
end

function getAsteroidType(posX, posY)
    local probabilities = Balancing_GetMaterialProbability(posX, posY)
    local value = getValueFromDistribution(probabilities)
    return value+1
end

function getPositionInSector(maxDist)
    -- deliberately not [-1;1] to avoid round sectors
    -- see getUniformPositionInSector(maxDist) below
    local position = vec3(math.random(), math.random(), math.random());
    local dist = 0
    if maxDist == nil then
        dist = getFloat(-5000, 5000)
    else
        dist = getFloat(-maxDist, maxDist)
    end

    position = position * dist

    -- create a random up vector
    local up = vec3(math.random(), math.random(), math.random())

    -- create a random right vector
    local look = vec3(math.random(), math.random(), math.random())

    -- create the look vector from them
    local mat = MatrixLookUp(look, up)
    mat.pos = position

    return mat
end

