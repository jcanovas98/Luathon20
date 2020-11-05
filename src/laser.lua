local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Lasers = Object:extend()
local w, h = love.graphics.getDimensions()
local eyeX1 = 30
local eyeY1 = 30
local eyeX2 = 40
local eyeY2 = 33
local eyeW = 4


function Lasers:new(x,y,xf,yf,time)
  self.tag = "lasers"
  self.position = Vector.new(x or 0, y or 0)
  self.dist = h/2
  self.xf = xf
  self.yf = yf
  self.done = false
  self.speed = math.sqrt(math.pow(self.position.x + self.xf, 2) + math.pow(self.position.y + self.yf, 2))/time
end

function Lasers:update(dt)
  if self.dist < self.yf then
    self.dist = self.dist + self.speed * dt
  else
    self.done = true
  end
end

function Lasers:draw()
  love.graphics.setColor(1, 0.8, 0)
  cosAlpha = math.deg(math.cos(math.rad(2)))
  sinAlpha = math.deg(math.sin(math.rad(2)))
  love.graphics.polygon("fill", self.position.x - eyeX1 - eyeW, self.position.y - eyeY1, self.position.x - eyeX1 + eyeW, self.position.y - eyeY1, 
    self.position.x + eyeW + self.dist/cosAlpha* sinAlpha + (self.xf - self.position.x), self.dist, self.position.x - eyeW - self.dist/cosAlpha* sinAlpha + (self.xf - self.position.x), self.dist)
  love.graphics.polygon("fill", self.position.x + eyeX2 - eyeW, self.position.y - eyeY2, self.position.x + eyeX2 + eyeW, self.position.y - eyeY2, 
    self.position.x + eyeW + self.dist/cosAlpha* sinAlpha + (self.xf - self.position.x), self.dist, self.position.x - eyeW - self.dist/cosAlpha* sinAlpha + (self.xf - self.position.x), self.dist)
  love.graphics.setColor(1, 1, 1)
end

return Lasers