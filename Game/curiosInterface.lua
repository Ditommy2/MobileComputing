local composer = require( "composer" )
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local function create(scena, curio)
  --Memorizing scene context
  scene = scena
  --Displaying obj
  local createdCurio = display.newImageRect(curio.immagine, 100, 175)
  -- enemy = display.newImageRect( nemico.immagine, 100, 175)

--  curio.anchorY = 1
  createdCurio.x =lunghezza * 0.7
  createdCurio.y =altezza-390
  createdCurio.areaXUpper = createdCurio.x + createdCurio.width/2
  createdCurio.areaXLower = createdCurio.x - createdCurio.width/2
  createdCurio.areaYUpper = createdCurio.y + createdCurio.height/2
  createdCurio.areaYLower = createdCurio.y - createdCurio.height/2
  createdCurio.messaggio = curio.messaggio
  createdCurio.funzione = curio.funzione
  createdCurio.myName = "createdCurio"
--  physics.addBody(curio, "dynamic", { isSensor=true } )

  return createdCurio
end


local curiosInterface = {
  createCurio = (create)
}
 return curiosInterface
