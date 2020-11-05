local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Hud = Object:extend()
local w, h = love.graphics.getDimensions(5)

function Hud:new(health)
  self.heartList = {}
  self.health = health
  self.lastHealth = health
  for i = 1, health do
    table.insert(self.heartList, "spr/heartr.png")
  end
  self.score = 0
end

function Hud:update(dt)
  if self.lastHealth ~= self.health then
    self.heartList[self.health + 1] = "spr/heartg.png"
  end
  self.lastHealth = self.health
  self.score = self.score + dt * 3
end

function Hud:draw()
  for i = 1, #self.heartList do
    love.graphics.draw(love.graphics.newImage(self.heartList[i]), 40 + (i - 1) * 100,40,0,0.5,0.5)
  end
  love.graphics.setColor(1, 0.8, 0)
  love.graphics.print(math.floor(self.score), w - 400, 40 ,0,1,1)
  love.graphics.setColor(1, 1, 1)
end

return Hud