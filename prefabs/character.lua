local vec2 = require('../misc/vec2')

function ecman:create_character(position)
  local entity = self:create_entity()

  -- position
  local c_position = self:component('position'):create(entity, position)

  -- geometry
  self:component('geometry'):create(entity, function()
    local position = self:component('position'):instance(entity)
    love.graphics.circle('fill', c_position.x, c_position.y, 52 / 2 + 1)
  end)

  -- colider
  local body = love.physics.newBody(world, c_position.x, c_position.y, 'dynamic')
  body:setFixedRotation(true)
  --love.physics.newFixture(body, love.physics.newCircleShape(0, 16, 16), 1)
  love.physics.newFixture(body, love.physics.newCircleShape(52 / 2), 1)
  local collider = self:component('collider'):create(entity, body)

  return entity
end
