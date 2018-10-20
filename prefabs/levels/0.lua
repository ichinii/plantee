local vec2 = require('../misc/vec2')

local SIZE = 64

return function(ecman)
  local entity = ecman:create_entity()

  local tiles = {}
  for x = 1, 32 do
    table.insert(tiles, {})
    for y = 1, 32 do
      table.insert(tiles[x], y == 12 or x == 16)
    end
  end

  ecman:component('geometry'):create(entity, function()
    for x = 1, 32 do
      for y = 1, 32 do
        if tiles[x][y] then
          love.graphics.rectangle('fill', (x - 1) * SIZE, (y - 1) * SIZE, SIZE, SIZE)
        end
      end
    end

    love.graphics.circle('fill', 512, SIZE * 11, 256)
    love.graphics.line(512, SIZE * 8, 0, SIZE * 6)
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.line(512, SIZE * 11, 512 + 256, SIZE * 11 - 256)
    love.graphics.line(512, SIZE * 11, 512 - 256, SIZE * 11 - 256)
    love.graphics.setColor(1, 1, 1, 1)
  end)

  -- collider
  local body = love.physics.newBody(world, 0, 0, 'static')
  for x = 1, 32 do
    for y = 1, 32 do
      if tiles[x][y] then
        local shape = love.physics.newRectangleShape(
          (x - 1) * SIZE + SIZE / 2,
          (y - 1) * SIZE + SIZE / 2, SIZE, SIZE)
        local fixture = love.physics.newFixture(body, shape, 1)
      end
    end
  end
  love.physics.newFixture(body, love.physics.newCircleShape(512, SIZE * 11, 256), 1)
  love.physics.newFixture(body, love.physics.newPolygonShape(512, SIZE * 8, 0, SIZE * 6, 1000, 1000), 1)

  local x, y = body:getLocalCenter()
  body:setPosition(x, y)
  ecman:component('collider'):create(entity, body)

  return entity
end
