local composer = require( "composer" )
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)

--Physics
local physics = require("physics")
physics.start()

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Variabili nemico
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local enemy
local scene
local sheet_idle
local sheet_idle_Options
local sheet_attack
local sheet_attack_Options
local sequences

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Funzioni di attacco del nemico
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function resumeIdleing(event)
  if(event.phase == "ended") then
    enemy:setSequence("idle")
    enemy:play()
  end
end

local function slay()
  enemy:setSequence("attack")
  enemy:play()
end

local function attack(pers)
  enemy = pers
    if (enemy.suono == "spada") then
      local spadaSound = audio.loadSound( "audio/eff/spadina.mp3" )
      audio.setVolume( 0.5 )
      audio.play( spadaSound )
      elseif (enemy.suono == "mazza") then
        local mazzaSound = audio.loadSound( "audio/eff/mazza.mp3" )
        audio.setVolume( 0.5 )
        audio.play( mazzaSound )
      else
        local accettaSound = audio.loadSound( "audio/eff/accetta.mp3" )
        audio.setVolume( 0.5 )
        audio.play( accettaSound )
    end

  enemy:addEventListener("sprite", resumeIdleing)
  slay()
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Creazione nemico
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function create(scena, nemico)
  --Memorizing scene context
  scene = scena

  --Sprite sheet options del nemico
  sheet_idle_Options =
  {
    width=nemico.sheet_idle.width,
    height=nemico.sheet_idle.height,
    numFrames=nemico.sheet_idle.frames,
  }

  sheet_attack_Options =
  {
    width=nemico.sheet_attack.width,
    height=nemico.sheet_attack.height,
    numFrames=nemico.sheet_attack.frames,
  }

  --Sprite sheets del nemico
  sheet_idle = graphics.newImageSheet( nemico.immagine, sheet_idle_Options )
  sheet_attack = graphics.newImageSheet( nemico.attack, sheet_attack_Options )

  --Sequenze nemico
  sequences=
  {
    --Idle
    {
      name="idle",
      start = nemico.idleOptions.start,
      count = nemico.idleOptions.count,
      time = nemico.idleOptions.time,
      loopCount = nemico.idleOptions.loopCount,
      loopDirection = nemico.idleOptions.loopDirection,
      sheet=sheet_idle
    },

    --Attack
    {
      name="attack",
      start = nemico.attackOptions.start,
      count = nemico.attackOptions.count,
      time = nemico.attackOptions.time,
      loopCount = nemico.attackOptions.loopCount,
      loopDirection = nemico.attackOptions.loopDirection,
      sheet=sheet_attack
    }
  }

  enemy = display.newSprite( sheet_idle, sequences )
  enemy:setSequence(idle)
  enemy:play()

  --Posizionamento nemico
  enemy.anchorY = 1
  enemy.x = lunghezza * 0.7
  enemy.y = altezza-313
  enemy.myName = "Enemy"
  enemy.drop = nemico.drop
  enemy.suono = nemico.suono
  physics.addBody(enemy, "dynamic", { isSensor=true } )

  return enemy
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Interface enemy
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local interfaceEnemy =
{
  createEnemy = (create),
  attacca = (attack),
}

return interfaceEnemy
