
local composer = require( "composer" )
local lowerFixedMenu= require("lowerFixedMenu")
local widget = require("widget")
local scene = composer.newScene()
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local funzione= composer.getVariable( "funzione" )
local mappaloc= composer.getVariable( "mappa" )
local invloc= composer.getVariable( "inv" )
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
local prossimaStanza=composer.getVariable( "prossimaStanza" )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--opzioni immagini freccete non definitivo
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sheetOptions=
{
  frames=
  {
    {--freccia nord
      x=53,
      y=56,
      width=909,
      height=624
    },
    {--freccia sud
      x=53,
      y=1357,
      width=963,
      height=641
    },
    {--freccia est
      x=1358,
      y=1,
      width=678,
      height=959
    },
    {--freccia ovest
      x=1074,
      y=1073,
      width=680,
      height=967
    },
  },
}
local objectSheet=graphics.newImageSheet( "Images/Utility/directionArrow.png", sheetOptions )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione gestione delle ferccette
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function handleButtonEvent( event )
        local item=event.target
        local direzione = item.id

      --  item:removeEventListener("tap", handleButtonEvent)

        if direzione=="EST" then
          prossimaStanza.corrente=true
          composer.setVariable( "stanzaCorrente", prossimaStanza)
        end

        if direzione=="OVEST" then
          stanzaCorrente.corrente=true
          composer.setVariable("stanzaCorrente", stanzaCorrente)
        end
        for i = mainGroup.numChildren, 1, -1 do
        mainGroup[i]:removeSelf()
        mainGroup[i] = nil
        end
        composer.removeScene( "Scenes.corridoio")
        composer.gotoScene( "Scenes.livello1" )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase create del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local phase = event.phase

  funzione(self,  mappaloc, invloc)
  local direzioneCorridoio = composer.getVariable( "direzione" )
  local seedDirezionale = "seed"..direzioneCorridoio
  local numeroRandomico = stanzaCorrente[seedDirezionale]
  local background=display.newImageRect(backGroup, "Images/Backgrounds/proceduralBack/Corridoi/back"..numeroRandomico..".jpg", lunghezza, altezza-300)

  background.x=display.contentCenterX
  background.y=display.contentCenterY-170
--  sceneGroup:insert(background)
  mainGroup=display.newGroup()

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
--local freccia = display.newImageRect(sceneGroup, objectSheet, 4, 50, 50)
--freccia.x=display.contentCenterX
--freccia.y=display.contentCenterY
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase show del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase hide del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase destroy del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
