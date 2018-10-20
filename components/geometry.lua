local function create(index, ecman, draw)
  local instance = {}
  instance.draw = draw or function() end

  return instance
end

local function draw(index, instance, ecman)
  instance.draw()
end

ecman:create_component('geometry', create, nil, nil, draw)
