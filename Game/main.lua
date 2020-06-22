-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local customFont="MadnessHyperactive.otf"
local composer = require("composer")
local lowerFixedMenu = require("lowerFixedMenu")

display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())
local filePathComandi=system.pathForFile("binario.json", system.DocumentsDirectory)
audio.reserveChannels(1)
audio.setVolume( 0.1, {channel=1} )
local json=require("json")
local file = io.open( filePathComandi, "w" )
if file then
  local stringa = "false"
  file:write(json.encode(stringa))
  io.close(file)
end

 funzione=lowerFixedMenu.display
 composer.setVariable( "funzione", funzione )
 composer.gotoScene("Scenes.fight")
