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
local animationTimer
local sprite_sheet
local sheet_Options
local sequences
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Sequenze nemico
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- local sequences =
-- {
--     --Right walking sequence
--     {
--         name = "idle",
--         start = 1,
--         count = 37,
--         time = 1000,
--         loopCount = 0,
--         loopDirection = "forward"
--     }
-- }

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Creazione nemico
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function create(scena, nemico)
  --Memorizing scene context
  scene = scena

  -- local sequences =
  -- {
  --     --Right walking sequence
  --     {
  --         name = "idle",
  --         start = 1,
  --         count = nemico.frames,
  --         time = 600,
  --         loopCount = 0,
  --         loopDirection = "forward"
  --     }
  -- }
  --
  -- --Opzioni di visualizzazione nemico
  local sheet_Options =
  {
    width=nemico.width,
    height=nemico.height,
    numFrames=nemico.frames,
  }

  --Display nemico
  sprite_sheet = graphics.newImageSheet( nemico.immagine, sheet_Options )
  enemy = display.newSprite( sprite_sheet, nemico.sequences )
  enemy:setSequence(idle)
  enemy:play()

  --Posizionamento nemico
  enemy.anchorY = 1
  enemy.x = lunghezza * 0.7
  enemy.y = altezza-313
  enemy.myName = "Enemy"
  physics.addBody(enemy, "dynamic", { isSensor=true } )

  return enemy
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Interface enemy
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local interfaceEnemy =
{
  createEnemy = (create),
}

return interfaceEnemy
