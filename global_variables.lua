local M = {}

function M.init()
    M.IMAGE_PATH = "res/images/"
    M.LIVE_BUGS_PATH = "res/images/bugs/live/"
    M.KILLED_BUGS_PATH ="res/images/bugs/killed/"
    M._W = display.contentWidth
    M._H = display.contentHeight
    M.halfW = display.contentWidth * 0.5
    M.halfH = display.contentHeight * 0.5
    M.pauseScene = require("pause_screen");
    M.main_screen = require("main_screen");
    M.mainScene = "main_scene"
    M.gameSelectScene = "game_select_scene"
    M.candyScene = "candy_scene" -- classic game.
    M.killScene="guardian_scene"
    M.massacareScene = "" -- arcade game.
    M.surviveScene = "" -- survivial and timed game.
    M.bugzillla = "" -- free game.
    M.sceneOptions = {
        effect = "crossFade",
        time = 500 ,
        params={
            lastScene="",
        }
    }
    M.gameSpeed = 5
end

return M