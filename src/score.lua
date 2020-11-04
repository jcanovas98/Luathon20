local Object = Object or require "lib.classic"
local w, h = love.graphics.getDimensions()
local credits = 0
local loadedCredits = 0
local file = io.open("savegame.txt", "r+")

function Score:new()
  io.input(file)
end

function Score:update(dt)
  
end

function Score:draw()
  
end

function Score:loadCredits() --Loads player credits from a txt file
  self.loadedCredits = io.read()
end

function Score:increaseCredits(moarCredits)
  self.credits = self.credits + moarCredits --Increases player credits by input
end

function Score:saveCredits() --Saves player credits on a txt file
  io.write(self.credits)
end

return Score