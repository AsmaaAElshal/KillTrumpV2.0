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

local physics  = require ("physics")
physics.start()
-- physics.setDrawMode ( "hybrid" ) -- Uncomment in order to show in hybrid mode
physics.setGravity( 0, 9.8 * 2)

physics.start()

-- [ Variable ]
local background
local scoreValue
local hole
local bugs = display.newGroup()
local splashGroup = display.newGroup()
local bugObjects = {}
local dead_bugObjects = {}
local bug
local bug_names = { "normal", "elite", "king" };
local bug_dead_names = { "normal_dead", "elite_dead", "king_dead" };
local bug_dead_names_1 = { "normal_dead_1", "elite_dead_1", "king_dead_1" };
local bug_dead_names_2 = { "normal_dead_2", "elite_dead_2", "king_dead_2" };

local splashImgs={"splash1.png", "splash2.png", "splash3.png"};
local cruch_Sounds = { sounds.crushNormal, sounds.crushElite, sounds.crushKing }
local bugTransition1
local bugTransition2
local bugTransition3
local bugTransition4

-- Splash properties
local splashFadeTime = 2500
local splashFadeDelayTime = 5000
local splashInitAlpha = .5
local splashSlideDistance = 50 -- The amoutn of of distance the splash slides down the background

-- Gush filter should not interact with other fruit or the catch platform
local gushProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 4, maskBits = 8} }

-- Gush properties
local minGushRadius = 10
local maxGushRadius = 25
local numOfGushParticles = 15
local gushFadeTime = 500
local gushFadeDelay = 500

local minGushVelocityX = -350
local maxGushVelocityX = 350
local minGushVelocityY = -350
local maxGushVelocityY = 350

-- Slash line properties (line that shows up when you move finger across the screen)
local maxPoints = 5
local lineThickness = 10
local lineFadeTime = 250
local endPoints = {}

local slashSounds = {slash1 = audio.loadSound("slash1.wav"), slash2 = audio.loadSound("slash2.wav"), slash3 = audio.loadSound("slash3.wav")}
local slashSoundEnabled = true -- sound should be enabled by default on startup
local minTimeBetweenSlashes = 150 -- Minimum amount of time in between each slash sound
local minDistanceForSlashSound = 50 -- Amount of pixels the users finger needs to travel in one frame in order to play a slash sound


-- [ Functions ]
local function buildLevel(...)

    for i = 1, 20 do
        local bugIndex = math.random(1, 3);
        bug = display.newImageRect(_G.IMAGE_PATH .. bug_names[bugIndex] .. ".png", 160, 149);
        bug.anchorX = 0.5;
        bug.anchorY = 0.5;

        bug.x = _G.halfW * bugIndex;
        -- bug.y = _G.halfH ;
        -- bug.x = math.random(0, _G._W * 4)  ;
        bug.y = -100 ;
        bug.rotation = 180 ;
        bugs.xScale = 0.4 ;
        bugs.yScale = 0.4 ;
        bug.index = bugIndex ;
        bug.i = i ;
        bug._1 = bug_dead_names_1[bugIndex] ;
        bug._2 = bug_dead_names_2[bugIndex] ;
        bugs:insert( bug ) ;
        bug:toFront();
        bugObjects[i] = bug ;
    end
end

local function bugWalking(bugObject)

    local target = bugObject
    local moveUp
    local moveDown

    function moveUp()
        if target then
            bugTransition1 = transition.to(target, { time = 50, rotation = target.rotation + 5, onComplete = moveDown })
        end
    end

    function moveDown()
        if target then
            bugTransition2 = transition.to(target, { time = 50, rotation = target.rotation - 5, onComplete = moveUp })
        end
    end

    moveUp()
end

local function bugMovement(bugObject, delayTime)
    local target = bugObject
    local _delay = delayTime
    local _X = math.random(_G._W * 0.25, _G._W * 4)
    local _Y = math.random(_G._H * 4.2, _G._H * 5)

    local _TIME = math.random(_G.gameSpeed * 1000, _G.gameSpeed * 2000)

    function move(target)
        bugTransition4 = transition.to(target, { time = _TIME, delay = _delay, x = _X, y = _Y })
    end

    move(target)
end

local function gameLogic(bugObject)
    local target = bugObject
    target:addEventListener("touch", onTouchBugEvent)
   -- target:addEventListener("tap", onTapBugEvent)
end
-- Creates a gushing effect that makes it look like juice is flying out of the fruit
function createGush(bug)

    local i
    for  i = 0, numOfGushParticles do
        local gush = display.newCircle( bug.x, bug.y, math.random(minGushRadius, maxGushRadius) )
        gush.anchorX = 0.5;
        gush.anchorY = 0.5;
        gush.x = bug.x;
        gush.y =  bug.y;
        gush:setFillColor(255, 0, 0, 255)

        gushProp.radius = gush.width / 2
        physics.addBody(gush, "dynamic", gushProp)

        local xVelocity = math.random(minGushVelocityX, maxGushVelocityX)
        local yVelocity = math.random(minGushVelocityY, maxGushVelocityY)

        gush:setLinearVelocity(xVelocity, yVelocity)

        transition.to(gush, {time = gushFadeTime, delay = gushFadeDelay, width = 0, height = 0, alpha = 0, onComplete = function(event) gush:removeSelf() end})
        bugs:insert(gush)
    end

end
function getRandomSplash()

    return display.newImage(_G.IMAGE_PATH .. splashImgs[math.random(1, #splashImgs)])
end
function createSplash(bug)

    local splash = getRandomSplash();
    splash.anchorX = 0.5;
    splash.anchorY = 0.5;
    splash.x = bug.x;
    splash.y = bug.y;
    splash.rotation = math.random(-90,90)
    splash.alpha = splashInitAlpha
    bugs:insert(splash)
    splash:toBack();

    transition.to(splash, {time = splashFadeTime, alpha = 0,  y = splash.y + splashSlideDistance, delay = splashFadeDelayTime, onComplete = function(event) splash:removeSelf() end})

end
local function  get_target_Bug(bugObject)
    local index = bugObject.i ;
    local target_index ;

    for i =1 , #bugObjects do
        if bugObjects[i].i == index then
            target_index = i ;
        end
    end

    bugObjects[target_index]:removeSelf();
    table.remove(bugObjects , target_index)
end

local function remove_Me( bugObject )
    local removing_Timer = timer.performWithDelay(1000 ,function() bugObject:removeSelf(); end)
end

local function cruch_Me1(bugObject)
    local target = bugObject
    local bugIndex = target.index;
    local dead_bug = display.newImageRect(_G.IMAGE_PATH .. bug_dead_names[bugIndex] .. ".png", 160, 149);
    dead_bug.anchorX = 0.5;
    dead_bug.anchorY = 0.5;
    dead_bug.x = target.x;
    dead_bug.y = target.y;
    dead_bug.rotation = target.rotation;
    --dead_bug.xScale = 0.25 ;
    --dead_bug.yScale = 0.25 ;
    dead_bug.index = bugIndex;
    bugs:insert(dead_bug);
    dead_bug:toBack();

    dead_bugObjects[#dead_bugObjects + 1] = bug   ;
    remove_Me(dead_bug) ;
   -- target:removeSelf();



end

local function cruch_Me(bugObject , touchType)

    local target = bugObject
    local bugIndex = target.index;

    get_target_Bug(target);
    createSplash(target)
    createGush(target);
    ------------------------------------------
    if touchType == "touch" then
            local dead_bug_1 = display.newImage(_G.IMAGE_PATH .. target._1 .. ".png");
            dead_bug_1.anchorX = 0.5;
            dead_bug_1.anchorY = 0.5;

            dead_bug_1.x = target.x - target.contentWidth*0.3;
            dead_bug_1.y = target.y;
            dead_bug_1.rotation = target.rotation;
            dead_bug_1.xScale = 0.75 ;
            dead_bug_1.yScale = 0.75 ;
            dead_bug_1.index = bugIndex;
            bugs:insert(dead_bug_1);
            dead_bug_1:toBack();
            remove_Me(dead_bug_1) ;


            local dead_bug_2 = display.newImage(_G.IMAGE_PATH .. target._2 .. ".png");
            dead_bug_2.anchorX = 0.5;
            dead_bug_2.anchorY = 0.5;

            dead_bug_2.x = target.x + target.contentWidth*0.4;
            dead_bug_2.y = target.y;
            dead_bug_2.rotation = target.rotation;
            dead_bug_2.xScale = 0.75 ;
            dead_bug_2.yScale = 0.75 ;
            dead_bug_2.index = bugIndex;
            bugs:insert(dead_bug_2);
            dead_bug_2:toBack();
            remove_Me(dead_bug_2) ;
    elseif touchType == "tap" then

        cruch_Me1(target)
    end


end
--***************************************************
local function saveValue(strFilename, strValue)
    -- will save specified value to specified file
    local theFile = strFilename
    local theValue = strValue

    local path = system.pathForFile(theFile, system.DocumentsDirectory)

    -- io.open opens a file at path. returns nil if no file found
    local file = io.open(path, "w+")
    if file then
        -- write game score to the text file
        file:write(theValue)
        io.close(file)
    end
end
--***************************************************
-- loadValue() --> load saved value from file (returns loaded value as string)
--***************************************************
local function loadValue(strFilename)
    -- will load specified file, or create new file if it doesn't exist

    local theFile = strFilename

    local path = system.pathForFile(theFile, system.DocumentsDirectory)

    -- io.open opens a file at path. returns nil if no file found
    local file = io.open(path, "r")
    if file then
        -- read all contents of file into a string
        local contents = file:read("*a")
        io.close(file)
        return contents
    else
        -- create file b/c it doesn't exist yet
        file = io.open(path, "w")
        file:write("0")
        io.close(file)
        return "0"
    end
end

function onTouchBugEvent(event )

    if event.phase == "moved" or event.phase == "ended" then
        local x,y , sX ,sY ;
          x = event.x ; y = event.y ;
          sX = event.xStart ; sY = event.yStart ;


         local offsetX =math.abs( x - sX );
         local offsetY =math.abs( y - sY );
        if offsetX > 10  or offsetY > 10 then
             onSmachBug( event.target , "touch")
        else
            onSmachBug( event.target , "tap")

        end

    end
    return true
end
function onTapBugEvent(event )
        onSmachBug( event.target , "tap" )

    return true
end
function onSmachBug( bug , touchType )

         bug:removeEventListener("touch", onTouchBugEvent)
        -- bug:removeEventListener("tap", onTapBugEvent)

        local index = bug.index;
        cruch_Me(bug ,touchType);
        --audio.play( sounds.crushNormal)
        audio.play(cruch_Sounds[index])
        audio.setVolume(0.5, { channel = 2 }) -- set the volume on channel 1
        audio.play(sounds.crushNormal, { channel = 2, loops = 0 });
        local score = tonumber(scoreValue.value)
        score = score + index;
        scoreValue.value = score
        scoreValue:setText(score)
end
-- Draws the slash line that appears when the user swipes his/her finger across the screen
function drawSlashLine(event)

    -- Play a slash sound
    if(endPoints ~= nil and endPoints[1] ~= nil) then
        local distance = math.sqrt(math.pow(event.x - endPoints[1].x, 2) + math.pow(event.y - endPoints[1].y, 2))
        if(distance > minDistanceForSlashSound and slashSoundEnabled == true) then
            slashSoundEnabled = false
            timer.performWithDelay(minTimeBetweenSlashes, function(event) slashSoundEnabled = true end)
        end
    end

    -- Insert a new point into the front of the array
    table.insert(endPoints, 1, {x = event.x, y = event.y, line= nil})

    -- Remove any excessed points
    if(#endPoints > maxPoints) then
        table.remove(endPoints)
    end

    for i,v in ipairs(endPoints) do
        local line = display.newLine(v.x, v.y, event.x, event.y)
        line.width = lineThickness
        transition.to(line, {time = lineFadeTime, alpha = 0, width = 0, onComplete = function(event) line:removeSelf() end})
    end

    if(event.phase == "ended") then
        while(#endPoints > 0) do
            table.remove(endPoints)
        end
    end
end



-- "scene:create()"
function scene:create(event)

    local sceneGroup = self.view

    background = display.newImageRect(_G.IMAGE_PATH .. "level_background.png", _G._W, _G._H)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0

    hole = display.newImageRect(_G.IMAGE_PATH .. "hole.png", _G._W, 50)
    hole.anchorX = 0
    hole.anchorY = 0
    hole.x = 0
    hole.y = 0

    scoreValue = display.newEmbossedText("0", _G.halfW * 1.55, 15, native.systemFont, 22)
    scoreValue:setFillColor(0.5)
    scoreValue:setText("0")
    scoreValue.value = 0;

    local color =
    {
        highlight = { r = 1, g = 1, b = 1 },
        shadow = { r = 0.3, g = 0.3, b = 0.3 }
    }
    scoreValue:setEmbossColor(color)

    sceneGroup:insert(background)
    sceneGroup:insert(bugs)
    sceneGroup:insert(hole)
    sceneGroup:insert(scoreValue)
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
        buildLevel();
        for i = 1, 20 do
            bugMovement(bugObjects[i], 750 * i)
            bugWalking(bugObjects[i])
            gameLogic(bugObjects[i])
        end
        Runtime:addEventListener("touch", drawSlashLine)


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

    composer.removeScene(_G.candyScene, true)
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

-- -------------------------------------------------------------------------------

return scene