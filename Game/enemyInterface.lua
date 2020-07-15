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
local sheet_hurt
local sheet_hurt_Options
local sheet_die
local sheet_die_Options
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

local function stopping(event)
  if(event.phase == "ended") then
    -- enemy:pause()
    enemy:setSequence("die")

    if(sheet_die_Options.numFrames == 30) then
      enemy:setFrame(30)
    end

    if(sheet_die_Options.numFrames == 60) then
      enemy:setFrame(60)
    end
  end
end

local function slay()
  enemy:setSequence("attack")
  enemy:play()
end

local function hurt()
  enemy:setSequence("hurt")
  enemy:play()
end

local function die()
  enemy:setSequence("die")
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

local function damage(pers)
  enemy=pers

  enemy:addEventListener("sprite", resumeIdleing)
  hurt()
end

local function dead(pers)
  enemy=pers

  enemy:addEventListener("sprite", stopping)
  die()
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

  sheet_hurt_Options =
  {
    width=nemico.sheet_hurt.width,
    height=nemico.sheet_hurt.height,
    numFrames=nemico.sheet_hurt.frames,
  }

  sheet_die_Options =
  {
    width=nemico.sheet_die.width,
    height=nemico.sheet_die.height,
    numFrames=nemico.sheet_die.frames,
  }

  --Sprite sheets del nemico
  sheet_idle = graphics.newImageSheet( nemico.immagine, sheet_idle_Options )
  sheet_attack = graphics.newImageSheet( nemico.attack, sheet_attack_Options )
  sheet_hurt = graphics.newImageSheet( nemico.hurt, sheet_hurt_Options )
  sheet_die = graphics.newImageSheet( nemico.die, sheet_die_Options )

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
    },

    --Hurt
    {
      name="hurt",
      start = nemico.hurtOptions.start,
      count = nemico.hurtOptions.count,
      time = nemico.hurtOptions.time,
      loopCount = nemico.hurtOptions.loopCount,
      loopDirection = nemico.hurtOptions.loopDirection,
      sheet=sheet_hurt
    },

    --Hurt
    {
      name="die",
      start = nemico.dieOptions.start,
      count = nemico.dieOptions.count,
      time = nemico.dieOptions.time,
      loopCount = nemico.dieOptions.loopCount,
      loopDirection = nemico.dieOptions.loopDirection,
      sheet=sheet_die
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
  danno = (damage),
  muori = (dead),
}

return interfaceEnemy
