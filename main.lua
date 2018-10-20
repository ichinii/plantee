debug = false
debug_ecman = false 

local vec2 = require('misc/vec2')
window_size = vec2()
world = love.physics.newWorld()
world:setGravity(0, 500)
ecman = require('ecman')
require('components/position')
require('components/collider')
require('components/geometry')
require('components/player_controller')
require('prefabs/character')
require('prefabs/level')
local vec2 = require('misc/vec2')

function love.load()
  local e_character = ecman:create_character(vec2(512, 0))
  ecman:component('player_controller'):create(e_character)
  local e_level = ecman:create_level('0')
end

function love.update(dt)
  if not love.keyboard.isDown('q') then
    ecman:update(dt)
    world:update(dt)
  end
end

function love.draw()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local transform = love.math.newTransform()
  transform:scale(width / (64 * 16) / (width / height), height / (64 * 16))
  love.graphics.replaceTransform(transform)

  ecman:draw()

  if debug then
    for _, contact in ipairs(world:getContacts()) do
      local x1, y1, x2, y2 = contact:getPositions()
      if x1 and y1 then 
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.circle('fill', x1, y1, 8)
      end
      if x2 and y2 then 
        love.graphics.setColor(1, 0.5, 0, 1)
        love.graphics.circle('fill', x2, y2, 8)
      end
      love.graphics.setColor(1, 1, 1, 1)
    end
  end
end
