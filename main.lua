local w, h = love.graphics.getDimensions()

--actors
local Player = Player or require "src/player"
local Background = Background or require "src/background"
local Blast = Blast or require "src/blast"
local Marco = Marco or require "src/marco"
local Hud = Hud or require "src/hud"
local hud = Hud(5)
local actorList = {}

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Enable the debugging with ZeroBrane Studio
  
  local background = Background:extend()
  background:new(100)
  table.insert(actorList, background)
  
  local marco = Marco("spr/marco_con_borde_def.png", w/2 - 10, h/2, 0.65)
  table.insert(actorList, marco)
  
  local player = Player("spr/xwing2.png", w/2, h - h/4, 100, 0.75)
  table.insert(actorList, player)
  
  font = love.graphics.newFont("pong.ttf",100)
  love.graphics.setFont(font)
end
function love.update(dt)
  --collision list
  for _,v in ipairs(actorList) do
    if v.tag == "blast" then
      if (v.position.y <= v.yF + 3 and v.position.y >= v.yF - 3) and (v.position.x <= v.xF + 3 and v.position.x >= v.xF - 3) or v.position.y <= h/2 then
        table.remove(actorList, _)
      end
    end
  end
  --update list
  for _,v in ipairs(actorList) do
    v:update(dt, actorList)
  end
end
function love.draw()
  for _,v in ipairs(actorList) do
    v:draw()
  end
  hud:draw()
end