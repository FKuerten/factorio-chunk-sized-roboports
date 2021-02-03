local rescaleRecipe = require("prototypes/util")

local extraRadius = settings.startup["graveater-chunk-sized-roboport-wiggle-area"].value and 1 or 0

local round = function(x)
  return math.floor(x+0.5)
end

local function rescaleRoboportEntity(entity, newLogisticRadius)
  local radiusRatio = newLogisticRadius / entity.logistics_radius
  local extraConstructionRadius = entity.construction_radius - 2 * entity.logistics_radius -- 0.15.9: 55 - 2 * 25 == 5
  local radiusRatioSquared = radiusRatio * radiusRatio
  entity.logistics_radius = newLogisticRadius
  entity.construction_radius = 2 * newLogisticRadius + extraConstructionRadius

  local oldEnergyUsage = entity.energy_usage
  local oldEnergyUsageNumber = tonumber(oldEnergyUsage:sub(1,-3))
  local oldUnit = oldEnergyUsage:sub(-2)
  entity.energy_usage = round(oldEnergyUsageNumber * radiusRatioSquared) .. oldUnit

  return radiusRatioSquared
end

local function rescaleRoboport(name, newLogisticRadius)
  local entity = data.raw["roboport"][name]
  local radiusRatioSquared = rescaleRoboportEntity(entity, newLogisticRadius)
  local recipe = data.raw["recipe"][name]
  if recipe then
    rescaleRecipe(recipe, radiusRatioSquared)
  end
end

local function rescaleIfFound(name, newLogisticRadius)
  if data.raw['roboport'][name] then
    rescaleRoboport(name, newLogisticRadius)
  end
end

if mods["IndustrialRevolution"] then
  rescaleRoboport("roboport", 32 + extraRadius)
  rescaleRoboport("robotower", 16 + extraRadius)
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
