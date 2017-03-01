-----------------------------------------------------------------------------------------
--
-- main_scene.lua
-- main start screen
--
-----------------------------------------------------------------------------------------
local composer = require("composer")
local scene = composer.newScene()

-- requires
--local facebook = require( "facebook" )
local widget = require("widget")
local _G = require("global_variables")
_G.init()
local sounds = require("audio_files")
sounds.init()

-- [ Variable ]
local background
local gameLogo
local startButton
local scoreButton
local settingsButton
local rateButton
local companyUrl

local upTransition
local downTransition


local variables={ 
  sceneParams ={},
   
}
-- [ Functions ]
local function animateGameLogo()

    --Logo.isVisible= false
    function Up()

        local _X = math.random(display.contentCenterX * 0.99, display.contentCenterX * 1.02)
        upTransition = transition.to(gameLogo, { time = 1000, x = _X, y = display.contentCenterY * 0.5, transition = easing.outQuad, onComplete = Down })
    end

    function Down()

        local _X = math.random(display.contentCenterX * 0.99, display.contentCenterX * 1.02)
        downTransition = transition.to(gameLogo, { time = 1000, x = _X, y = display.contentCenterY * 0.48, onComplete = Up })
    end

    Down()
end


local function onStartButtonEvent(event)

    if ("ended" == event.phase) then
        print("Start The Game Select Screen")
        composer.gotoScene(_G.killScene, _G.sceneOptions)
    end
end

local function onScoreButtonEvent(event)

    if ("ended" == event.phase) then
        print("Button was pressed and released")
    end
end

local function onSettingsButtonEvent(event)

    if ("ended" == event.phase) then
        print("Button was pressed and released")
    end
end

local function onRateButtonEvent(event)

    if ("ended" == event.phase) then
        print("Button was pressed and released")
    end
end



-- "scene:create()"
function scene:create(event)
    print("Create main Scene --------------------")

    if event.params ~= nil  then
        variables.sceneParams = event.params
     end
    local sceneGroup = self.view

    background = display.newImageRect(_G.IMAGE_PATH .. "main_background.png", _G._W, _G._H)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0

    gameLogo = display.newImageRect(_G.IMAGE_PATH .. "logo.png", 193, 137)
    gameLogo.anchorX = 0.5
    gameLogo.anchorY = 0.5
    gameLogo.x = _G.halfW
    gameLogo.y = _G.halfH * 0.5

    startButton = widget.newButton({
        width = 156,
        height = 45,
        defaultFile = _G.IMAGE_PATH .. "start.png",
        overFile = _G.IMAGE_PATH .. "start_over.png",
        onEvent = onStartButtonEvent
    })

    startButton.anchorX = 0.5
    startButton.anchorY = 0.5
    startButton.x = _G.halfW
    startButton.y = _G.halfH * 1.1

    scoreButton = widget.newButton({
        width = 156,
        height = 45,
        defaultFile = _G.IMAGE_PATH .. "score.png",
        overFile = _G.IMAGE_PATH .. "score_over.png",
        onEvent = onScoreButtonEvent
    })

    scoreButton.anchorX = 0.5
    scoreButton.anchorY = 0.5
    scoreButton.x = _G.halfW
    scoreButton.y = _G.halfH * 1.4

    -- settingsButton = widget.newButton({
    --     width = 156,
    --     height = 45,
    --     defaultFile = _G.IMAGE_PATH .. "start.png",
    --     overFile = _G.IMAGE_PATH .. "start_over.png",
    --     onEvent = onSettingsButtonEvent
    -- })

    -- settingsButton.anchorX = 0.5
    -- settingsButton.anchorY = 0.5
    -- settingsButton.x = _G.halfW
    -- settingsButton.y = _G.halfH * 1.7
    -- sceneGroup:insert( settingsButton )

    rateButton = widget.newButton({
        width = 156,
        height = 45,
        defaultFile = _G.IMAGE_PATH .. "rate.png",
        overFile = _G.IMAGE_PATH .. "rate_over.png",
        onEvent = onRateButtonEvent
    })

    rateButton.anchorX = 0.5
    rateButton.anchorY = 0.5
    rateButton.x = _G.halfW
    rateButton.y = _G.halfH * 1.7

    sceneGroup:insert(background)
    sceneGroup:insert(gameLogo)
    sceneGroup:insert(startButton)
    sceneGroup:insert(scoreButton)
    sceneGroup:insert(rateButton)
end


-- "scene:show()"
function scene:show(event)

    print("Show main Scene --------------------")
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif (phase == "did") then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        if variables.sceneParams ~= nil then

            local params = _G.sceneOptions.params ;
            local lastScene =params.lastScene;
            print(lastScene)

            if lastScene ~= nil and lastScene ~= "" then
                composer.removeScene(lastScene , true);
                --composer.removeHidden() ;  -- Completely removes all scenes except for the currently active scene

            end
        end
        animateGameLogo()
    end
end


-- "scene:hide()"
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase
    print("Hide main Scene --------------------")

    if (phase == "will") then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.

        if upTransition then
            transition.cancel(upTransition)
        end

        if downTransition then
            transition.cancel(downTransition)
        end

    elseif (phase == "did") then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy(event)
    print("Distroy main Scene --------------------")

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.

    if upTransition then
        transition.cancel(upTransition)
        upTransition = nil;
    end

    if downTransition then
        transition.cancel(downTransition)
        downTransition = nil;
    end

    composer.removeScene(_G.mainScene, true)
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

-- -------------------------------------------------------------------------------

return scene