local composer = require( "composer" )
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
local fileHandler = require("fileHandler")

--Physics (necessaria per il movimento del personaggio)
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Variabili personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local character
local animationTimer
local moveTimer
local scene
local personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sheet options personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sheet_walking_Options =
{
  width=137,
  height=186,
  numFrames=120,
}

local sheet_idle_Options =
{
  width=121,
  height=178,
  numFrames=120,
}

local sheet_kick_Options =
{
  width=123,
  height=177,
  numFrames=30,
}

local sheet_slay_Options =
{
  width=213,
  height=197,
  numFrames=30,
}

local sheet_punch_Options =
{
  width=141,
  height=184,
  numFrames=30,
}

local sheet_hurt_Options =
{
  width=142,
  height=197,
  numFrames=30,
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sprite sheet personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sheet_walking = graphics.newImageSheet( "Images/Characters/Personaggio/Animations/walk.png", sheet_walking_Options )
local sheet_idle = graphics.newImageSheet( "Images/Characters/Personaggio/Animations/idle.png", sheet_idle_Options )
local sheet_kick = graphics.newImageSheet( "Images/Characters/Personaggio/Animations/kick.png", sheet_kick_Options )
local sheet_slay = graphics.newImageSheet( "Images/Characters/Personaggio/Animations/slay.png", sheet_slay_Options )
local sheet_punch = graphics.newImageSheet( "Images/Characters/Personaggio/Animations/punch.png", sheet_punch_Options )
local sheet_hurt = graphics.newImageSheet( "Images/Characters/Personaggio/Animations/hurt.png", sheet_hurt_Options )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sequences table personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sequences =
{
  --Right walking sequence
  {
    name = "rightWalk",
    start = 1,
    count = 60,
    time = 1000,
    loopCount = 0,
    loopDirection = "forward",
    sheet = sheet_walking
  },

  --Left walking sequence
  {
    name = "leftWalk",
    start = 61,
    count = 60,
    time = 1000,
    loopCount = 0,
    loopDirection = "forward",
    sheet = sheet_walking
  },

  --Right Idle
  {
    name = "rightIdle",
    start = 1,
    count = 60,
    time = 1000,
    loopCount = 0,
    loopDirection = "forward",
    sheet = sheet_idle
  },

  --Left Idle
  {
    name = "leftIdle",
    start = 61,
    count = 60,
    time = 1000,
    loopCount = 0,
    loopDirection = "forward",
    sheet = sheet_idle
  },

  --Punch (mossa1)
  {
    name = "punch",
    start = 1,
    count = 30,
    time = 500,
    loopCount = 1,
    loopDirection = "forward",
    sheet = sheet_punch
  },

  --Kick (mossa2)
  {
    name = "kick",
    start = 1,
    count = 30,
    time = 500,
    loopCount = 1,
    loopDirection = "forward",
    sheet = sheet_kick
  },

  --Slay (mossa3)
  {
    name = "slay",
    start = 1,
    count = 30,
    time = 500,
    loopCount = 1,
    loopDirection = "forward",
    sheet = sheet_slay
  },

  --Hurt
  {
    name = "hurt",
    start = 1,
    count = 30,
    time = 500,
    loopCount = 1,
    loopDirection = "forward",
    sheet = sheet_hurt
  }
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Handle del movimento del personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Perform movement
local function move(event)
  local dir = event.source.params.direction
  local fame = 0.5
  local passo = 10
  if(not(dir==nil)) then
    if(dir=="r") then
      character.x = character.x + passo
      -- print("character armor = "..character.armor)
      -- print("character damage = "..character.damage)
      composer.setVariable( "characterX", character.x )
      composer.setVariable( "characterY", character.y )
      local foodToken = composer.getVariable("foodToken")
      foodToken.x= foodToken.x - fame
      if foodToken.x<foodToken.minX then
        foodToken.x = foodToken.minX
      end
      local composerFood = composer.getVariable( "characterFood" )
      composerFood = composerFood - fame
      if composerFood < 0 then
        composerFood = 0
      end
      composer.setVariable( "characterFood", composerFood )
    elseif(dir=="l") then
      character.x = character.x - passo
      composer.setVariable( "characterX", character.x )
      composer.setVariable( "characterY", character.y )
      local foodToken = composer.getVariable("foodToken")
      foodToken.x= foodToken.x - fame
      if foodToken.x<foodToken.minX then
        foodToken.x = foodToken.minX
      end
      local composerFood = composer.getVariable( "characterFood" )
      composerFood = composerFood - fame
      if composerFood < 0 then
        composerFood = 0
      end
      composer.setVariable( "characterFood", composerFood-fame )
    end

    if(character.x < 0) then
      timer.pause( moveTimer )
      character:pause()
      scene.goBack()
    end

    if(character.x > lunghezza) then
      timer.pause( moveTimer )
      character:pause()
      scene.changeRoom()
    end

    local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
    local nemico = stanzaCorrente.nemici[1]
    if(character.x > lunghezza - 500 and nemico ~= nill) then
      print("partito combattimento con: " .. nemico.immagine)
      timer.pause( moveTimer )
      character:pause()
      composer.gotoScene( "Scenes.fight", {time=1500, effect="zoomInOutFade"} )
    end
  end
end

--Movement Listener
local function moveListener(event)
  local phase = event.phase
  local target = event.target
  local dir

  if(phase=="began") then
    display.getCurrentStage():setFocus(target)
    moveTimer = timer.performWithDelay( 30, move, 0)

    if(not((event.x > target.nonMovementArea.minX and event.x < target.nonMovementArea.maxX) or (event.y > target.nonMovementArea.maxY))) then
      --Touch in the movement area, starting the right movement sprite animation
      if((event.x < target.nonMovementArea.minX) and (event.y < target.nonMovementArea.maxY)) then
        dir = "l"
        character:setSequence( "leftWalk" )
      elseif((event.x > target.nonMovementArea.maxX) and (event.y < target.nonMovementArea.maxY)) then
        dir = "r"
        character:setSequence( "rightWalk" )
      end

      --Start movement
      character:play()
    end

    moveTimer.isPaused = false
    moveTimer.params = {direction=dir}
  elseif(phase=="moved") then   --Touch moved
    --Touch falls in the non-movement area
    if((event.x > target.nonMovementArea.minX and event.x < target.nonMovementArea.maxX) or (event.y > target.nonMovementArea.maxY)) then
      --Ending movement, canceling focus and stopping animation
      display.getCurrentStage():setFocus(nil)
      character:pause()

      if(moveTimer.params.direction == "l") then
        character:setSequence("leftIdle")
      elseif(moveTimer.params.direction == "r") then
        character:setSequence("rightIdle")
      end

      timer.cancel( moveTimer )

      --Facing the right direction
      character:play()
      return true
    end
  elseif (phase=="ended" or phase=="cancelled") then
    --Ending movement, canceling focus and stopping animation
    display.getCurrentStage():setFocus(nil)
    character:pause()

    if(moveTimer.params.direction == "l") then
      character:setSequence("leftIdle")
    elseif(moveTimer.params.direction == "r") then
      character:setSequence("rightIdle")
    end
    timer.cancel( moveTimer )

    --Facing the right direction
    character:play()
  end

  return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Mosse del personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function resumeIdleing(event)
  if(event.phase == "ended") then
    personaggio:setSequence("rightIdle")
    personaggio:play()
  end
end

local function hurt()
  personaggio:setSequence("hurt")
  personaggio:play()
end

local function mossa1()
  personaggio:setSequence("punch")
  personaggio:play()
end

local function mossa2()
  personaggio:setSequence("kick")
  personaggio:play()
end

local function mossa3()
  personaggio:setSequence("slay")
  personaggio:play()
end

local function mossa4()
  print("niente")
end

local function eseguiMossa(numeroMossa, pers)
  personaggio = pers
  personaggio:addEventListener("sprite", resumeIdleing)

  if(numeroMossa == 1) then
    mossa1()
  end

  if(numeroMossa == 2) then
    mossa2()
  end

  if(numeroMossa == 3) then
    mossa3()
  end

  if(numeroMossa == 4) then
    mossa4()
  end

  if(numeroMossa == 5) then
    hurt()
  end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Creazione del personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function create(scena)
  --Memorizing scene context
  scene = scena

  --Displaying character and setting sprite sheets
  character = display.newSprite( sheet_idle, sequences )
  character:setSequence("rightIdle")
  character:play()
  character.anchorY = 1
  character.x = lunghezza * 0.1
  character.y = altezza-310
  composer.setVariable( "characterX", character.x )
  composer.setVariable( "characterY", character.y )
  print("settati nel composer: "..composer.getVariable( "characterX" ))
  physics.addBody(character, "dynamic", {radius=sheet_walking_Options.width, isSensor=true, filter={categoryBits=1, maskBits=6}})
  character.myName = "Character"

  local composerLife = composer.getVariable( "characterLife" )
  if(not(composerLife==nil)) then
    character.life = composerLife
    composer.setVariable( "characterLife", character.life )
  else
    character.maxLife = 3000
    composer.setVariable( "characterMaxLife", character.maxLife )
    character.life = character.maxLife
    composer.setVariable( "characterLife", character.life )
  end

  local composerFood = composer.getVariable( "characterFood" )
  if(not(composerFood==nil)) then
    print("impostata da composer"..composerFood)
    character.food = composerFood
    composer.setVariable( "characterFood", character.food )
    character.maxFood = 500
    composer.setVariable( "characterMaxFood", character.maxFood )
  else
    character.maxFood = 500
    composer.setVariable( "characterMaxFood", character.maxFood )
    character.food = character.maxFood
    composer.setVariable( "characterFood", character.food )
  end
  character.armorBuff = composer.getVariable( "armorBuff" )
  character.baseArmor = 8
  character.armor = character.baseArmor + character.armorBuff
  character.damageBuff = composer.getVariable( "damageBuff" )
  character.baseDamage = 100
  character.damage = character.baseDamage + character.damageBuff
  character.speed = 3
  character.mossa1 = {nome="Pugno", hitChance = 8, damage = 400}
  character.mossa2 = {nome="Calcio", hitChance = 7, damage = 0.6}
  character.mossa3 = {nome="Fendente", hitChance = 3, damage = 1}
  character.mossa4 = {nome="Laccio", hitChance = 1, damage = 0.1}
  character.testoMossa1 = character.mossa1.nome .. ": Semplice ma efficace\nDamage = " .. (character.mossa1.damage * 100) .. "%\nHit chance = " .. (character.mossa1.hitChance*10) .. "%\n"
  character.testoMossa2 = character.mossa2.nome .. ": Colpisce dove fa piu' male\nDamage = " .. (character.mossa2.damage * 100) .. "%\nHit chance = " .. (character.mossa2.hitChance*10) .. "%\n"
  character.testoMossa3 = character.mossa3.nome .. ": Affetta il tuo avversario\nDamage = " .. (character.mossa3.damage * 100) .. "%\nHit chance = " .. (character.mossa3.hitChance*10) .. "%\n"
  character.testoMossa4 = character.mossa4.nome .. ": Questa mossa genera gettere & settere\nDamage = " .. (character.mossa4.damage * 100) .. "%\nHit chance = " .. (character.mossa4.hitChance*10) .. "%\n"

  return character
end


local function die(group)
  local gameOverBack = display.newImageRect(group, "Images/Backgrounds/Black.jpg", 1280, 720)
  gameOverBack.x = display.contentCenterX
  gameOverBack.y = display.contentCenterY
  local gameOver = display.newText(group, "GAME OVER", 600, 200, native.systemFont, 100)
  gameOver:setFillColor(1, 0, 0)

  local stringaSalvataggio = "save".."$$"..composer.getVariable("username")..".json"
  local tabelloneSalvataggi = fileHandler.loadTable(stringaSalvataggio)
  if(not(tabelloneSalvataggi == nil)) then
    print("prepara a rimuovere")
    for i = #tabelloneSalvataggi, 1, -1 do
      print("tenta di confrontare "..tabelloneSalvataggi[i].nomeSalvataggio..", "..composer.getVariable( "nomePartita" ))
      if(tabelloneSalvataggi[i].nomeSalvataggio == composer.getVariable( "nomePartita" )) then
        table.remove(tabelloneSalvataggi, i)
        print("rimossa")
        --tabelloneSalvataggi[i] = nil
      end
    end
    local punteggioPartita =  composer.getVariable( "score" )
    function saveScore(punteggioPartita)
    	local URL = "https://appmcsite.000webhostapp.com/insertScore.php?score=" .. punteggioPartita .. "&username=" .. composer.getVariable( "username" ) .. "&partita=" .. composer.getVariable( "nomePartita" )
    		network.request(URL, "GET", networkListener)
    end
    saveScore(punteggioPartita)

  end
  local function gotoNuovaCarica()
    composer.setVariable( "characterLife", character.life )
    composer.removeScene( "Scenes.fight" )
    composer.gotoScene( "Scenes.nuovaCarica", {time=800, effect="crossFade"} )
  end

  fileHandler.saveTable(tabelloneSalvataggi, stringaSalvataggio)
  fileHandler.caricaSave(tabelloneSalvataggi, stringaSalvataggio)
  composer.setVariable( "characterLife", composer.getVariable("characterMaxLife") )
  composer.setVariable( "characterFood", composer.getVariable("characterMaxFood") )
  timer.performWithDelay( 2000, gotoNuovaCarica )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Interfaccia del personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local interfacciaPersonaggio =
{
  creaPersonaggio = (create),
  muovi = (move),
  listener = (moveListener),
  changeRoom = (exitRight),
  goBack = (exitLeft),
  esegui = (eseguiMossa),
  gameOver = (die)
}

return interfacciaPersonaggio
