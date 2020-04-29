-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require("composer")
local lowerFixedMenu= require("lowerFixedMenu")
local support = require("interfaceConfig")
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
 inv = lowerFixedMenu.create.inventario
 mappa = lowerFixedMenu.create.mappaGenerata
 mappa.corrente=true
 funzione=lowerFixedMenu.display
 composer.setVariable( "stanzaCorrente", mappa )
 composer.setVariable( "inv", inv )
 composer.setVariable( "mappa", mappa )
 composer.setVariable( "funzione", funzione )
 composer.setVariable( "mapx", 120 )
 composer.setVariable( "mapy", 95 )
composer.gotoScene("livello1")
