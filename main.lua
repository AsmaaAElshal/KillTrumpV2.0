-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

local composer = require("composer")
local _G = require("global_variables")
_G.init()
--local composer = require("storyboard")

-- Code to initialize your app

-- Assumes that "scene1.lua" exists and is configured as a Composer scene
 
--composer.gotoScene(_G.mainScene)
--composer.gotoScene(_G.gameSelectScene)
local options = {

	lastScene = ""
}
composer.gotoScene(_G.killScene)
--composer.gotoScene(_G.mainScene , _G.sceneOptions);
