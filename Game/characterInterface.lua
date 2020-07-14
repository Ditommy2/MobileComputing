local composer = require( "composer" )
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
local fileHandler = require("fileHandler")
local customFont="MadnessHyperactive.otf"


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
      --print("character speed = "..character.speed)
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
    local currentScene = composer.getSceneName( "current" )

    if(currentScene=="Scenes.livello1") then
      if(character.x > lunghezza - 500 and nemico ~= nill) then
        -- print("partito combattimento con: " .. nemico.immagine)
        timer.pause( moveTimer )
        character:pause()
        composer.removeScene( "Scenes.livello1")
        composer.gotoScene( "Scenes.fight", {time=1500, effect="zoomInOutFade"} )
      end
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
  local punchSound = audio.loadSound( "audio/eff/punch.mp3" )
  audio.play( punchSound )
  personaggio:setSequence("punch")
  personaggio:play()
end

local function mossa2()
  local kickSound = audio.loadSound( "audio/eff/kick.mp3" )
  audio.play( kickSound )
  personaggio:setSequence("kick")
  personaggio:play()
end

local function mossa3()
  local swordSound = audio.loadSound( "audio/eff/sword.mp3" )
  audio.play( swordSound )
  personaggio:setSequence("slay")
  personaggio:play()
end

local function mossa4()
  local stunSound = audio.loadSound( "audio/eff/stun.mp3" )
  audio.play( stunSound )
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

  character.speedBuff = composer.getVariable( "speedBuff" )
  character.baseSpeed = 3
  character.speed = character.baseSpeed + character.speedBuff

  character.mossa1 = {nome="Pugno del duellante", hitChance = 8, damage = 0.3, effect = {target = "armor", value = -2}}
  character.mossa2 = {nome="Calcio respingente", hitChance = 7, damage = 0.6, effect = {target = "damage", value = -5}}
  character.mossa3 = {nome="Fendente letale", hitChance = 3, damage = 1, effect = {target = "life", value = -200}}
  character.mossa4 = {nome="Elsa stordente", hitChance = 1, damage = 0.1, effect = {target = "stunned", value = 2}}
  character.testoMossa1 = character.mossa1.nome .. " : Abbassa le difese del nemico\nDamage = " .. (character.mossa1.damage * 100) .. "%\nHit chance = " .. (character.mossa1.hitChance*10) .. "%\n"
  character.testoMossa2 = character.mossa2.nome .. " : Diminuisce il pericolo\nDamage = " .. (character.mossa2.damage * 100) .. "%\nHit chance = " .. (character.mossa2.hitChance*10) .. "%\n"
  character.testoMossa3 = character.mossa3.nome .. " : Colpo letale con la spada\nDamage = " .. (character.mossa3.damage * 100) .. "%\nHit chance = " .. (character.mossa3.hitChance*10) .. "%\n"
  character.testoMossa4 = character.mossa4.nome .. " : Colpo stordente\nDamage = " .. (character.mossa4.damage * 100) .. "%\nHit chance = " .. (character.mossa4.hitChance*10) .. "%\n"

  return character
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Torna alla schermata nuovaCarica
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function gotoNuovaCarica()
  audio.stop( 3 )
  audio.stop( 2 )
  audio.play( menuTrack, {channel =1 , loops = -1})
  composer.setVariable( "characterLife", nil )
  composer.removeScene( "Scenes.fight" )
  composer.gotoScene( "Scenes.nuovaCarica", {time=800, effect="crossFade"} )
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Salva il punteggio della partita
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function saveScore(punteggioPartita)
  local stringaScores = "saveScore.json"
  fileHandler.scaricaSave(stringaScores)
  local tabellonePunteggi = fileHandler.loadTableScores(stringaScores)
  local user = composer.getVariable( "username" )
  local game = composer.getVariable( "nomePartita" )
  if tabellonePunteggi == nil then
    tabellonePunteggi = {}
    print("impostato nil")
  end
  table.insert( tabellonePunteggi, {punteggio=punteggioPartita, utente=user, partita=game} )
  fileHandler.saveTable(tabellonePunteggi, stringaScores)
  fileHandler.caricaScore({punteggio=punteggioPartita, utente=user, partita=game}, stringaScores)
  fileHandler.scaricaSave(stringaScores)
end

local function die(group)
  audio.stop( 3 )
  audio.stop( 2 )
  local gameOverSound = audio.loadSound( "audio/eff/GameOver.mp3" )
  audio.play( gameOverSound )
  local gameOverBack = display.newImageRect(group, "Images/Backgrounds/Black.jpg", 1280, 720)
  gameOverBack.x = display.contentCenterX
  gameOverBack.y = display.contentCenterY
  local gameOver = display.newText(group, "GAME OVER", 600, 200, native.newFont( customFont), 100)
  gameOver:setFillColor(1, 0, 0)

  --CANCELLA IL SALVATAGGIO PERCHè LA PARTITA è PERSA
  local stringaSalvataggio = "save".."$$"..composer.getVariable("username")..".json"
  local tabelloneSalvataggi = fileHandler.loadTable(stringaSalvataggio)
  if(not(tabelloneSalvataggi == nil)) then
    for i = #tabelloneSalvataggi, 1, -1 do
      if(tabelloneSalvataggi[i].nomeSalvataggio == composer.getVariable( "nomePartita" )) then
        table.remove(tabelloneSalvataggi, i)
      end
    end

  end

  fileHandler.saveTable(tabelloneSalvataggi, stringaSalvataggio)
  fileHandler.caricaScore(tabelloneSalvataggi, stringaSalvataggio)
  local punteggioPartita =  composer.getVariable( "score" )

  saveScore(punteggioPartita)

  composer.setVariable( "characterLife", composer.getVariable("characterMaxLife") )
  composer.setVariable( "characterFood", composer.getVariable("characterMaxFood") )
  timer.performWithDelay( 4000, gotoNuovaCarica )
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
