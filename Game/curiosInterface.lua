local composer = require( "composer" )
local curios = require("curios")
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local function create(scena, stringaCurio)
  --Memorizing scene context
  scene = scena
  --Displaying obj
  local curio = curios[stringaCurio]

  if(not(curio==nil)) then
    local createdCurio = display.newImageRect(curio.immagine, 100, 175)
    -- enemy = display.newImageRect( nemico.immagine, 100, 175)

    --  curio.anchorY = 1
    createdCurio.x = display.contentCenterX+350
    createdCurio.y = display.contentCenterY-30
    createdCurio.areaXUpper = createdCurio.x + createdCurio.width/2
    createdCurio.areaXLower = createdCurio.x - createdCurio.width/2
    createdCurio.areaYUpper = createdCurio.y + createdCurio.height/2
    createdCurio.areaYLower = createdCurio.y - createdCurio.height/2
    createdCurio.messaggio = curio.messaggio
    createdCurio.funzione = curio.funzione
    createdCurio.sostitutivo = curio.sostitutivo
    createdCurio.nome = curio.nome
    --  physics.addBody(curio, "dynamic", { isSensor=true } )
    if not(curio.oggettiPossibili ==nil) then
    createdCurio.oggetto = curio.oggettiPossibili[math.random(1, #curio.oggettiPossibili)]
    end

    return createdCurio
  else
    return nil
  end
end


local curiosInterface = {
  createCurio = (create)
}
return curiosInterface
