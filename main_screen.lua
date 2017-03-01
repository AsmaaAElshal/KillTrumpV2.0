----------------------------------------------------------------------------------
--
-- Copyright Jodod Technology Labs 2013.
-- @author Mohammed Fathy.
-- @date 21 November, 2013.
-- @description : Pause Screen.
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = {}
local ui = require("libs.ui")
local widget = require("widget")
local json = require"json"
local _G = require("global_variables")
--_G.init();


----------------------------------------------------------------------------------
--
--	NOTE:
--
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

--  [ Constants ]
local _W = display.contentWidth;
local _H = display.contentHeight;
local CURRENT_VIEW = "src.common.pause_screen";
local NEXT_VIEW = "";
local PREVIOUS_VIEW = "";

local IMAGE_PATH = "res/images/common/pause_screen/";
local SETTING_IMAGE_PATH = "res/images/common/settings_screen/";
local JSON_PATH = "";
local XML_PATH = "";

--	[ Variables ]
local background
local backButton
local resumeButton
local menuButton
local restartButton

local objects={}
--	[ Functions ]
local onBackButtonRelease = {}
local onResumeButtonRelease = {}
local onMenuttonRelease = {}
local onRestartButtonRelease = {}

 
--	[ Functions Implementation ]
function onBackButtonRelease( ... )
    -- body
end

function onStartButtonRelease( ... )
    onStartButtonPressed();
    return true;
end

function onMenuttonRelease( ... )
    print("MAIN MENU")
    onMenuttonPressed();
    return true;
end

function onRestartButtonRelease( ... )
    onRestartButtonPressed();
    return true;

end
local function animateGameLogo()

    --Logo.isVisible= false
    function Up()
        print("UP.../////////////")

        local _X = math.random(display.contentCenterX * 0.99, display.contentCenterX * 1.02)
        if objects.gameLogo.upTransition ~= nil then
            transition.cancel(objects.gameLogo.upTransition);
            objects.gameLogo.upTransition = nil;
        end
        objects.gameLogo.upTransition = transition.to(objects.gameLogo, { time = 1000, x = _X, y = display.contentCenterY * 0.5, transition = easing.outQuad, onComplete = Down })
    end

    function Down()
        local _X = math.random(display.contentCenterX * 0.99, display.contentCenterX * 1.02)
        if objects.gameLogo.downTransition ~= nil then
            transition.cancel(objects.gameLogo.downTransition);
            objects.gameLogo.downTransition = nil;
        end
        objects.gameLogo.downTransition = transition.to(objects.gameLogo, { time = 1000, x = _X, y = display.contentCenterY * 0.48, onComplete = Up })
    end

    Down()
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = display.newGroup( );

    --	Background
    objects.background = display.newImageRect(_G.IMAGE_PATH .. "main_background.png", _G._W, _G._H)
    objects.background.anchorX = 0
    objects.background.anchorY = 0
    objects.background.x = 0
    objects.background.y = 0

    group:insert(objects.background)
    
    ---------- Logo 

    objects.gameLogo = display.newImageRect(_G.IMAGE_PATH .. "logo.png", 193, 137)
    objects.gameLogo.anchorX = 0.5
    objects.gameLogo.anchorY = 0.5
    objects.gameLogo.x = _G.halfW
    objects.gameLogo.y = _G.halfH * 0.5
    objects.gameLogo.upTransition = nil;
    objects.gameLogo.downTransition = nil;


    group:insert(objects.gameLogo);

    ----------- Start Button
    objects.startButton = widget.newButton({
        width = 156,
        height = 45,
        defaultFile = _G.IMAGE_PATH .. "start.png",
        overFile = _G.IMAGE_PATH .. "start_over.png",
        onEvent = onStartButtonRelease
    })

    objects.startButton.anchorX = 0.5
    objects.startButton.anchorY = 0.5
    objects.startButton.x = _G.halfW
    objects.startButton.y = _G.halfH * 1.1

    group:insert(objects.startButton);

    ---------Score Button

    objects.scoreButton = widget.newButton({
        width = 156,
        height = 45,
        defaultFile = _G.IMAGE_PATH .. "score.png",
        overFile = _G.IMAGE_PATH .. "score_over.png",
        onEvent = onScoreButtonEvent
    })

    objects.scoreButton.anchorX = 0.5
    objects.scoreButton.anchorY = 0.5
    objects.scoreButton.x = _G.halfW
    objects.scoreButton.y = _G.halfH * 1.4

    group:insert(objects.scoreButton);


    objects.rateButton = widget.newButton({
        width = 156,
        height = 45,
        defaultFile = _G.IMAGE_PATH .. "rate.png",
        overFile = _G.IMAGE_PATH .. "rate_over.png",
        onEvent = onRateButtonEvent
    })

    objects.rateButton.anchorX = 0.5
    objects.rateButton.anchorY = 0.5
    objects.rateButton.x = _G.halfW
    objects.rateButton.y = _G.halfH * 1.7

    group:insert(objects.rateButton)
    animateGameLogo();


    

    return group;
end
function scene:show( event )
    -- body
    print("SHowwwwwwwwwwwwwwwwwww")
    if (phase == "will") then
      -- Called when the scene is still off screen (but is about to come on screen).
    
      
    elseif (phase == "did") then
        
    end

end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view
    local  background = objects.background ;
    local  gameLogo = objects.gameLogo ;
    local  startButton = objects.startButton ;
    local  scoreButton = objects.scoreButton ;


    if objects.background then
        objects.background:removeSelf( );
        objects.background = nil;
    end

    if objects.gameLogo then
        
        if objects.gameLogo.upTransition ~= nil then
            transition.cancel(objects.gameLogo.upTransition);
            objects.gameLogo.upTransition = nil;
        end
        if objects.gameLogo.downTransition ~= nil then
            transition.cancel(objects.gameLogo.downTransition);
            objects.gameLogo.downTransition = nil;
        end

        objects.gameLogo:removeSelf( )
        objects.gameLogo = nil;
    end

    if objects.startButton then
        objects.startButton:removeSelf( );
        objects.startButton = nil;
    end

    if objects.scoreButton then
        objects.scoreButton:removeSelf( );
        objects.scoreButton = nil;
    end
    
    if objects.rateButton then
        objects.rateButton:removeSelf( );
        objects.rateButton = nil;
    end


    if group then
        group:removeSelf( );
        group = nil;
    end
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
-- scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
-- scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
-- scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
-- scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene