-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Joni Koivula Mobiilipeli
-- Your code here

--luodaan pelihahmo
local player = display.newRect(100,200,30,50)
player.strokeWidth = 4
player:setFillColor(0,0,0)
player:setStrokeColor(0,0.5,0)
player.isJumping = true

--ryhmiä
local blocks = display.newGroup()
 
--muuttujia
local groundMin = 300
local groundMax = 340
local groundLevel = groundMin
local speed = 6

local color = 0.3

--luodaan tasoblokit
local blockDistance = 150
--[[
for a = 1, 2, 1 do
    --numGen = math.random(2)
    local newBlock

    if (a == 1) then
        newBlock = display.newRect(display.contentCenterX,groundLevel,display.contentWidth,50)
    else
        newBlock = display.newRect(display.contentCenterX*(a*1.5),groundLevel,display.contentWidth,50)
    end
    
    newBlock.name = ("block" .. a)
    newBlock.id = a
    print (newBlock.name)

    newBlock:setFillColor(color,0,0)
    color = color + 0.3
    
    blocks:insert(newBlock)
end
]]--
-- UUSI TASO(BLOCK)

local blocks1 = display.newGroup()
local nextBlockX = display.contentCenterX
for a = 1, 4, 1 do
    --numGen = math.random(2)
    local newBlock
    
    newBlock = display.newRect(nextBlockX,groundLevel,display.contentWidth,50)
    
    nextBlockX = nextBlockX + display.contentWidth + blockDistance
    
    newBlock.name = ("block" .. a)
    newBlock.id = a
    print (newBlock.name)

    newBlock:setFillColor(color,0,0.4)
    color = color + 0.2
    
    blocks1:insert(newBlock)
end
local finishLineBlock = display.newRect(nextBlockX-display.contentWidth,groundLevel-50,50,50)
blocks1:insert(finishLineBlock)

----------------------------PHYSICS--------------------------------------------
local physics = require("physics")

physics.start()
--physics.setDrawMode("hybrid")

--lisätään blokkeihin fysiikka for-loopilla
for i=1,blocks1.numChildren,1 do
    physics.addBody(blocks1[i], "static", {bounce=0})
end

physics.addBody(player, "dynamic", {bounce=0})
--lukitaan pelihahmon kiertäminen, jotta se ei hyppyjen jälkeen 'kaadu'
player.isFixedRotation = true


physics.setGravity( 0, 16 )

----------------------------HYPPYNAPPI-----------------------------------------
local holdingJump = false
local jumpForce = -1

local function jump(force)
    player:applyForce(0, force, player.x, player.y)
end


local function jumping(event)
    if holdingJump and jumpForce >= -10 then
        print("Jump" .. jumpForce)
        
        if jumpForce == -1 then
            jump(-5)
        elseif jumpForce >= -10 and jumpForce < -3 then
            jump(-0.4)
        end
        
        jumpForce = jumpForce -1

    end
end

local widget = require( "widget" )

--Hypyn korkeutta tarkkailee Runtime:Eventlistener, seuraamalla holdingJump-muuttujan tilaa
local function Handle_btn_hyppy(event)
    
    if (event.phase == "began" and player.isJumping == false) then
        holdingJump = true
        print("Holding jump")
        
    end
    if (event.phase == "ended" and holdingJump == true) then
        holdingJump = false
        player.isJumping = true
        jumpForce = -1
        print("Not holding jump")
        
    end
    
    return true
end

-- Luodaan HYPPY-nappi
local btn_hyppy = widget.newButton(
    {
        left = 20,
        top = 281,
        id = "btn_hyppy",
        label = "HYPPÄÄ",
        onEvent = Handle_btn_hyppy,
        
        shape = "roundedRect",
        width = 90,
        height = 30,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 4
    }
)

----------------------------PELILOOP-PÄIVITTÄÄ-RUUTUA--------------------------
local function update( event )
updateBlocks()
-- Incrementally increases the speed
--speed = speed + .05
end
 
----------------------------FUNKTIOT-------------------------------------------
function updateBlocks()
    for a = 1, blocks1.numChildren, 1 do
        
        local seq = 1
        local offscreen = display.contentWidth-(display.contentWidth*1.5)+1
        --print(offscreen)
        blocks1[a].x = blocks1[a].x - (speed)
        --[[
        if(blocks[a].x < offscreen) then
            blocks[a].x = display.contentWidth*1.5+150
            seq = 2
        end
        ]]--
    end
end

----------------------------EVENTLISTENERS-------------------------------------
local function playerBlockCollision(self, event)
    if (event.phase == "began") then    
            print("Pelaaja on maassa.")
            player.isJumping = false
        end 
end
local function isPlayerFalling()
    
end

-- ADDING EVENTLISTENERS
player.collision = playerBlockCollision
player:addEventListener("collision", player)

Runtime:addEventListener( "enterFrame", jumping )

--
--
--this is how we call the update function, make sure that this line comes after the
--actual function or it will not be able to find it
--timer.performWithDelay(how often it will run in milliseconds, function to call,
--how many times to call(-1 means forever))
--
--
--PELILOOPPI
timer.performWithDelay(1, update, -1)
