local M = {}

function M.init()
    M.click = audio.loadSound("res/audio/ButtonClick.mp3")
    M.crushElite = audio.loadSound("res/audio/CrushElite.mp3")
    M.crushKing = audio.loadSound("res/audio/CrushKing.mp3")
    M.crushNormal = audio.loadSound("res/audio/CrushNormal.mp3")
    M.levelBgMusic_01 = audio.loadSound("res/audio/LevelBgMusic_01.mp3")
    M.levelBgMusic_02 = audio.loadSound("res/audio/LevelBgMusic_02.mp3")
    M.splashElite = audio.loadSound("res/audio/SplashElite.mp3")
    M.splashKing = audio.loadSound("res/audio/SplashKing.mp3")
    M.splashNormal = audio.loadSound("res/audio/SplashNormal.mp3")
end

return M