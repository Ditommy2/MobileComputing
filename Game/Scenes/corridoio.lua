
local composer = require( "composer" )
local lowerFixedMenu= require("lowerFixedMenu")
local widget = require("widget")
local scene = composer.newScene()
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
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
local prossimaStanza=composer.getVariable( "prossimaStanza" )
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
local objectSheet=graphics.newImageSheet( "Images/Utility/directionArrow.png", sheetOptions )
local function handleButtonEvent( event )
        local item=event.target
        local direzione = item.id

      --  item:removeEventListener("tap", handleButtonEvent)
        print("DIREZIONE DA CORRIDOIO: ----------------------------------------------------------------------", direzione)

        if direzione=="EST" then
          prossimaStanza.corrente=true
          print("MOVIMENTO DA ", stanzaCorrente.TESTO, " a ", prossimaStanza.TESTO)
          composer.setVariable( "stanzaCorrente", prossimaStanza)
        end

        if direzione=="OVEST" then
          stanzaCorrente.corrente=true
          print("RITORNO SU STANZA ", stanzaCorrente.TESTO)
          composer.setVariable("stanzaCorrente", stanzaCorrente)
        end
        for i = mainGroup.numChildren, 1, -1 do
        mainGroup[i]:removeSelf()
        print("FRECCIA RIMOSSA")
        mainGroup[i] = nil
        end
        composer.removeScene( "Scenes.corridoio")
        composer.gotoScene( "Scenes.livello1" )
end
-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local phase = event.phase

  funzione(self,  mappaloc, invloc)
  local background=display.newImageRect(backGroup, "Images/Backgrounds/proceduralBack/Corridoi/back"..numero..".jpg", lunghezza, altezza-300)
  background.x=display.contentCenterX
  background.y=display.contentCenterY-170
--  sceneGroup:insert(background)
  mainGroup=display.newGroup()
  print("stanza Corrente: ", stanzaCorrente.TESTO)

    local frecciaEST  = display.newImageRect(mainGroup, objectSheet, 3, 50, 50)
    frecciaEST.id="EST"
    frecciaEST:addEventListener("tap", handleButtonEvent)
    frecciaEST.x=display.contentCenterX+520
    frecciaEST.y=display.contentCenterY-100

    local frecciaOVEST  = display.newImageRect(mainGroup, objectSheet, 4, 50, 50)
    frecciaOVEST.id="OVEST"
    frecciaOVEST:addEventListener("tap", handleButtonEvent)
    frecciaOVEST.x=display.contentCenterX-520
    frecciaOVEST.y=display.contentCenterY-100

    print("CORRIDOIO TRA STANZA ", stanzaCorrente.TESTO, " E ", prossimaStanza.TESTO)
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
