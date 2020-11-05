local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
require "data"
local w, h = love.graphics.getDimensions()

local wingW = 70
local wingH1 = -45
local wingH2 = 5
local Player = Object:extend()
local dist = 100

function Player:new(image,x,y,speed,iscale)
  self.tag = "player"
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.forward = Vector.new(0, 0)
  self.speed = speed or 30
  self.image = love.graphics.newImage(image or nil)
  self.iscale = iscale
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight() * iscale
  self.width  = self.image:getWidth() * iscale
  self.timer = 0
  self.invulnTimer = 0
end

function Player:update(dt, actorList, hud)
  --Movement
  if love.keyboard.isDown("s") then
    self.forward.y = self.forward.y + 0.1
  elseif love.keyboard.isDown("w") then
    self.forward.y = self.forward.y - 0.1
  else
    if self.forward.y < 0.2 and self.forward.y > -0.2  then
      self.forward.y = 0
    elseif self.forward.y > 0 then
      self.forward.y = self.forward.y - 0.2
    elseif self.forward.y < 0 then
      self.forward.y = self.forward.y + 0.2
    end
  end
  
  if love.keyboard.isDown("d") then
    self.forward.x = self.forward.x + 0.1
  elseif love.keyboard.isDown("a") then
    self.forward.x = self.forward.x - 0.1
  else
    if self.forward.x < 0.2 and self.forward.x > -0.2 then
      self.forward.x = 0
    elseif self.forward.x > 0 then
      self.forward.x = self.forward.x - 0.2
    elseif self.forward.x < 0 then
      self.forward.x = self.forward.x + 0.2
    end
  end
  
  --Shoot
  if love.keyboard.isDown("space") and self.timer > 0.5 and (self.forward.x < 0.1 and self.forward.x > -0.1) and (self.forward.y < 0.1 and self.forward.y > -0.1) then
    local blast11 = Blast("spr/blast.png", self.position.x - wingW,  self.position.y + wingH1 , 2, 0.05, self.position.x, self.position.y)
    table.insert(actorList, blast11)
    local blast12 = Blast("spr/blast.png", self.position.x + wingW,  self.position.y + wingH1 , 2, 0.05, self.position.x, self.position.y)
    table.insert(actorList, blast12)
    local blast21 = Blast("spr/blast.png", self.position.x - wingW,  self.position.y + wingH2 , 2, 0.05, self.position.x, self.position.y)
    table.insert(actorList, blast21)
    local blast22 = Blast("spr/blast.png", self.position.x + wingW,  self.position.y + wingH2 , 2, 0.05, self.position.x, self.position.y)
    table.insert(actorList, blast22)
    self.timer = 0
  end
  self.timer = self.timer + dt
  
  --Collision
  if (self.position.y >= h - self.height/2 and self.forward.y > 0) or (self.position.y <= h/2 - minH + self.height/2  and self.forward.y < 0) then
    self.forward.y = 0
  end
  if (self.position.x >= w - self.width/2 and self.forward.x > 0) or (self.position.x <= 0 + self.width/2 and self.forward.x < 0) then
    self.forward.x = 0
  end
  self.position = self.position + self.forward * self.speed * dt
  if self.invulnTimer > 1 then 
    for _,v in ipairs(actorList) do
      if v.tag == "explosion" then
        if (((self.position.x + self.width/2 > v.position.x - v.width/2 and self.position.x + self.width/2 < v.position.x + v.width/2) or 
        (self.position.x - self.width/2 > v.position.x - v.width/2 and self.position.x - self.width/2 < v.position.x + v.width/2)) and
        ((self.position.y - self.height/2 > v.position.y - v.height/2 and self.position.y - self.height/2 < v.position.y + v.height/2) or 
        (self.position.y + self.height/2 > v.position.y - v.height/2 and self.position.y + self.height/2 < v.position.y + v.height/2))) then
          hud.health = hud.health - 1
          self.invulnTimer = 0
        end
      end
    end
  end
  self.invulnTimer = self.invulnTimer + dt
end

function Player:draw()
  xI = self.position.x
  yI = self.position.y
  xF =  xI * minW / w + w/2 - minW/2
  yF = (yI - h/2) * minH / (h/2) + (h/2 - minH)
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

return Player