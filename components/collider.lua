local function create(index, ecman, body)
  assert(body)

  local instance = {}
  instance.body = body
  return instance
end

local function destroy(index, instance, ecman)
  instance.body:destroy()
end

local function update(dt, index, instance, ecman)
  if ecman:component('position'):has_entity(index) then
    local x, y = instance.body:getPosition()
    local position = ecman:component('position'):instance(index)
    position.x = x
    position.y = y
  end
end

local function draw(index, instance, ecman)
end

ecman:create_component('collider', create, destroy, update, draw)
