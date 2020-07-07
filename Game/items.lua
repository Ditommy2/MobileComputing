local composer = require("composer")
local characterWidth = 121
local characterHeight = 178
local characterX = composer.getVariable( "characterX" )
local characterY = composer.getVariable( "characterY" )
local defaultItemLocation = "Images/Icons/icons3/"
local items = {
  item1 ={
    nome="016-potion-1.png",
    location=defaultItemLocation,
    activateFunction = (
    function(posx, posy)
      local character = composer.getVariable( "variableName" )
      if( (characterX - CharacterWidth/2)<posx and(characterX + CharacterWidth/2)>posx) and ( (characterY - CharacterHeight/2)<posy and(characterY + CharacterHeight/2)>posy) then
        print("curato")
      end
    end)
  }
}

return items
