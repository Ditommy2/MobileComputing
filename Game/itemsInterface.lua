local composer = require("composer")
local characterWidth = 121
local characterHeight = 178
local customFont="MadnessHyperactive.otf"
local defaultItemLocation = "Images/Icons/icons3/"

local itemsTable = {
    pozioneVita = {
    nome="016-potion-1.png",
    location=defaultItemLocation,
    description = "Rigenera la Salute",
    activateFunction = (
    function(posx, posy)
      local characterX = composer.getVariable( "characterX" )
      local characterY = composer.getVariable( "characterY" )
      local drinkSound = audio.loadSound( "audio/eff/drink.mp3" )
      audio.setVolume( 0.5 )
      if( (characterX - characterWidth/2)<posx and(characterX + characterWidth/2)>posx) and ( (characterY - characterHeight)<posy and(characterY )>posy) then
        --print("curato")
        audio.play( drinkSound )
        local curaLower = 300
        local curaUpper = 700
        local fightText = display.newText(composer.getVariable("sceneGroup"), "", characterX, characterY-100, native.newFont( customFont), 100)
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

        composer.getVariable("sceneGroup"):insert(fightText)
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
    description = "Apre i lucchetti",
    activateFunction = (
    function(posx, posy)
      local chestSound = audio.loadSound( "audio/eff/chest.mp3" )
      audio.setVolume( 0.5 )
      audio.play( chestSound )
    end)
  },
  cibo = {
    nome = "054-ham.png",
    location = defaultItemLocation,
    description = "Rigenera la tua Fame",
    activateFunction = (
    function(posx, posy)
      local characterX = composer.getVariable( "characterX" )
      local characterY = composer.getVariable( "characterY" )
      local eatSound = audio.loadSound( "audio/eff/eat.mp3" )
      audio.setVolume( 0.5 )
      if( (characterX - characterWidth/2)<posx and(characterX + characterWidth/2)>posx) and ( (characterY - characterHeight)<posy and(characterY )>posy) then
        --print("curato")
        audio.play( eatSound )
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

        composer.getVariable("sceneGroup"):insert(fightText)
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
    description = "Aumenta la tua difesa se nell'inventario",
    activateFunction = (
    function(posx, posy)
      local invx = composer.getVariable( "invx" )
      local invy = composer.getVariable( "invy" )
      local character = composer.getVariable("character")
      if ( (posx < invx or posx > (invx+700)) or (posy < invy or posy > (invy+272)) ) then
        --print("impostato buff a 0")
        composer.setVariable( "armorBuff", 0 )
      else
        --print("impostato buff a 2")
        composer.setVariable( "armorBuff", 2 )
      end
      character.armorBuff = composer.getVariable("armorBuff")
      character.armor = character.baseArmor + character.armorBuff
    end)
  },
  pozioneDanno = {
    nome = "023-potion.png",
    location = defaultItemLocation,
    description = "Aumenta l'attacco per un solo combattimento",
    activateFunction = (
    function(posx, posy)
      local characterX = composer.getVariable( "characterX" )
      local characterY = composer.getVariable( "characterY" )
      local character = composer.getVariable("character")
      local drinkSound = audio.loadSound( "audio/eff/drink.mp3" )
      audio.setVolume( 0.5 )
      if( (characterX - characterWidth/2)<posx and(characterX + characterWidth/2)>posx) and ( (characterY - characterHeight)<posy and(characterY )>posy) then
        audio.play( drinkSound )
        composer.setVariable("damageBuff", 100)
        character.damageBuff = composer.getVariable( "damageBuff" )
      else
        composer.setVariable("damageBuff", 0)
        character.damageBuff = composer.getVariable( "damageBuff" )
      end

      character.damage = character.baseDamage + character.damageBuff
    end)
  },
  pillolaSpeed = {
    nome = "024-pill.png",
    location = defaultItemLocation,
    description = "Aumenta la velocita' per un solo combattimento",
    activateFunction = (
    function(posx, posy)
      local characterX = composer.getVariable( "characterX" )
      local characterY = composer.getVariable( "characterY" )
      local bionicSound = audio.loadSound( "audio/eff/bionic.mp3" )
      audio.setVolume( 0.5 )
      local character = composer.getVariable("character")
      if( (characterX - characterWidth/2)<posx and(characterX + characterWidth/2)>posx) and ( (characterY - characterHeight)<posy and(characterY )>posy) then
        composer.setVariable("speedBuff", 100)
        audio.play( bionicSound )
        character.speedBuff = composer.getVariable( "speedBuff" )
      else
        composer.setVariable("speedBuff", 0)
        character.speedBuff = composer.getVariable( "speedBuff" )
      end

      character.speed = character.baseSpeed + character.speedBuff
    end)
  },
  pozioneMaxVita = {
  nome="020-potion.png",
  location=defaultItemLocation,
  description = "Rigenera la Salute al Massimo",
  activateFunction = (
  function(posx, posy)
    local characterX = composer.getVariable( "characterX" )
    local characterY = composer.getVariable( "characterY" )
    local bionicSound = audio.loadSound( "audio/eff/bionic.mp3" )
    audio.setVolume( 0.5 )
    if( (characterX - characterWidth/2)<posx and(characterX + characterWidth/2)>posx) and ( (characterY - characterHeight)<posy and(characterY )>posy) then
      --print("curato")
      audio.play( bionicSound )
      local fightText = display.newText(composer.getVariable("sceneGroup"), "", characterX, characterY-100, native.newFont( customFont), 100)
      local cura = composer.getVariable( "characterMaxLife" )

      if composer.getVariable("characterLife")+cura > composer.getVariable( "characterMaxLife" ) then
          fightText.text=composer.getVariable( "characterMaxLife" )-composer.getVariable("characterLife")
        composer.setVariable( "characterLife", composer.getVariable( "characterMaxLife" ) )
      else
        fightText.text = cura
        composer.setVariable( "characterLife", composer.getVariable("characterLife")+cura )

      end
      fightText:setFillColor(0, 0.8, 0)
      fightText.alpha = 1

      composer.getVariable("sceneGroup"):insert(fightText)
      local function removeTextFight()
        fightText.alpha = 0
      end
      timer.performWithDelay( 1500, removeTextFight )
    end
  end)
}

}

return itemsTable
