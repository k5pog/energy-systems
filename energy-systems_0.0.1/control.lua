-- control.lua

script.on_event(defines.events.on_tick,
  function (event)
    for unit_number, entity in pairs(global.accumulators) do
      if entity.valid then
        if entity.is_connected_to_electric_network then
          if global.accumulators_energy_last_tick[unit_number] - entity.energy == entity.electric_output_flow_limit then
            local powerdamage = 0.5
            -- if entity.health <= powerdamage then
            --   entity.dying_explosion = "big-artillery-explosion"
            -- end
            entity.damage(powerdamage, "neutral")
          end
          global.accumulators_energy_last_tick[unit_number] = entity.energy
        end
      end
    end
    for unit_number, entity in pairs(global.producers_util) do
      if entity.valid then
        if entity.is_connected_to_electric_network then
          -- game.print(entity.prototype.max_energy_production) -- 15000
          if entity.prototype.max_energy_production == entity.energy_generated_last_tick and entity.prototype.max_energy_production ~= 0 then -- power_production
            local powerdamage = 0.5
            entity.damage(powerdamage, "neutral")
          end
        end
      end
    end
  end
)

local function on_built_entity(event)
  -- add to list
  if event.created_entity and event.created_entity.valid and event.created_entity.name == "accumulator" then
    global.accumulators[event.created_entity.unit_number] = event.created_entity
    global.accumulators_energy_last_tick[event.created_entity.unit_number] = 0
  end
  if event.created_entity and event.created_entity.valid and event.created_entity.type == "generator" then
    global.producers_util[event.created_entity.unit_number] = event.created_entity
  end
end

script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.script_raised_built, on_built_entity)

local function on_entity_gone(event)
  -- remove from list
  if event.entity and event.entity.valid and event.entity.name == "accumulator" then
    -- global.accumulators_energy_last_tick[event.entity.unit_number].destroy()
    global.accumulators[event.entity.unit_number].destroy()
  end
  if event.entity and event.entity.valid and event.entity.type == "generator" then --ElectricEnergyInterface
    global.producers_util[event.entity.unit_number].destroy()
  end
end

script.on_event(defines.events.on_entity_died, on_entity_gone)
script.on_event(defines.events.script_raised_destroy, on_entity_gone)

local function on_init()
  global.accumulators = {}
  global.accumulators_energy_last_tick = {}
  global.producers_util = {}
end

script.on_init(on_init)
