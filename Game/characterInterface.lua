local composer = require( "composer" )
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)

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
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sheet options personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sheet_walking_Options =
{
  width=100,
  height=175,
  numFrames=9,
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sprite sheet personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sheet_walking = graphics.newImageSheet( "Images/Characters/Trump.png", sheet_walking_Options )

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sequences table personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sequences_walking =
{
    --Right walking sequence
    {
        name = "rightWalk",
        start = 7,
        count = 3,
        time = 1000,
        loopCount = 0,
        loopDirection = "forward"
    },

    --Left walking sequence
    {
        name = "leftWalk",
        start = 4,
        count = 3,
        time = 1000,
        loopCount = 0,
        loopDirection = "forward"
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
      timer.cancel( moveTimer )
      character:pause()

      --Facing the right direction
      character:setFrame(1)
      return true
    end
  elseif (phase=="ended" or phase=="cancelled") then
    --Ending movement, canceling focus and stopping animation
    display.getCurrentStage():setFocus(nil)
    timer.cancel( moveTimer )
    character:pause()

    --Facing the right direction
    character:setFrame(1)
  end

  return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Creazione del personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function create(scena)
  --Memorizing scene context
  scene = scena

  --Displaying character and setting sprite sheets
  character = display.newSprite( sheet_walking, sequences_walking )
  character:setSequence(rightWalk)
  character:setFrame(1)
  character.anchorY = 1
  character.x = lunghezza * 0.1
  character.y = altezza-310
  physics.addBody(character, "dynamic", {radius=sheet_walking_Options.width, isSensor=true, filter={categoryBits=1, maskBits=6}})
  character.myName = "Character"
  character.life = 50000
  character.armor = 50
  character.damage = 100
  character.speed = 10
  character.testoMossa1 = "Pugno : Stordisci il tuo avversario \nDamage = 60%\nHit chance = 20%\n"
  character.testoMossa2 = "Mossa2 : Questa mossa ti fa il caffè\nAttacco = 30%\nDifesa = 50%\nVelocità = 80%"
  character.testoMossa3 = "Mossa3 : Questa mossa ti fa accarezzare il gatto di titto\nAttacco = 20%\nDifesa = 90%\nVelocità = 60%"
  character.testoMossa4 = "Mossa4 : Questa mossa genera gettere & settere\nAttacco = 20%\nDifesa = 50%\nVelocità = 20%"
  character.nomeMossa1 = "Pugno"
  character.nomeMossa2 = "Calcio"
  character.nomeMossa3 = "Cinta"
  character.nomeMossa4 = "Laccio"
  character.mossa1 = {hitChance = 3, damage = 10}
  character.mossa2 = {hitChance = 2, damage = 30}
  character.mossa3 = {hitChance = 1, damage = 20}
  character.mossa4 = {hitChance = 4, damage = 40}


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
}

return interfacciaPersonaggio
