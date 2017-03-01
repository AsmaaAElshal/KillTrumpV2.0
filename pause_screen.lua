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

--	[ Functions ]
local onBackButtonRelease = {}
local onResumeButtonRelease = {}
local onMenuttonRelease = {}
local onRestartButtonRelease = {}

 
--	[ Functions Implementation ]
function onBackButtonRelease( ... )
    -- body
end

function onResumeButtonRelease( ... )
    onResumeButtonPressed();
    return true;
end

function onMenuButtonRelease( ... )
    onMenuButtonPressed();
    return true;
end

function onRestartButtonRelease( ... )
    onRestartButtonPressed();
    return true;

end
-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = display.newGroup( );

    --	Background
    background = display.newImageRect(IMAGE_PATH .. "background.png", _W*1.3, _H*1.3 );
    --background:setReferencePoint( display.CenterReferencePoint );
    background.x = display.contentCenterX;
    background.y = display.contentCenterY;

    --	Buttons
    resumeButton = ui.newButton{
        defaultSrc = IMAGE_PATH .. "resume_button.png",
        overSrc = IMAGE_PATH .. "resume_button.png",
        defaultX = 64,
        defaultY = 66,
        overX = 64,
        overY = 66,
        overScale = 1.1,
        onEvent = onResumeButtonRelease,
        id = "resume_button"
    }
    --resumeButton:setReferencePoint( display.CenterReferencePoint );
    resumeButton.x = display.contentCenterX;
    resumeButton.y = display.contentCenterY;

    menuButton = ui.newButton{
        defaultSrc = IMAGE_PATH .. "menu_button.png",
        overSrc = IMAGE_PATH .. "menu_button.png",
        defaultX = 65,
        defaultY = 66,
        overX = 65,
        overY = 66,
        overScale = 1.1,
        onEvent = onMenuButtonRelease,
        id = "menu_button"
    }

    --menuButton:setReferencePoint( display.CenterReferencePoint );
    menuButton.x = resumeButton.x - resumeButton.width;
    menuButton.y = display.contentCenterY;

    restartButton = ui.newButton{
        defaultSrc = IMAGE_PATH .. "restart_button.png",
        overSrc = IMAGE_PATH .. "restart_button.png",
        defaultX = 65,
        defaultY = 66,
        overX = 65,
        overY = 66,
        overScale = 1.1,
        onEvent = onRestartButtonRelease,
        id = "restart_button"
    }

    --restartButton:setReferencePoint( display.CenterReferencePoint );
    restartButton.x = resumeButton.x + resumeButton.width;
    restartButton.y = display.contentCenterY;

    group:insert( background )
    group:insert( resumeButton )
    group:insert( menuButton )
    group:insert( restartButton )

    return group;
end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view

    if background then
        background:removeSelf( );
        background = nil;
    end

    if resumeButton then
        resumeButton:removeSelf( )
        resumeButton = nil;
    end

    if menuButton then
        menuButton:removeSelf( );
        menuButton = nil;
    end

    if restartButton then
        restartButton:removeSelf( );
        restartButton = nil;
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