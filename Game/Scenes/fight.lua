-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

composer.recycleAutomatically=false
local widget = require("widget")
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)

--Physics (necessaria per il movimento del personaggio(attacco e difesa))
local physics = require("physics")
physics.start()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

local testoMossa = display.newText( "" ,1050, 585, 450, 0, native.systemFont, 26 )
testoMossa:setFillColor( 1, 1, 1 )

local function infoMossa1()
  testoMossa.text = "Mossa1 : Questa mossa ti apre l'ano\nAttacco = 60%\nDifesa = 20%\nVelocità = 40%"
end

local function infoMossa2()
  testoMossa.text = "Mossa2 : Questa mossa ti fa il caffè\nAttacco = 30%\nDifesa = 50%\nVelocità = 80%"
end

local function infoMossa3()
  testoMossa.text = "Mossa3 : Questa mossa ti fa accarezzare il gatto di titto\nAttacco = 20%\nDifesa = 90%\nVelocità = 60%"
end

local function infoMossa4()
  testoMossa.text = "Mossa4 : Questa mossa genera gettere & settere\nAttacco = 20%\nDifesa = 50%\nVelocità = 20%"
end

	local background = display.newImageRect( sceneGroup, "Images/Backgrounds/proceduralBack/Stanze/back1.jpg", 1280, 720 )
	 background.x = display.contentCenterX
	 background.y = display.contentCenterY

   local underBar = display.newImageRect( sceneGroup, "Images/Backgrounds/FightBar.png", 1280, 720)
   underBar.x = display.contentCenterX
   underBar.y = display.contentCenterY

		local mossa1 = display.newText( sceneGroup, "Mossa1", 200, 515, native.systemFont, 50 )
    mossa1:setFillColor( 0.82, 0.86, 1 )

    local mossa2 = display.newText( sceneGroup, "Mossa2", 560, 515, native.systemFont, 50 )
    mossa2:setFillColor( 0.82, 0.86, 1 )

    local mossa3 = display.newText( sceneGroup, "Mossa3", 200, 650, native.systemFont, 50 )
    mossa3:setFillColor( 0.82, 0.86, 1 )

    local mossa4 = display.newText( sceneGroup, "Mossa4", 560, 650, native.systemFont, 50 )
    mossa4:setFillColor( 0.82, 0.86, 1 )

    mossa1:addEventListener( "tap", infoMossa1 )
    mossa2:addEventListener( "tap", infoMossa2 )
    mossa3:addEventListener( "tap", infoMossa3 )
    mossa4:addEventListener( "tap", infoMossa4 )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    -- audio.play( menuTrack, {channel =1 , loops = -1})
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
    -- Stop the music!

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
