-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local customFont="MadnessHyperactive.otf"
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoLogin()
		composer.gotoScene( "Scenes.login", {time=800, effect="crossFade"} )
end

local function gotoRegister()
		composer.gotoScene( "Scenes.register", {time=800, effect="crossFade"} )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- create()
function scene:create( event )
	local sceneGroup = self.view
	local background = display.newImageRect( sceneGroup, "Images/Backgrounds/proceduralBack/Corridoi/back1.jpg", 1280, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "Images/Utility/title.png", 600, 100 )
	title.x = display.contentCenterX
	title.y = 200

	local loginButton = display.newText( sceneGroup, "Login", display.contentCenterX, 400, native.newFont( customFont), 70 )
	loginButton:setFillColor( 0.82, 0.86, 1 )

	local registerButton = display.newText( sceneGroup, "Register", display.contentCenterX, 550, native.newFont( customFont), 70 )
	registerButton:setFillColor( 0.75, 0.78, 1 )

	loginButton:addEventListener( "tap", gotoLogin )
	registerButton:addEventListener( "tap", gotoRegister )
	menuTrack = audio.loadStream( "audio/GameOfThrones.mp3" )
end

-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    audio.play( menuTrack, {channel =1 , loops = -1})
	end
end

-- hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		composer.removeScene("Scenes.menu")

    audio.stop( 1 )
	end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  -- Dispose audio!
  audio.dispose( menuTrack )
	for i = sceneGroup.numChildren, 1, -1 do
    sceneGroup[i]:removeSelf()
    sceneGroup[i] = nil
  end
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
