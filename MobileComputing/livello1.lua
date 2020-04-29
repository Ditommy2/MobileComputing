
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
local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.gotoScene("livello2")
	   end
end
-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen


end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
    local funzione= composer.getVariable( "funzione" )
    local mappaloc= composer.getVariable( "mappa" )
    local invloc= composer.getVariable( "inv" )
    funzione(self,  mappaloc, invloc)
    print("livello 1: ", mappaloc.NORD.TESTO)
    local background=display.newImageRect(backGroup, "nuovaBackground.png", 800, 700)
    background.x=display.contentCenterX
    background.y=display.contentCenterY-320
    sceneGroup:insert(background)

    local Button = widget.newButton(
       {
           shape = "roundedRect",
           left = 70,
           top = 360,
           id = "Nuova",
           label = "Nuova Partita",
           labelColor={default={0.5, 0, 0}},
           onEvent = handleButtonEvent
       }
    )
    sceneGroup:insert(Button)
    Button.x=display.contentCenterX
    Button.y=270
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

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
composer.removeScene("livello1")
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
