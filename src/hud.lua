local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Hud = Object:extend()
local w, h = love.graphics.getDimensions(5)
--local file = io.open("savegame.txt", "r+")
local score
local loadScore





function Hud:new(health)
 -- io.input(file)
  self.saveGame = {}
  self.file = "savegame.txt"
  f = io.open("savegame.txt")
  for line in io.lines("savegame.txt") do 
    self.saveGame[#self.saveGame+1] = line
  end
  io.close(f)

  loadScore = self.saveGame[1]
  print(loadScore)
  
  self.heartList = {}
  self.health = health
  self.lastHealth = health
  for i = 1, health do
    table.insert(self.heartList, "spr/heartr.png")
  end
  
  self.score = 0
  
  font = love.graphics.newFont("pong.ttf",100)
  love.graphics.setFont(font)
end

function Hud:update(dt)
  if self.lastHealth ~= self.health then
    self.heartList[self.health + 1] = "spr/heartg.png"
  end
  self.lastHealth = self.health
  self.score = self.score + dt * 3
  
  if self.score > tonumber(loadScore) then
    self:saveScore()
  end
end

function Hud:draw()
  for i = 1, #self.heartList do
    love.graphics.draw(love.graphics.newImage(self.heartList[i]), 40 + (i - 1) * 100,40,0,0.5,0.5)
  end
  love.graphics.setColor(1, 0.8, 0)
  love.graphics.print("Score: "..math.floor(self.score), w - 375, 40 ,0,1/2,1/2)
  love.graphics.print("Record: "..math.floor(loadScore), w - 375, 120 ,0,1/2,1/2)
  love.graphics.setColor(1, 1, 1)
end


function Hud:saveScore() --Saves player credits on a txt file
  f = assert(io.open(self.file, "w"))
  f:write(self.score)
  f:close()
end

function Hud:getHealth()
  return self.health
end

function Hud:resetHud()
  self.score = 0
  self.health = 5
end

return Hud