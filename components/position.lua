local vec2 = require('../misc/vec2')

local function create(index, ecman, position)
  position = position or vec2()
  return vec2(position.x, position.y)
end

ecman:create_component('position', create, nil, nil, nil)
