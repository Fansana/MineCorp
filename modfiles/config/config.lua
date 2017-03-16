
config = {}
-- You get "defaultIncome" every "defaultTime" seconds
config.defaultIncome = 40
config.defaultTime = 60

-- startMines
config.defaultIronMines = 0
config.defaultTitaniumMines = 0
config.defaultNaoniteMines = 0
config.defaultTriniumMines = 0
config.defaultXanionMines = 0
config.defaultOgniteMines = 0
config.defaultAvorionMines = 0

config.probabilityPerAsteroidField = 0.1

config.refurbishingCost = {}
-- The amount it costs to claim a Mine
-- The default values are tied to the health of a block and then some
-- the values equal roughly 1.5 the previous one
config.refurbishingCost.Iron     =  100000
config.refurbishingCost.Titanium =  150000
config.refurbishingCost.Naonite  =  225000
config.refurbishingCost.Trinium  =  350000
config.refurbishingCost.Xanion   =  550000
config.refurbishingCost.Ognite   =  825000
config.refurbishingCost.Avorion  = 1250000

config.debug = false
return config
