-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require("composer")
display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())
local filePathPaswordOccupata=system.pathForFile("binario.json", system.DocumentsDirectory)
audio.reserveChannels(1)
audio.setVolume( 0.1, {channel=1} )
local json=require("json")
local file = io.open( filePathPaswordOccupata, "w" )

if file then
  local stringa = "true"
  file:write(json.encode(stringa))
  io.close(file)
end
composer.gotoScene("nuova")
