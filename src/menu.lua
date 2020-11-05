local Object = Object or require "lib.classic"
local Audio = Audio or require "src/audio"
local Vector = Vector or require "src/vector"
local Menu = Object:extend()
local w, h = love.graphics.getDimensions()
local timeRot = 3
local buttons = {}
local font
local audio = Audio()


function Menu:new()
  table.insert(buttons, Menu:newButton("Start Game", function() print("Starting game") end))
  table.insert(buttons, Menu:newButton("Scoreboard", function() print("Checking score") end))
  table.insert(buttons, Menu:newButton("Exit", function() love.event.quit(0) end))
  menuTrack = audio:getMenuTrack()
  
  self.tag = "marco"
  self.position = Vector.new(w/2 or 0, h-100 or 0)
  self.scale = Vector.new(1/2,1/2)
  self.image = love.graphics.newImage("spr/marco_con_borde_def.png")
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight()
  self.width  = self.image:getWidth()
  self.rot = 0
  self.imageOut = love.graphics.newImage("spr/marco_boca_abierta_con_bordes.png")
  
  self.timer = 0
  self.mouthTimer = 0
  self.closeMouth = true
end

function Menu:update(dt)
   menuTrack:play()
   
  if self.timer < timeRot  then
    self.rot = self.rot + math.rad(720/timeRot) * dt
    if self.mouthTimer > 0.3 then
      i = self.image
      self.image = self.imageOut
      self.imageOut = i
      self.mouthTimer = 0
    end
    self.mouthTimer = self.mouthTimer + dt
    
  elseif not self.closeMouth then
      self.timer = 0
      self.closeMouth = true
  end
  
  if self.closeMouth and self.timer > timeRot then
    self.image = love.graphics.newImage("spr/marco_con_borde_def.png")
    self.imageOut = love.graphics.newImage("spr/marco_boca_abierta_con_bordes.png")
    self.rot = 0
    self.closeMouth = false
    self.spawnLaser = true
  end
  self.timer = self.timer + dt
end

function Menu:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, w, h)
  love.graphics.setColor(0.9, 0.9, 0.8)
  love.graphics.polygon('fill', 0, -10, w/2 - minW/2, h/2, w/2 - minW/2, h/2 + minH/2, 0, h + 10)
  love.graphics.polygon('fill', w, -10, w/2 + minW/2, h/2, w/2 + minW/2, h/2 + minH/2, w, h + 10)
  
  
  
  love.graphics.setColor(0, 0, 0, 1)
  font = love.graphics.newFont("pong.ttf", 90)
  love.graphics.print("ANGRY BEARD!", font, w/5, h/10)
  
  font = love.graphics.newFont("pong.ttf", 40)

  local buttonW = w/3
  local buttonH = h/10
  
  local y = 0
  local margin = 16
  local totalH = (buttonH + margin) * #buttons
  
   
  for i, button in ipairs(buttons) do
    button.last = button.now
    
    local bX = (w/2) - (buttonH/2)
    local bY = (h/2) - (totalH/2) + y
    
    local color = {0.4, 0.4, 0.5, 1.0}
    
    local mX, mY = love.mouse.getPosition()
    
    local select = mX > bX and mX < bX + buttonW and mY > bY and mY < bY + buttonH
    
    if select then
      color = {0.8, 0.8, 0.9, 1.0}
    end
    
    if love.mouse.isDown(1) and select then
      button.f()
    end
    
    
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle("fill", w/2 - buttonW/2, h/2 - totalH/2 + y, buttonW, buttonH) 
    
    local textW = font:getWidth(button.text)
    local textH = font:getHeight(button.text)
    
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(button.text, font, w/2 - textW/2, bY + textH/2) 
    
    y = y + (buttonH + margin)
  end
  love.graphics.setColor(0.8, 0.8, 0.9, 1.0)
  love.graphics.draw(self.image, self.position.x, self.position.y, self.rot, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

function Menu:newButton(text, f)
  return{
    text = text, 
    f = f,
    click = false,
    last = false
  }
end

return Menu