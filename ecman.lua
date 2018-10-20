local ecman = {}
ecman.entities = {}
ecman.components = {}

function ecman:update(dt)
  for _, component in pairs(self.components) do
    component:update(dt)
  end
end

function ecman:draw(dt)
  for _, component in pairs(self.components) do
    component:draw()
  end
end

function ecman:create_entity()
  local index = #self.entities
  local entity = index
  table.insert(self.entities, entity)

  if debug_ecman then print('create_entity()', index, entity) end
  return entity
end

function ecman:destroy_entity(index)
  if debug_ecman then print('destroy_entity()', index) end

  for _, component in pairs(self.components) do
    component:destroy(index)
  end
  self.entities[index] = nil
end

function ecman:has_component(name)
  return self.components[name] ~= nil
end

function ecman:component(name)
  assert(self:has_component(name))
  return self.components[name]
end

function ecman:create_component(name, create, destroy, update, draw)
  if debug_ecman then print('create_component()', name) end
  assert(not self:has_component(name))

  local ecman = self
  local component = {}
  component.instances = {} -- instance shares index with entity

  function component:has_entity(index)
    return self.instances[index] ~= nil
  end

  function component:instance(index)
    assert(self:has_entity(index))
    return self.instances[index]
  end

  function component:create(index, arg)
    if debug_ecman then print('component:create()') end
    assert(not self:has_entity(index))

    if create then
      self.instances[index] = create(index, ecman, arg)
    else
      self.instances[index] = index
    end

    return self:instance(index)
  end

  function component:destroy(index)
    if debug_ecman then print('component:destroy()', self.name) end
    assert(self:has_entity(index))

    if destroy then
      destroy(index, self:instance(index), ecman)
    end
    self.instances[index] = nil
  end

  function component:update(dt)
    if debug_ecman then print('component:update()', self.name) end

    if update then
      for index, instance in pairs(self.instances) do
        update(dt, index, instance, ecman)
      end
    end
  end

  function component:draw()
    if debug_ecman then print('component:draw()', self.name) end

    if draw then
      for index, instance in pairs(self.instances) do
        draw(index, instance, ecman)
      end
    end
  end

  if debug_ecman then component.name = name end
  self.components[name] = component
end

function ecman:destroy_component(name)
  assert(self:has_component(name))
  self.components[name] = nil

  if debug_ecman then print('destroy_component()', name) end
end

return ecman
