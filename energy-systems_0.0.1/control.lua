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
    for unit_number, entity in pairs(global.producers) do
      if entity.valid then
        if entity.is_connected_to_electric_network then
          if entity.power_production == entity.electric_output_flow_limit then -- power_production
            local powerdamage = 0.5
            entity.damage(powerdamage, "neutral")
          end
        end
      end
    end
  end
)

script.on_event(defines.events.on_built_entity,
  function (event)
    -- add to list
    if event.created_entity and event.created_entity.valid and event.created_entity.name == "accumulator" then
      global.accumulators[event.created_entity.unit_number] = event.created_entity
      global.accumulators_energy_last_tick[event.created_entity.unit_number] = 0
    end
    if event.created_entity and event.created_entity.valid and event.created_entity.type == "Generator" then --ElectricEnergyInterface
      gloabl.producers[event.created_entity.unit_number] = event.created_entity
    end
  end
)

script.on_event(defines.events.on_entity_died,
  function (event)
    -- remove from list
    if event.entity and event.entity.valid and event.entity.name == "accumulator" then
      -- global.accumulators_energy_last_tick[event.entity.unit_number].destroy()
      global.accumulators[event.entity.unit_number].destroy()
    end
    if event.entity and event.entity.valid and event.entity.type == "Generator" then --ElectricEnergyInterface
      gloabl.producers[event.entity.unit_number].destroy()
    end
  end
)

local function on_init()
  global.accumulators = {}
  global.accumulators_energy_last_tick = {}
  gloabl.producers = {}
end

script.on_init(on_init)
