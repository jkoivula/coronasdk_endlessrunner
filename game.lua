local composer = require( "composer" )
local scene = composer.newScene()

-----------------REFERENCES TO VARIABLES
--Objektit
local farBackground
local nearBackground
local player
local btn_hyppy
local level
--Fysiikkamoottori
local physics
--Apumuuttujat
local speed
local holdingJump
local jumpForce
--Tasoblokit, apumuuttujat
local blockDistance
local nextBlockX
local groundLevel
--Funktiot
local Handle_btn_hyppy
local jumping
--CREATE
function scene:create( event )
    local sceneGroup = self.view
    
    -----------------------------LUODAAN PELIN OBJEKTIT(CREATE)-----------------------------
    --TAUSTAKUVAT
    --farBackground, static image
    farBackground = display.newGroup()
    for i=1,2,1 do
        local farBG = display.newImageRect("images/farBG.png", 960, 320)
        farBackground:insert(farBG)
    end
    sceneGroup:insert(farBackground)
    
    --nearBackground, joka sisältää pientä animaatiota
    nearBackground = display.newGroup()
    for i=1,2,1 do
        local nearBackground_sheetOptions =
        {
            width = 960,
            height = 260,
            numFrames = 5
        }

        local sheet_nearBackground = graphics.newImageSheet("spritesheets/nearBGSheetv2.png", nearBackground_sheetOptions)

        local sequences_nearBackground = {
            {
                name = "Default",
                start = 1,
                count = 5,
                time = 800,
                loopCount = 0,
            },
        }

        local nearBG = display.newSprite(sheet_nearBackground, sequences_nearBackground)
        nearBackground:insert(nearBG)
    end
    sceneGroup:insert(nearBackground)
    
    --luodaan pelihahmo
    
    -- ensimäisenä pelihahmo oli vain neliö
    --[[
    player = display.newRect(100,200,30,50)
    player.strokeWidth = 4
    player:setFillColor(0,0,0)
    player:setStrokeColor(0,0.5,0)
    player.isJumping = true

    sceneGroup:insert(player)
    ]]--
    
    --pelihahmon spritesheet
    
    local player_run_sheetOptions =
    {
        width = 80,
        height = 108,
        numFrames = 9
    }

    local sheet_player = graphics.newImageSheet("spritesheets/player_all108v4.png", player_run_sheetOptions)

    local sequences_player = {
        {
            name = "Run",
            start = 1,
            count = 6,
            time = 650,
            loopCount = 0,
        },
        { 
            name = "Jump",
            start = 7,
            count = 2,
            time = 100,
            loopCount = 1,
        },
        { 
            name = "Falling",
            start = 9,
            count = 1,
            time = 150,
            loopCount = 1,
        },
    }

    player = display.newSprite(sheet_player, sequences_player)
    player.isJumping = true
    
    sceneGroup:insert(player)

    --muuttujia
    groundLevel = 300
    local color = 0.3

    blockDistance = 150

    -- UUSI TASO(BLOCK)
    --[[
    blocks1 = display.newGroup()
    nextBlockX = display.contentCenterX
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
        print(blocks1[1].id)
    end
    
    local finishLineBlock = display.newRect(nextBlockX-display.contentWidth,groundLevel-50,50,50)
    finishLineBlock.name = "finishline"
    blocks1:insert(finishLineBlock)
    --sceneGroup:insert(finishLineBlock)
    sceneGroup:insert(blocks1)
    ]]--
    
    ------------------------------TESTS
    --[[
    local testbx = display.newRect(300, 90, 50, 15)
    
    local startX = 70
    local level1 = display.newGroup()
    local blockGroup = display.newGroup()
    
    numBlocks = math.random(5)
    for i=1,numBlocks,1 do
        local block = display.newImageRect("images/baseblock1.png", 80, 15)
        block.x = startX
        block.y = 160
        
        startX = block.x + block.width
        block.name = "block" .. i
        blockGroup:insert(block)
    end
    level1:insert(blockGroup)
    ]]--
    
    --[[
    -----------------------------LUODAAN TASO
    --Pelitaso generoidaan ransomisti tietyillä ehdoilla. Pelitaso on ryhmä 'level', joka sisältää useita(rand. laskettu) 
    --määrän blockGroup-ryhmiä, jotka sisältävät satunnaisen valikoidun määrän tasokkeita
    
    --Apumuuttujia
    local groundMin = 270
    local groundMax = 160
    local groundLevel = groundMin
    local blockdistanceMin = 120
    local blockdistanceMax = 200
    local blockdistance = blockdistanceMin
    --local nextblockX = 70
    local nextblockX
    
    level = display.newGroup()
    
    local startGroundblock = display.newImageRect("images/groundblock.png", 720, 60)
    startGroundblock.x = display.contentCenterX + (startGroundblock.width/6)
    startGroundblock.y = groundLevel + (startGroundblock.height/2)
    local startBlockGroup = display.newGroup()
    startBlockGroup:insert(startGroundblock)
    level:insert(startBlockGroup)
    
    nextblockX = startGroundblock.width + blockdistance
    
    local blockNum = math.random(8, 20)
    for i=1, blockNum, 1 do
        
        local blockGroup = display.newGroup()
        local blocksNum = math.random(1, 4)
        local blocksHeight = math.random(groundMax, groundMin)
        blockdistance = math.random(blockdistanceMin, blockdistanceMax)
        
        --Luodaan tasokkeen alkuun 'start'-blokki
        local startBlock = display.newImageRect("images/baseblockStart.png", 16, 15)
        startBlock.x = nextblockX
        startBlock.y = blocksHeight
        blockGroup:insert(startBlock)
        nextblockX = nextblockX + startBlock.width*3
        
        --Luodaan väliblokit
        for a=1, blocksNum, 1 do
            
            local block = display.newImageRect("images/baseblock.png", 80, 15)
            block.x = nextblockX
            block.y = blocksHeight

            nextblockX = block.x + block.width
            block.name = "block" .. i
            blockGroup:insert(block)
        end
        
        --Luodaan tasokkeen loppuun 'end'-blokki
        local endBlock = display.newImageRect("images/baseblockEnd.png", 16, 15)
        endBlock.x = nextblockX - (blockGroup[2].width/2 - endBlock.width/2)
        endBlock.y = blocksHeight
        blockGroup:insert(endBlock)
        
        --Sijoitetaan blokkiryhmä leveliin(tasoon)
        level:insert(blockGroup)
        nextblockX = nextblockX + blockdistance
    end
    
    local endGroundblock = display.newImageRect("images/groundblock.png", 720, 60)
    local endBlockGroup = display.newGroup()
    endGroundblock.x = nextblockX + (endGroundblock.width/2)
    endGroundblock.y = groundLevel + (endGroundblock.height/2)
    endGroundblock:scale(-1, 1)
    endBlockGroup:insert(endGroundblock)
    level:insert(endBlockGroup)
    sceneGroup:insert(level)
    ]]--
    
    -----------------------------------PHYSICS------------------------------------
    physics = require("physics")

    physics.start()
    physics.pause()
    --physics.setDrawMode("hybrid")

    --LEVELIIN FYSIIKKAA
    --[[
    for i=1,level.numChildren,1 do
        local bGroup = level[i]
        for a=1,bGroup.numChildren,1 do
            physics.addBody(bGroup[a], "static", {bounce=0})
        end
    end
    ]]--
    local playerShape = { 23,-45, -25,55, 15,55, }
    physics.addBody(player, "dynamic", {bounce=0, density=0.045, shape=playerShape})
    --lukitaan pelihahmon kiertäminen, jotta se ei hyppyjen jälkeen 'kaadu'
    player.isFixedRotation = true
    player.isSleepingAllowed = false

    physics.setGravity( 0, 30 )
    
    -----------------------------------WIDGETS------------------------------------
    --HANDLER
    function Handle_btn_hyppy(event)

        if (event.phase == "began" and player.isJumping == false) then
            holdingJump = true
            player.isJumping = true
            print("Holding jump")
            
            player:setSequence("Jump")
            player:play()

        end
        if (event.phase == "ended" and holdingJump == true) then
            
            print("Not holding jump")
            if player.isJumping == true then
                player:setSequence("Falling")
                player:play()
            end

            holdingJump = false
            jumpForce = -1
            
        end

        return true
    end
    
    -- Luodaan HYPPY-nappi
    local widget = require( "widget" )
    
    btn_hyppy = widget.newButton(
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
    sceneGroup:insert(btn_hyppy)
    
end

--SHOW
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        
    ----------------------------------ASETETAAN OBJEKTIEN SIJAINNIT UUDELLEEN---------------------------
        
        farBackground[1].x = display.contentCenterX*2
        farBackground[1].y = display.contentCenterY
        farBackground[2].x = display.contentCenterX*4 + display.contentWidth
        farBackground[2].y = display.contentCenterY
        
        nearBackground[1].x = display.contentCenterX*2
        nearBackground[1].y = display.contentCenterY+60
        nearBackground[2].x = display.contentCenterX*4 + display.contentWidth
        nearBackground[2].y = display.contentCenterY+60
        
        player.x = 110
        player.y = 50
        player:setLinearVelocity( 0, 0 )
        
        
        -----------------------------LUODAAN TASO
        --Pelitaso generoidaan ransomisti tietyillä ehdoilla. Pelitaso on ryhmä 'level', joka sisältää useita(rand. laskettu) 
        --määrän blockGroup-ryhmiä, jotka sisältävät satunnaisen valikoidun määrän tasokkeita

        --Apumuuttujia
        local groundMin = 270
        local groundMax = 160
        local groundLevel = groundMin
        local blockdistanceMin = 120
        local blockdistanceMax = 200
        local blockdistance = blockdistanceMin
        --local nextblockX = 70
        local nextblockX

        level = display.newGroup()

        local startGroundblock = display.newImageRect("images/groundblock.png", 720, 60)
        startGroundblock.x = display.contentCenterX + (startGroundblock.width/6)
        startGroundblock.y = groundLevel + (startGroundblock.height/2)
        local startBlockGroup = display.newGroup()
        startBlockGroup:insert(startGroundblock)
        level:insert(startBlockGroup)

        nextblockX = startGroundblock.width + blockdistance

        local blockNum = math.random(5, 16)
        for i=1, blockNum, 1 do

            local blockGroup = display.newGroup()
            local blocksNum = math.random(1, 4)
            local blocksHeight = math.random(groundMax, groundMin)
            blockdistance = math.random(blockdistanceMin, blockdistanceMax)

            --Luodaan tasokkeen alkuun 'start'-blokki
            local startBlock = display.newImageRect("images/baseblockStart.png", 16, 15)
            startBlock.x = nextblockX
            startBlock.y = blocksHeight
            blockGroup:insert(startBlock)
            nextblockX = nextblockX + startBlock.width*3

            --Luodaan väliblokit
            for a=1, blocksNum, 1 do

                local block = display.newImageRect("images/baseblock.png", 80, 15)
                block.x = nextblockX
                block.y = blocksHeight

                nextblockX = block.x + block.width
                block.name = "block" .. i
                blockGroup:insert(block)
            end

            --Luodaan tasokkeen loppuun 'end'-blokki
            local endBlock = display.newImageRect("images/baseblockEnd.png", 16, 15)
            endBlock.x = nextblockX - (blockGroup[2].width/2 - endBlock.width/2)
            endBlock.y = blocksHeight
            blockGroup:insert(endBlock)

            --Sijoitetaan blokkiryhmä leveliin(tasoon)
            level:insert(blockGroup)
            nextblockX = nextblockX + blockdistance
        end

        local endGroundblock = display.newImageRect("images/groundblock.png", 720, 60)
        local endBlockGroup = display.newGroup()
        endGroundblock.x = nextblockX + (endGroundblock.width/2)
        endGroundblock.y = groundLevel + (endGroundblock.height/2)
        endGroundblock:scale(-1, 1)
        endBlockGroup:insert(endGroundblock)
        level:insert(endBlockGroup)
        sceneGroup:insert(level)
        
        for i=1,level.numChildren,1 do
            local bGroup = level[i]
            for a=1,bGroup.numChildren,1 do
                physics.addBody(bGroup[a], "static", {bounce=0})
            end
        end
        
        --Tuodaan 'HYPPY'-painike eteen
        btn_hyppy:toFront()
        
        --Nopeuden säätö
        speed = 14
        
        
    elseif ( phase == "did" ) then
        
        --Fysiikat päälle ja taustat pyörimään
        physics.start(true)
        nearBackground[1]:play()
        nearBackground[2]:play()
        
        ----------------------------FUNKTIOT-------------------------------------------
        holdingJump = false
        jumpForce = -1
        local jumpTime = 200
        
        local function jump(force)
            if holdingJump then
                player:applyForce(0, force, player.x, player.y)
            end
        end

        
        local function jumping(event)
            if holdingJump then
                if jumpForce == -1 then

                    timer.performWithDelay(1, jump(-25), 1)
                    --jumpForce = jumpForce - 1

                elseif jumpForce <= -3 and jumpForce > -12 then

                    timer.performWithDelay(100, jump(-3.5), 1)
                    --jumpForce = jumpForce - 1
                    --jumpTime = jumpTime + 100
                end
                jumpForce = jumpForce - 1
            end
        end
        
        
        local function playerOffScreen(event)
            if player.y > display.contentHeight + (player.height/2) then
                composer.gotoScene("levelover", {effect="slideLeft", time=500})
            end
            if player.x < (0 - (player.width/2)) then
                composer.gotoScene("levelover", {effect="slideLeft", time=500})
            end
        end
        
        local function updateLevel()
            for i=1, level.numChildren,1 do
                local bGroup = level[i]
                for a=1,bGroup.numChildren,1 do
                    bGroup[a].x = bGroup[a].x - (speed/1.3)
                end
            end
        end
        
        local function updateBackgrounds()
            for i=1,2,1 do
                --far background movement
                farBackground[i].x = farBackground[i].x - (speed/10)

                --near background movement
                nearBackground[i].x = nearBackground[i].x - (speed/3.5)

                --if the sprite has moved off the screen move it back to the
                --other side so it will move back on
                if(farBackground[i].x < -479) then
                farBackground[i].x = 1436
                end
                
                if(nearBackground[i].x < -479) then
                nearBackground[i].x = 1436
                end
            end

        end

        ----------------------------EVENTLISTENERS-------------------------------------
        local function playerBlockCollision(self, event)
            if (event.phase == "began" ) then    
                print("Pelaaja on maassa.")
                if player.isJumping then
                    player:setSequence( "Run" )
                    player:play()
                end
                player.isJumping = false
                
                if (event.other.name == "finishline") then
                    composer.gotoScene("levelover", {effect="slideLeft", time=500})
                end
            end
        end

        player.collision = playerBlockCollision
        player:addEventListener("collision", player)
        Runtime:addEventListener( "enterFrame", jumping )
        Runtime:addEventListener( "enterFrame", playerOffScreen )

        ----------------------------PELILOOP-PÄIVITTÄÄ-RUUTUA--------------------------
        local function update( event )
            updateBackgrounds()
            updateLevel()
        end
        
     
        --PELILOOPPI
        timerUpdate = timer.performWithDelay(1, update, -1)
               
    end
end

--HIDE
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        
        timer.cancel(timerUpdate)
        display.remove(level)
        player:removeEventListener("collision", player)
        Runtime:removeEventListener( "enterFrame", jumping )
        Runtime:removeEventListener( "enterFrame", playerOffScreen )
        
    elseif ( phase == "did" ) then
    end
end

--DESTROY
function scene:destroy( event )
    local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene