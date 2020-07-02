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
  curio = display.newImageRect(curio.immagine, 100, 175)
  -- enemy = display.newImageRect( nemico.immagine, 100, 175)

--  curio.anchorY = 1
  curio.x =500 --lunghezza * 0.7
  curio.y =500-- altezza-390
  curio.areaXUpper = curio.x + curio.width/2
  curio.areaXLower = curio.x - curio.width/2
  curio.areaYUpper = curio.y + curio.height/2
  curio.areaYLower = curio.y - curio.height/2
  curio.myName = "curio"
--  physics.addBody(curio, "dynamic", { isSensor=true } )

  return curio
end


local curiosInterface = {
  createCurio = (create)
}
 return curiosInterface
