local composer = require("composer")
local characterWidth = 121
local characterHeight = 178
local customFont="MadnessHyperactive.otf"
local defaultItemLocation = "Images/Icons/icons3/"

local itemsTable = {
    pozioneVita = {
    nome="016-potion-1.png",
    location=defaultItemLocation,
    description = "Rigenera Salute",
    activateFunction = (
    function(posx, posy)
      local characterX = composer.getVariable( "characterX" )
      local characterY = composer.getVariable( "characterY" )
      if( (characterX - characterWidth/2)<posx and(characterX + characterWidth/2)>posx) and ( (characterY - characterHeight)<posy and(characterY )>posy) then
        print("curato")
        local curaLower = 300
        local curaUpper = 700
        local fightText = display.newText(composer.getVariable("mainGroup"), "", characterX, characterY-100, native.newFont( customFont), 100)
        local cura = math.random(curaLower, curaUpper)

        if composer.getVariable("characterLife")+cura > composer.getVariable( "characterMaxLife" ) then
            fightText.text=composer.getVariable( "characterMaxLife" )-composer.getVariable("characterLife")
          composer.setVariable( "characterLife", composer.getVariable( "characterMaxLife" ) )
        else
          fightText.text = cura
          composer.setVariable( "characterLife", composer.getVariable("characterLife")+cura )

        end
        fightText:setFillColor(0, 0.8, 0)
        fightText.alpha = 1

        composer.getVariable("mainGroup"):insert(fightText)
        local function removeTextFight()
        	fightText.alpha = 0
        end
    		timer.performWithDelay( 1500, removeTextFight )
      end
    end)
  },
  chiaveForziere = {
    nome = "029-key.png",
    location = defaultItemLocation,
    description = "Chiave",
    activateFunction = (
    function(posx, posy)
    end)
  }

}

return itemsTable
