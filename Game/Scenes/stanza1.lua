
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

--Configure image inventory
local inventory =
{
    frames =
    {
        {-- asteroide1
          x = 0,
          y = 0,
          width = 102,
          height = 85
        },
        {-- asteroide2
          x = 0,
          y = 85,
          width = 90,
          height = 83
        },
        {-- asteroide3
          x = 0,
          y = 168,
          width = 100,
          height = 97
        },
        {-- ship4
          x = 0,
          y = 265,
          width = 98,
          height = 79
        },
        {-- laser5
          x = 98,
          y = 265,
          width = 14,
          height = 40
        },
    },
}
local objectSheet = graphics.newImageSheet( "Images/Objects/gameObject.png", inventory )

-- Initialize variables


--Set up display groups
local backGroup                                              --for the background image
local mainGro                                                --for the ateroids, laser, ship4
local uiGroup

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen


		-- Set up display groups
    backGroup = display.newGroup()  -- Display group for the background image
    sceneGroup:insert( backGroup )  -- Insert into the scene's view group

    mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

    uiGroup = display.newGroup()    -- Display group for UI objects like the score
    sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

		-- Load the background
	 local background = display.newImageRect( backGroup, "Images/Backgrounds/background1.jpg", 1920, 1080 )
	 background.x = display.contentCenterX
	 background.y = display.contentCenterY


end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen


       -- Start the music!

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
  -- Dispose audio!

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
