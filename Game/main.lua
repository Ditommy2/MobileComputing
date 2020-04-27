-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require("composer")
--composer.gotoScene("carica")
print( "pixel/width: " .. display.pixelWidth / display.actualContentWidth )
print( "eight/width: " .. display.pixelHeight / display.pixelWidth )

composer.gotoScene( "game")
