-----------------------------------------------------------------------------------------
--
-- main_scene.lua
-- main start screen
--
-----------------------------------------------------------------------------------------
local composer = require("composer")
local scene = composer.newScene()

-- requires
local widget = require("widget")
local _G = require("global_variables")
_G.init()
local sounds = require("audio_files")
sounds.init()

-- [ Variable ]
local background
local gameLogo
local candyButton
local massacareButton
local surviveButton
local bugButton

local function onCandyButtonEvent(event)

    if ("began" == event.phase) then
        event.target.xScale = 1.1
        event.target.yScale = 1.1
    end

    if ("ended" == event.phase) then
        event.target.xScale = 1.0
        event.target.yScale = 1.0

        composer.gotoScene(_G.candyScene, _G.sceneOptions)
    end
end

local function onMassacareButtonEvent(event)

    if ("began" == event.phase) then
        event.target.xScale = 1.1
        event.target.yScale = 1.1
    end

    if ("ended" == event.phase) then
        event.target.xScale = 1.0
        event.target.yScale = 1.0
    end
end

local function onSurviveButtonEvent(event)

    if ("began" == event.phase) then
        event.target.xScale = 1.1
        event.target.yScale = 1.1
    end

    if ("ended" == event.phase) then
        event.target.xScale = 1.0
        event.target.yScale = 1.0
    end
end

local function onBugZillaButtonEvent(event)

    if ("began" == event.phase) then
        event.target.xScale = 1.2
        event.target.yScale = 1.2
    end

    if ("ended" == event.phase) then
        event.target.xScale = 1.0
        event.target.yScale = 1.0
    end
end



-- "scene:create()"
function scene:create(event)

    local sceneGroup = self.view

    background = display.newImageRect(_G.IMAGE_PATH .. "main_background.png", _G._W, _G._H)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0

    candyButton = widget.newButton({
        width = 100,
        height = 100,
        defaultFile = _G.IMAGE_PATH .. "candy.png",
        overFile = _G.IMAGE_PATH .. "candy.png",
        onEvent = onCandyButtonEvent
    })

    candyButton.anchorX = 0.5
    candyButton.anchorY = 0.5
    candyButton.x = _G.halfW * 0.75
    candyButton.y = _G.halfH * 0.6

    massacareButton = widget.newButton({
        width = 100,
        height = 100,
        defaultFile = _G.IMAGE_PATH .. "massacare.png",
        overFile = _G.IMAGE_PATH .. "massacare.png",
        onEvent = onMassacareButtonEvent
    })

    massacareButton.anchorX = 0.5
    massacareButton.anchorY = 0.5
    massacareButton.x = _G.halfW * 1.25
    massacareButton.y = _G.halfH * 0.6

    surviveButton = widget.newButton({
        width = 100,
        height = 100,
        defaultFile = _G.IMAGE_PATH .. "survive.png",
        overFile = _G.IMAGE_PATH .. "survive.png",
        onEvent = onSurviveButtonEvent
    })

    surviveButton.anchorX = 0.5
    surviveButton.anchorY = 0.5
    surviveButton.x = _G.halfW * 0.75
    surviveButton.y = _G.halfH * 1.3

    bugButton = widget.newButton({
        width = 100,
        height = 100,
        defaultFile = _G.IMAGE_PATH .. "bugzillla.png",
        overFile = _G.IMAGE_PATH .. "bugzillla.png",
        onEvent = onBugZillaButtonEvent
    })

    bugButton.anchorX = 0.5
    bugButton.anchorY = 0.5
    bugButton.x = _G.halfW * 1.25
    bugButton.y = _G.halfH * 1.3

    sceneGroup:insert(background)
    sceneGroup:insert(candyButton)
    sceneGroup:insert(massacareButton)
    sceneGroup:insert(surviveButton)
    sceneGroup:insert(bugButton)
end


-- "scene:show()"
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif (phase == "did") then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif (phase == "did") then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy(event)

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.

    composer.removeScene(_G.gameSelectScene, true)
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

-- -------------------------------------------------------------------------------

return scene