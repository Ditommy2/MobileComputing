local composer = require("composer")
local characterWidth = 121
local characterHeight = 178

local defaultItemLocation = "Images/Icons/icons3/"

local itemsTable = {
    pozioneVita = {
    nome="016-potion-1.png",
    location=defaultItemLocation,
    activateFunction = (
    function(posx, posy)
      local characterX = composer.getVariable( "characterX" )
      local characterY = composer.getVariable( "characterY" )
      if( (characterX - characterWidth/2)<posx and(characterX + characterWidth/2)>posx) and ( (characterY - characterHeight/2)<posy and(characterY + characterHeight/2)>posy) then
        print("curato")
      end
    end)
  },
  chiaveForziere = {
    nome = "029-key.png",
    location = defaultItemLocation,
    activateFunction = (
    function(posx, posy)
    end)
  }

}

return itemsTable
