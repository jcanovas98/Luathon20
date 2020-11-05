local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Lasers = Lasers or require "src/laser"
local Marco = Object:extend()
local w, h = love.graphics.getDimensions()
local timeRot = 3--= 4
local timeLasers = 10
local time = 1000


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
  self.laserDone = false
end

function Marco:update(dt, actorList)
  if self.timer < timeRot  then
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
      self.timer = 0
      self.closeMouth = true
      for _,v in ipairs(actorList) do
        if v.tag == "lasers" then
          table.remove(actorList, _)
        end
      end
      self.lasers = nil
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
    self.lasers = Lasers(self.position.x, self.position.y, self.position.x + math.random(-w/2, w/2), self.position.y + math.random(100, h/2), time)
    table.insert(actorList, self.lasers)
    self.spawnLaser = false
  end
  self.timer = self.timer + dt
end

function Marco:draw()
  love.graphics.draw(self.image, self.position.x, self.position.y, self.rot, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

return Marco