local composer = require( "composer" )
local scene = composer.newScene()

local background
local btn_pelaa
local Handel_btn_pelaa

--CREATE
function scene:create( event )
    local sceneGroup = self.view
    
    background = display.newImageRect("images/menuBG.png", 480, 320)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background)
    
    --HANDLER
    function Handle_btn_pelaa(event)

        if (event.phase == "began") then
            print("Pelataan!")
            composer.gotoScene("game", {effect="slideLeft", time=500})
        end

        return true
    end
    
    local widget = require( "widget" )
    
    btn_pelaa = widget.newButton(
        {
            left = display.contentCenterX-75,
            top = display.contentCenterY,
            id = "btn_pelaa",
            label = "PELAA",
            onEvent = Handle_btn_pelaa,

            shape = "rect",
            width = 150,
            height = 35,
            fillColor = { default={0, 0, 0, 0}, over={0, 0, 0, 0} },
            strokeColor = { default={0.9,0.7,0}, over={ 0, 0, 0, 0.5 } },
            strokeWidth = 1,
            labelColor = { default={0.9,0.7,0,1}, over={ 0, 0, 0, 0.5 } }
        }
    )
    sceneGroup:insert(btn_pelaa)
    
end

--SHOW
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end

--HIDE
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
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