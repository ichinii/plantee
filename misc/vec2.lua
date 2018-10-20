local vec2 = {}
local vec2_mt = {}
local instance_mt = {}
instance_mt.__index = instance_mt

function instance_mt:__unm()
  return vec2(-self.x, -self.y)
end

function instance_mt:__add(v)
  return vec2(self.x + v.x, self.y + v.y)
end

function instance_mt:__sub(v)
  return vec2(self.x - v.x, self.y - v.y)
end

function instance_mt:__mul(v)
  return vec2(self.x * v.x, self.y * v.y)
end

function instance_mt:__div(v)
  return vec2(self.x / v.x, self.y / v.y)
end

--[[ lua 5.3 feature not being supported yet
function instance_mt:__idiv(v)
  return vec2(self.x // v.x, self.y // v.y)
end
]]

function instance_mt:__eq(v)
  return self.x == v.x and self.y == v.y
end

function instance_mt:__tostring()
  return 'vec2('..self.x..', '..self.y..')'
end

function vec2_mt:__call(x, y)
  local vec2 = {}
  vec2.x = x or 0
  vec2.y = y or 0

  return setmetatable(vec2, instance_mt)
end

function instance_mt:dot(v)
  return self.x * v.x + self.y * v.y
end

function instance_mt:length()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function instance_mt:normalized()
  local l = self:length()
  assert(l > 0)
  return vec2(self.x / l, self.y / l)
end

function instance_mt:rotated(angle)
  return vec2(math.cos(angle) * self.x - math.sin(angle) * self.y, math.sin(angle) * self.x + math.cos(angle) * self.y)
end

return setmetatable(vec2, vec2_mt)
