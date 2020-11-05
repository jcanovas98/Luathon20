local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Lasers = Lasers or require "src/laser"
local Explosion = Explosion or require "src/explosion"
local Marco = Object:extend()
local w, h = love.graphics.getDimensions()
local timeRot = 3--= 4
local time = 500
local expTime = 0.5
local laserDelay = 0.5


function Marco:new(image,x,y,scale)
  self.tag = "marco"
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.image = love.graphics.newImage(image or nil)
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight()
  self.width  = self.image:getWidth()
  self.rot = 0
  self.imageOut = love.graphics.newImage("spr/marco_boca_abierta_con_bordes.png")
  self.lasers = nil 
  
  self.timer = 0
  self.mouthTimer = 0
  self.closeMouth = true
  self.spawnLaser = true
  self.laserDone = 0
  self.expTimer = 0
  self.laserDelayTimer = 0
  self.exploding = false
  self.laserX = 0
  self.laserY = 0
end

function Marco:update(dt, actorList)
  if self.timer < timeRot  then
    self.lasers = nil 
    self.mouthTimer = 0
    self.closeMouth = true
    self.spawnLaser = true
    self.laserDone = 0
    self.expTimer = 0
    self.laserDelayTimer = 0
    self.exploding = false
    self.laserX = 0
    self.laserY = 0
  
    self.rot = self.rot + math.rad(720/timeRot) * dt
    if self.mouthTimer > 0.3 then
      i = self.image
      self.image = self.imageOut
      self.imageOut = i
      self.mouthTimer = 0
    end
    self.mouthTimer = self.mouthTimer + dt
  elseif self.lasers ~= nil then
    if self.lasers.done then
      
      if self.expTimer >= expTime then
        for _,v in ipairs(actorList) do
          if v.tag == "lasers" then
            table.remove(actorList, _)
          end
        end
        self.laserDone = self.laserDone + 1
        
        table.insert(actorList, Explosion(self.laserX, self.laserY, 400, 400, expTime))
        
        self.expTimer = 0
        self.exploding = true
      end
    
      if self.laserDelayTimer >= laserDelay then
        for _,v in ipairs(actorList) do
          if v.tag == "explosion" then
            table.remove(actorList, _)
          end
        end
        self.exploding = false
        self.laserDelayTimer = 0
        self.spawnLaser = true
        self.lasers = nil
      end
      
      if self.laserDone == 3 and not self.exploding then 
        self.timer = 0
        self.laserDone = 0
        self.closeMouth = true
        self.spawnLaser = false
        self.exploding = true
      end
      
      if self.exploding then
        self.laserDelayTimer = self.laserDelayTimer + dt
      else
        self.expTimer = self.expTimer + dt
      end
    end
  end
  if self.closeMouth and self.timer > timeRot then
    self.image = love.graphics.newImage("spr/marco_con_borde_def.png")
    self.imageOut = love.graphics.newImage("spr/marco_boca_abierta_con_bordes.png")
    self.rot = 0
    self.closeMouth = false
    self.spawnLaser = true
  end
  if self.spawnLaser and self.timer > timeRot then
    math.randomseed(os.time())
    for i = 1, math.random(10) do
      math.random()
    end
    self.laserX = self.position.x + math.random(-w/2, w/2)
    self.laserY = self.position.y + math.random(100, h/2)
    self.lasers = Lasers(self.position.x, self.position.y, self.laserX, self.laserY, time)
    table.insert(actorList, self.lasers)
    self.spawnLaser = false
  end
  self.timer = self.timer + dt
end

function Marco:draw()
  love.graphics.draw(self.image, self.position.x, self.position.y, self.rot, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

return Marco