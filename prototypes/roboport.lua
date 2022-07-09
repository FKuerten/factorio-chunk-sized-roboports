local rescaleRecipe = require("prototypes/util")

local extraRadius = settings.startup["graveater-chunk-sized-roboport-wiggle-area"].value and 1 or 0

local round = function(x)
  return math.floor(x+0.5)
end

local function rescaleRoboportEntity(entity, newLogisticRadius)
  local radiusRatio = newLogisticRadius / entity.logistics_radius
  local radiusRatioSquared = radiusRatio * radiusRatio
  local newConstructionRadius = entity.construction_radius * radiusRatio
  entity.logistics_radius = newLogisticRadius
  entity.construction_radius = newConstructionRadius

  local oldEnergyUsage = entity.energy_usage
  local oldEnergyUsageNumber = tonumber(oldEnergyUsage:sub(1,-3))
  local oldUnit = oldEnergyUsage:sub(-2)
  local oldRechargeMinimum = entity.recharge_minimum
  local oldRechargeMinimumNumber = tonumber(oldRechargeMinimum:sub(1,-3))
  local oldRechargeUnit = oldRechargeMinimum:sub(-2)
  entity.energy_usage = round(oldEnergyUsageNumber * radiusRatioSquared) .. oldUnit
  entity.recharge_minimum = round(oldRechargeMinimumNumber * radiusRatioSquared+1) .. oldRechargeUnit

  return radiusRatioSquared
end

local function rescaleRoboport(name, newLogisticRadius, recipeName)
  local entity = data.raw["roboport"][name]
  local radiusRatioSquared = rescaleRoboportEntity(entity, newLogisticRadius)
  recipeName = recipeName or name
  local recipe = data.raw["recipe"][recipeName]
  if recipe then
    rescaleRecipe(recipe, radiusRatioSquared)
  end
end

local function rescaleIfFound(name, newLogisticRadius, recipeName)
  if data.raw['roboport'][name] then
    rescaleRoboport(name, newLogisticRadius, recipeName)
  end
end

if mods["IndustrialRevolution"] then
  rescaleRoboport("roboport", 32 + extraRadius)
  rescaleRoboport("robotower", 16 + extraRadius)
elseif mods['Krastorio2'] then
  -- default sizes are
  -- small:    18,  34 = 2* 18-2
  -- vanilla:  25,  55 = 2* 25+5
  -- large:   100, 200 = 2*100+0
  local function rescaleKrastorioRoboport(name, newLogisticRadius)
    local entity = data.raw["roboport"][name]
    local oldNormalLogisticRadius = entity.logistics_radius
    local oldNormalConstructionRadius = entity.construction_radius
	local radiusRatioSquared = rescaleRoboportEntity(entity, newLogisticRadius)
    local recipe = data.raw["recipe"][name]
    if recipe then
      rescaleRecipe(recipe, radiusRatioSquared)
    end
	local logisticEntity = data.raw["roboport"][name .. '-logistic-mode']
    local constructionEntity = data.raw["roboport"][name .. '-construction-mode']
	logisticEntity.logistics_radius = logisticEntity.logistics_radius * entity.logistics_radius / oldNormalLogisticRadius
	logisticEntity.construction_radius = logisticEntity.construction_radius * entity.construction_radius / oldNormalConstructionRadius
	constructionEntity.logistics_radius = constructionEntity.logistics_radius * entity.logistics_radius / oldNormalLogisticRadius
	constructionEntity.construction_radius = constructionEntity.construction_radius * entity.construction_radius / oldNormalConstructionRadius
  end
  rescaleKrastorioRoboport('kr-small-roboport', 16 + extraRadius)
  rescaleKrastorioRoboport('roboport', 32 + extraRadius)
  rescaleKrastorioRoboport('kr-large-roboport', 64 + extraRadius)
else
  rescaleRoboport("roboport", 16 + extraRadius)
end

rescaleIfFound("bob-roboport-2", 16 * 2 + extraRadius)
rescaleIfFound("bob-roboport-3", 16 * 3 + extraRadius)
rescaleIfFound("bob-roboport-4", 16 * 4 + extraRadius)

rescaleIfFound("bob-logistic-zone-expander", 16 + extraRadius)
rescaleIfFound("bob-logistic-zone-expander-2", 16 * 2 + extraRadius)
rescaleIfFound("bob-logistic-zone-expander-3", 16 * 3 + extraRadius)
rescaleIfFound("bob-logistic-zone-expander-4", 16 * 4 + extraRadius)

-- default radius was 70
rescaleIfFound("fi_robo_port_entity",16 * 4 + extraRadius, "fi_robo_port_recipe")
