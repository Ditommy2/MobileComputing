local composer = require("composer")
local scene = composer.newScene( )

local utenteTextField
local passTextField
local button

local function networkListener( event )

    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        print ( "RESPONSE: " .. event.response )
    end
end

local function urlencode(str)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str
end

local function getSavings()
  local url = "http://127.0.0.1:80/testServer/carica.php?user=".. urlencode(utenteTextField.text) .. "&passw=" ..urlencode(passTextField.text)

  print(url)

  network.request( url, "GET", networkListener)
end

-- create()
function scene:create( event )
	local sceneGroup = self.view

  local utenteText = display.newText( "Username: ", 0,0,native.systemFont, 15)
  utenteText.anchorX = 0
  utenteText.anchorY = 0
  utenteText.x = 20
  utenteText.y = 65
  utenteTextField = native.newTextField( 120, 100, 200, 30 )

  local utentePassw = display.newText( "Password: ", 0,0,native.systemFont, 15)
  utentePassw.anchorX = 0
  utentePassw.anchorY = 0
  utentePassw.x = 20
  utentePassw.y = 130
  passTextField = native.newTextField( 120, 165, 200, 30 )

  button = display.newText("Carica", 0,0, native.systemFont, 30)
  button.x = 300
  button.y = 130
  button:addEventListener("tap", getSavings)

  sceneGroup:insert(utenteText)
  sceneGroup:insert(utenteTextField)
  sceneGroup:insert(utentePassw)
  sceneGroup:insert(passTextField)
  sceneGroup:insert(button)
end

-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then

	end
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then

	end
end

-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
