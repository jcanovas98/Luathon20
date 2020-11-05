local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Explosion = Object:extend()
local w, h = love.graphics.getDimensions()


function Explosion:new(image,x,y,w,h, time,scale)
  self.tag = "explosion"
  self.position = Vector.new(x or 0, y or 0)
  self.image = love.graphics.newImage(image or nil)
  self.scale = 0
  self.maxScale = scale
  self.width = 0
  self.height = 0
  self.widthf = w
  self.heightf = h
  self.time = time
  self.timer = 0
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight() * scale
  self.width  = self.image:getWidth() * scale
end

function Explosion:update(dt)
  if self.widthf >= self.width then
    self.width = self.widthf * self.timer/self.time
    self.height = self.heightf * self.timer/self.time
    self.scale = self.maxScale * self.timer/self.time
  end
  self.timer = self.timer + dt
end

function Explosion:draw()
  love.graphics.setColor(1, 0.9, 0.5)
  love.graphics.rectangle("fill", self.position.x - self.width/2, self.position.y - self.height/2, self.width, self.height)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.image, self.position.x, self.position.y, self.rot, self.scale, self.scale, self.origin.x, self.origin.y)
end

return Explosion