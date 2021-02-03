local rescaleRecipe = require('prototypes/util')

local extraReach = settings.startup["graveater-chunk-sized-powerpole-wiggle-reach"].value and 1 or 0
local extraSupplyRadius = settings.startup["graveater-chunk-sized-powerpole-wiggle-area"].value and 1 or 0

local round = function(x)
  return math.floor(x+0.5)
end

local function rescalePoleEntity(entity, newReach, newSupplyRadius)
  if newReach > 64 then newReach = 64 end
  local reachRatio = newReach / entity.maximum_wire_distance
  local supplyRatio = newSupplyRadius / entity.supply_area_distance
  entity.maximum_wire_distance = newReach
  entity.supply_area_distance = newSupplyRadius
  return reachRatio * supplyRatio
end

local function rescalePole(name, newReach, newSupplyRadius)
  local entity = data.raw['electric-pole'][name]
  local costFactor = rescalePoleEntity(entity, newReach, newSupplyRadius)
  local recipe = data.raw['recipe'][name]
  if recipe then
    rescaleRecipe(recipe, costFactor)
  end
end

local function rescaleIfFound(name, newReach, newSupplyRadius)
  if data.raw['electric-pole'][name] then
    rescalePole(name, newReach, newSupplyRadius)
  end
end

-- big pole
rescaleIfFound('big-electric-pole', 32 + extraReach, 2)   -- 4 needed for 4 chunks
rescaleIfFound('big-electric-pole-2', 43 + extraReach, 2) -- 3 needed for 4 chunks
rescaleIfFound('big-electric-pole-3', 48 + extraReach, 2) -- 2 needed for 3 chunks
rescaleIfFound('big-electric-pole-4', 64 + extraReach, 2) -- 2 needed for 4 chunks

-- substation
rescaleIfFound('substation', 16 + extraReach, 16 + extraSupplyRadius)
rescaleIfFound('substation-2', 22 + extraReach, 22 + extraSupplyRadius)
rescaleIfFound('substation-3', 24 + extraReach, 24 + extraSupplyRadius)
rescaleIfFound('substation-4', 32 + extraReach, 32 + extraSupplyRadius)
