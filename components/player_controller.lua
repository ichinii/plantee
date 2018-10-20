local vec2 = require('../misc/vec2')

local function create(index, ecman)
  local instance = {}
  if debug then
    instance.left_position = vec2()
    instance.right_position = vec2()
  end
  return instance
end

local function update(dt, index, instance, ecman)
  local body = ecman:component('collider'):instance(index).body
  local px, py = body:getPosition()
  local vx, vy = body:getLinearVelocity()

  local left = love.keyboard.isDown('a')
  local right = love.keyboard.isDown('d')
  local jump = love.keyboard.isDown('space')
  local grounded = false
  local pos = vec2(px, py)
  local left_dot = 1
  local right_dot = -1
  local left_contact = vec2(0, 1)
  local right_contact = vec2(0, 1)

  -- forbid moving when touching a wall
  -- forbid jumping when not grounded
  for _, contact in ipairs(body:getContacts()) do
    if contact:isTouching() then
      local cx, cy = contact:getPositions()
      local cv = vec2(cx, cy) - vec2(px, py)
      local cn = cv:normalized()

      left = vec2(-1, 0):dot(cn) < math.sqrt(2) / 2 and left
      right = vec2(1, 0):dot(cn) < math.sqrt(2) / 2 and right

      if vec2(0, 1):dot(cn) > math.sqrt(2) / 2 then -- ground
        grounded = true
        local dot = vec2(1, 0):dot(cn)
        if dot < left_dot then
          left_dot = dot
          left_contact = cn
        end
        if dot > right_dot then
          right_dot = dot
          right_contact = cn
        end
      end
    end
  end

  local left_dir = left_contact:rotated(math.pi * 0.5)
  local right_dir = right_contact:rotated(math.pi * 1.5)

  if debug then
    instance.left_position = pos + left_dir * vec2(64, 64)
    instance.right_position = pos + right_dir * vec2(64, 64)
  end

  local new_vx = (left and left_dir.x * 256 or 0) + (right and right_dir.x * 256 or 0)
  local new_vy = (left and left_dir.y * 256 or 0) + (right and right_dir.y * 256 or 0)
  new_vy = vy + (new_vy > 0 and new_vy or 0)

  body:setGravityScale(grounded and 0 or 1)
  body:setLinearVelocity(new_vx, grounded and jump and -400 or new_vy)
end

local function draw(index, instance, ecman)
  if debug then
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.circle('fill', instance.left_position.x, instance.left_position.y, 8) 
    love.graphics.circle('fill', instance.right_position.x, instance.right_position.y, 8) 
    love.graphics.setColor(1, 1, 1, 1)
  end
end

ecman:create_component('player_controller', create, nil, update, draw)
