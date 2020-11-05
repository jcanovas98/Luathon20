local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Lasers = Lasers or require "src/laser"
local Explosion = Explosion or require "src/explosion"
local Marco = Object:extend()
local w, h = love.graphics.getDimensions()
local timeRot = 3--= 4
local time = 3.5
local expTime = 0.3
local laserDelay = 0.3


function Marco:new(image,x,y,scale)
  self.tag = "marco"
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.image = love.graphics.newImage(image or nil)
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight() * scale
  self.width  = self.image:getWidth() * scale
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
  self.laserShoots = 0
end

function Marco:update(dt, actorList, hud)
  if self.timer < timeRot  then
    self.lasers = nil 
    self.closeMouth = true
    self.spawnLaser = true
    self.laserDone = 0
    self.expTimer = 0
    self.laserDelayTimer = 0
    self.exploding = false
    self.laserX = 0
    self.laserY = 0
    math.randomseed(os.time())
    self.laserShoots = math.random(3, 6)
  
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
        
        table.insert(actorList, Explosion("spr/logo.png",self.laserX, self.laserY, 400, 400, expTime, 2.5))
        
        self.expTimer = 0
        self.exploding = true
      end
    
      if self.laserDelayTimer >= laserDelay then
        for _,v in ipairs(actorList) do
          if v.tag == "explosion" then
            table.remove(actorList, _)
            hud.score = hud.score + 50
          end
        end
        self.exploding = false
        self.laserDelayTimer = 0
        self.spawnLaser = true
        self.lasers = nil
      end
      
      if self.laserDone == self.laserShoots and not self.exploding then 
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

    for _,v in ipairs(actorList) do
      if v.tag == "player" then
        self.laserX = v.position.x
        self.laserY = v.position.y
      end
    end
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