local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local Username
local password
--local function handleButtonEvent( event )
  --  if ( "ended" == event.phase ) then
  --  	local URL = "http://web.web.com/yourscript.php?username=" .. urlencode( username.text ) .. "&password=" .. urlencode(password.text)
--network.request(URL, "GET", networkListener)


--	end
--end
--http://localhost/mobilecomputing/insert.php?name=braga&password=123
--delete from user where name!='paolo'
local function urlencode(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
		function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str
end

local function networkListener( event )

    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
    	print( event.response )
    end
end

local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
    	local URL = "http://192.168.1.153:80/mobilecomputing/insert.php?name=" .. urlencode( username.text ) .. "&password=" ..urlencode(password.text)
      print(URL)
        network.request(URL, "GET", networkListener)
	end
end

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

 username = native.newTextField( 160, 200, 180, 30 )
username.placeholder = "Username"
sceneGroup:insert(username)

 password = native.newTextField( 160, 260,180, 30 )
password.isSecure = true
password.placeholder = "Password"
sceneGroup:insert(password)

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


end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

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

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
