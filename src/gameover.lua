local Object = Object or require "lib.classic"
local Audio = Audio or require "src/audio"
local Gameover = Object:extend()

local w, h = love.graphics.getDimensions(5)
local alreadyPlayed = false
local audio = Audio()
local font = love.graphics.newFont("pong.ttf", 100)

function Gameover:new()
  self.image = love.graphics.newImage("spr/gameover.jpg")
  self.timer = 0
  gameoverTrack = audio:getGameover()
end

function Gameover:update(dt)
  if (not alreadyPlayed) then
    gameoverTrack:play()
    alreadyPlayed = true
  end
  
  self.timer = self.timer + dt
end

function Gameover:draw()
  love.graphics.draw(self.image, -130, -50, 0, 1, 1)
  
  if self.timer > 4 then
    
    love.graphics.print("Press enter to retry", font, w / 3 - 25 , h / 2 + 160, 0, 0.35, 0.35)
    love.graphics.print("Press esc to exit", font, w / 3 , h / 2 + 200, 0, 0.35, 0.35)
  end
end

return Gameover

