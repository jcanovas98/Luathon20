local w, h = love.graphics.getDimensions()

--actors
local Player = Player or require "src/player"
local Background = Background or require "src/background"
local Marco = Marco or require "src/marco"
local Hud = Hud or require "src/hud"
local Score = Score or require "src/score"
local Intro = Intro or require "src/intro"
local Menu = Menu or require "src/menu"
local Audio = Audio or require "src/audio"
local Gameover = Gameover or require "src/gameover"

local hud = Hud(5)

local music = Audio()
local track1 
local track2
local menutrack
local random = math.random(1,2)

math.randomseed(os.time())

--Timers
local introTimer = 0

--Game State
local isIntro = false
local isMenu = true
local isPlaying = false
local isGameover = false
local isScoreboard = false

local actorList = {} --Game objects

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Enable the debugging with ZeroBrane Studio
 
  intro = Intro("spr/tecnocampusgames.ogv")
  
  track1 = music:getTrack1()
  track2 = music:getTrack2()
  menuTrack = music:getMenuTrack()
  
  menu = Menu()
  
  gameover = Gameover()

  --Game objects
  local background = Background(100)
  table.insert(actorList, background)
  
  local marco = Marco("spr/marco_con_borde_def.png", w/2 - 10, h/2, 0.65)
  table.insert(actorList, marco)
  
  local player = Player("spr/examen.png", w/2, h - h/4, 100, 0.25)
  table.insert(actorList, player)
  
end

function love.update(dt)
  
  if(isIntro) then
    if introTimer > 19 then
      isIntro = false
      isMenu = true
    end
    introTimer = introTimer + dt
  end
  
  if(isMenu) then
    menu:update(dt)
    menuTrack:play()
    if menu:getStartgame() then
      isMenu = false
      isPlaying = true
      menuTrack:stop()
    end
  end
  
  if(isGameover) then
    gameover:update(dt)
    track1:stop()
    track2:stop()
    random = math.random(1,2)
    
    if gameover:getRetry() then
      isGameover = false
      isPlaying = true
      hud = Hud(5)
      gameover:setRetry()
    end
    
  end
  
  if(isPlaying) then
    --update list
    if random == 2 then
      track1:play()
    elseif random == 1 then
      track2:play()
    end
    
    for _,v in ipairs(actorList) do
      v:update(dt, actorList, hud)
    end
    hud:update(dt)
    
    if hud:getHealth() == 0 then
      isGameover = true
      isPlaying = false
    end
  end
end

function love.draw()
    
  if(isIntro) then
    intro:draw()
  end
  
  if(isMenu) then
    menu:draw()
  end
  
  if(isGameover) then
    gameover:draw()
  end
  
  if(isPlaying) then
    for _,v in ipairs(actorList) do
      v:draw()
    end
    hud:draw()
  end
end