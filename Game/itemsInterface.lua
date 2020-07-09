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
  },
  cibo = {
    nome = "054-ham.png",
    location = defaultItemLocation,
    activateFunction = (
    function(posx, posy)
      local characterX = composer.getVariable( "characterX" )
      local characterY = composer.getVariable( "characterY" )
      if( (characterX - characterWidth/2)<posx and(characterX + characterWidth/2)>posx) and ( (characterY - characterHeight)<posy and(characterY )>posy) then
        print("curato")
        local curaLower = 90
        local curaUpper = 300
        local fightText = display.newText(composer.getVariable("sceneGroup"), "", characterX, characterY-100, native.newFont( customFont), 100)
        local cura = math.random(curaLower, curaUpper)

        if composer.getVariable("characterFood")+cura > composer.getVariable( "characterMaxFood" ) then
            fightText.text=composer.getVariable( "characterMaxFood" )-composer.getVariable("characterFood")
          composer.setVariable( "characterFood", composer.getVariable( "characterMaxFood" ) )
          local foodToken = composer.getVariable( "foodToken" )
          foodToken.x=foodToken.maxX
        else
          fightText.text = cura
          composer.setVariable( "characterFood", composer.getVariable("characterFood")+cura )
          local foodToken = composer.getVariable( "foodToken" )
          foodToken.x=foodToken.x + cura
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
  anelloDifesa = {
    nome = "003-ring.png",
    location = defaultItemLocation,
    activateFunction = (
    function(posx, posy)
      local invx = composer.getVariable( "invx" )
      local invy = composer.getVariable( "invy" )
      if ( (posx < invx or posx > (invx+700)) or (posx < invy or posy > (invy+272)) ) then
        print("impostato buff a 0")
        composer.setVariable( "buffDifesa", 0 )
      else
        print("impostato buff a 2")
        composer.setVariable( "armorBuff", 2 )
      end
    end)
  }

}

return itemsTable
