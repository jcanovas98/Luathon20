local Object = Object or require "lib.classic"
local Gameover = Object:extend()

local w, h = love.graphics.getDimensions(5)
local alreadyPlayed = false
local audio = love.audio.newSource("spr/You died.mp3", "static")

function Gameover:new()
  self.image = love.graphics.newImage("spr/gameover.jpg")
  self.timer = 0
end

function Gameover:update(dt)
  if (self.timer < 2) and (not alreadyPlayed) then
    love.audio.play(audio)
    alreadyPlayed = true
  end
  
  self.timer = self.timer + dt
end

function Gameover:draw()
  love.graphics.draw(self.image, -130, -50, 0, 1, 1)
  
  if self.timer > 4 then
    love.graphics.print("Press enter to retry", w / 3 - 25 , h / 2 + 160, 0, 0.35, 0.35)
  end
end

return Gameover

