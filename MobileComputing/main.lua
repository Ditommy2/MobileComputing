-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require("composer")
display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())
composer.gotoScene("nuova")
audio.reserveChannels(1)
audio.setVolume( 0.1, {channel=1} )
