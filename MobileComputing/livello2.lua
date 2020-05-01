
local composer = require( "composer" )
local lowerFixedMenu= require("lowerFixedMenu")
local widget = require("widget")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local funzione= composer.getVariable( "funzione" )
local mappaloc= composer.getVariable( "mappa" )
local invloc= composer.getVariable( "inv" )
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )

local sheetOptions=
{
  frames=
  {
    {--freccia nord
      x=700,
      y=0,
      width=900,
      height=800
    },
    {--freccia sud
      x=700,
      y=1640,
      width=900,
      height=800
    },
    {--freccia est
      x=1570,
      y=800,
      width=800,
      height=800
    },
    {--freccia ovest
      x=0,
      y=800,
      width=800,
      height=800
    },
  },
}
local objectSheet=graphics.newImageSheet( "directionArrow.png", sheetOptions )
local function handleButtonEvent( event )
        local item=event.target
        local direzione = item.id
      --  item:removeEventListener("tap", handleButtonEvent)
        print("DIREZIONE: ----------------------------------------------------------------------", direzione)
        print("MOVIMENTO DA ", stanzaCorrente.TESTO, " a ", stanzaCorrente[direzione].TESTO)
        stanzaCorrente.corrente=false
        stanzaCorrente[direzione].corrente=true
        composer.setVariable( "stanzaCorrente", stanzaCorrente[direzione] )
        --composer.removeScene("livello1")
        composer.gotoScene("livello1")
end
-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local phase = event.phase


--local freccia = display.newImageRect(sceneGroup, objectSheet, 4, 50, 50)
--freccia.x=display.contentCenterX
--freccia.y=display.contentCenterY
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
  local phase=event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)




	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    funzione(self,  mappaloc, invloc)
    composer.removeScene( "livello1")
    local background=display.newImageRect(backGroup, "nuovaBackground.png", 800, 700)
    background.x=display.contentCenterX
    background.y=display.contentCenterY-320
  --  sceneGroup:insert(background)
    mainGroup=display.newGroup()
    print("stanza Corrente: ", stanzaCorrente.TESTO)
    if stanzaCorrente.NORD~=nil then
      local freccia  = display.newImageRect(mainGroup, objectSheet, 1, 50, 50)
      freccia.id="NORD"
      freccia:addEventListener("tap", handleButtonEvent)
      freccia.x=display.contentCenterX
      freccia.y=40
    end

    if stanzaCorrente.SUD~=nil then
      local freccia  = display.newImageRect(mainGroup, objectSheet, 2, 50, 50)
      freccia.id="SUD"
      freccia:addEventListener("tap", handleButtonEvent)
      freccia.x=display.contentCenterX
      freccia.y=160
    end

    if stanzaCorrente.EST~=nil then
      local freccia  = display.newImageRect(mainGroup, objectSheet, 3, 50, 50)
      freccia.id="EST"
      freccia:addEventListener("tap", handleButtonEvent)
      freccia.x=display.contentCenterX+250
      freccia.y=display.contentCenterY-60
    end

    if stanzaCorrente.OVEST~=nil then
      local freccia  = display.newImageRect(mainGroup, objectSheet, 4, 50, 50)
      freccia.id="OVEST"
      freccia:addEventListener("tap", handleButtonEvent)
      freccia.x=display.contentCenterX-250
      freccia.y=display.contentCenterY-60
    end
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
--composer.removeScene("livello1")
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
   --composer.removeScene("livello1")
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
