local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Enemy = Object:extend()
local w, h = love.graphics.getDimensions()


function Enemy:new(image,x,y,time,iscale)
  self.tag = "marco"
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.forward = Vector.new(0, 0)
  self.speed = speed or 30
  self.image = love.graphics.newImage(image or nil)
  self.iscale = iscale
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight()
  self.width  = self.image:getWidth()
  
  self.iscalec = iscale
  
  self.xF = self.position.x
  self.yF = self.position.y
  self.xI =  w/2 - minW/2 + self.position.x * minW / w
  self.yI = h/2 - minH + self.position.y * minH / h
  self.position.x = self.xI
  self.position.y = self.yI

  self.forward = Vector.new(self.xF - self.xI, self.yF - self.xI)
  self.forward:normalize()
  
  self.dist = math.sqrt(math.pow(self.xF - self.xI, 2) + math.pow(self.yF - self.yI, 2))
  self.speed = self.dist/time
  self.distM = 0 -- distancia recorrida
end

function Enemy:update(dt)
  self.position = self.position + self.forward * self.speed * dt
  
  self.distM = self.dist - math.sqrt(math.pow(self.xF - self.position.x, 2) + math.pow(self.yF - self.position.y, 2))
  self.iscale = self.iscalec * (self.distM / self.dist)--cons size/px + trigo
end

function Enemy:draw()
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

return Enemy