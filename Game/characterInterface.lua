local composer = require( "composer" )
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )


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


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sprite sheet personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sheet_walking = graphics.newImageSheet( "Images/Characters/Personaggio/Animations/walk.png", sheet_walking_Options )
local sheet_idle = graphics.newImageSheet( "Images/Characters/Personaggio/Animations/idle.png", sheet_idle_Options )
local sheet_kick = graphics.newImageSheet( "Images/Characters/Personaggio/Animations/kick.png", sheet_kick_Options )
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

  --Left Idle
  {
    name = "kick",
    start = 1,
    count = 30,
    time = 500,
    loopCount = 1,
    loopDirection = "forward",
    sheet = sheet_kick
  }
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Handle del movimento del personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Perform movement
local function move(event)
  local dir = event.source.params.direction

  if(not(dir==nil)) then
    if(dir=="r") then
      character.x = character.x + 10
    elseif(dir=="l") then
      character.x = character.x - 10
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

local function mossa1()
  print("niente")
end

local function mossa2()
  personaggio:setSequence("kick")
  personaggio:play()
end

local function mossa3()
  print("niente")
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
  physics.addBody(character, "dynamic", {radius=sheet_walking_Options.width, isSensor=true, filter={categoryBits=1, maskBits=6}})
  character.myName = "Character"

  local composerLife = composer.getVariable( "characterLife" )
  if(not(composerLife==nil)) then
    character.life = composerLife
    composer.setVariable( "characterLife", character.life )
  else
    character.life = 3000
    composer.setVariable( "characterLife", character.life )
  end

  character.armor = 8
  character.damage = 100
  character.speed = 3
  character.mossa1 = {nome="Pugno", hitChance = 18, damage = 5}
  character.mossa2 = {nome="Calcio", hitChance = 4, damage = 0.8}
  character.mossa3 = {nome="Cinta", hitChance = 2, damage = 0.4}
  character.mossa4 = {nome="Laccio", hitChance = 1, damage = 0.1}
  character.testoMossa1 = character.mossa1.nome .. ": Stordisci il tuo avversario \nDamage = " .. (character.mossa1.damage * 100) .. "%\nHit chance = " .. character.mossa1.hitChance .. "\n"
  character.testoMossa2 = character.mossa2.nome .. ": Questa mossa ti fa il caffè\nDamage = " .. (character.mossa2.damage * 100) .. "%\nHit chance = " .. character.mossa2.hitChance .. "\n"
  character.testoMossa3 = character.mossa3.nome .. ": Questa mossa mammt\nDamage = " .. (character.mossa3.damage * 100) .. "%\nHit chance = " .. character.mossa3.hitChance .. "\n"
  character.testoMossa4 = character.mossa4.nome .. ": Questa mossa genera gettere & settere\nDamage = " .. (character.mossa4.damage * 100) .. "%\nHit chance = " .. character.mossa4.hitChance .. "\n"

  return character
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
}

return interfacciaPersonaggio
