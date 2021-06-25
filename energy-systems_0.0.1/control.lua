-- control.lua

script.on_event(defines.events.on_tick,
  function (event)
    
  end
)

script.on_event(defines.events.on_built_entity,
  function (event)
    if event.created_entity and event.created_entity.valid and event.created_entity.name == "accumulator" then
      game.print("Found")
    end
    -- add to list
  end
)

script.on_event(defines.events.on_entity_died,
  function (event)
    -- remove from list
  end
)

local function on_init()
  global.accumulators = {}
end

script.on_init(on_init)
