local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Explosion = Object:extend()
local w, h = love.graphics.getDimensions()


function Explosion:new(x,y,w,h, time)
  self.tag = "explosion"
  self.position = Vector.new(x or 0, y or 0)
  self.width = 0
  self.height = 0
  self.widthf = w
  self.heightf = h
  self.time = time
  self.timer = 0
  print"a"
end

function Explosion:update(dt)
  if self.widthf >= self.width then
    self.width = self.widthf * self.timer/self.time
    self.height = self.heightf * self.timer/self.time
  end
  self.timer = self.timer + dt
end

function Explosion:draw()
  love.graphics.setColor(1, 0.8, 0)
  love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)
  love.graphics.setColor(1, 1, 1)
end

return Explosion