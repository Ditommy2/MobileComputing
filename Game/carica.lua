local composer = require("composer")
local scene = composer.newScene( )

local utenteTextField
local passTextField
local button
local serverAnswer

local function networkListener( event )
  local risposta = event.response
    if ( event.isError ) then
        print( "Network error: ", risposta )
    else
      if(risposta == "" ) then
        serverAnswer.text = "Username o password errati."
        serverAnswer:setFillColor(1,0,0)
        serverAnswer.alpha = 1
        transition.to( serverAnswer, { time=3000, alpha=0 } )
      else
        serverAnswer.text = risposta
        serverAnswer:setFillColor(0,1,0)
        serverAnswer.alpha = 1
      end
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
  local loginGroup = display.newGroup()

  local utenteText = display.newText( "Username: ", 100, 50,native.systemFont, 20)
  utenteText.anchorX = 0
  utenteText.anchorY = 0
  utenteTextField = native.newTextField( 100, 70, 200, 30 )
  utenteTextField.anchorX = 0
  utenteTextField.anchorY = 0

  local utentePassw = display.newText( "Password: ", 100,110,native.systemFont, 20)
  utentePassw.anchorX = 0
  utentePassw.anchorY = 0
  passTextField = native.newTextField( 100, 130, 200, 30 )
  passTextField.anchorX = 0
  passTextField.anchorY = 0

  button = display.newText("Carica", 450,105, native.systemFont, 40)
  button:addEventListener("tap", getSavings)

  loginGroup:insert(utenteText)
  loginGroup:insert(utenteTextField)
  loginGroup:insert(utentePassw)
  loginGroup:insert(passTextField)
  loginGroup:insert(button)

  sceneGroup:insert(loginGroup)

  serverAnswer = display.newText("", display.contentCenterX, 200, native.systemFont, 20)
  serverAnswer.alpha=0
  sceneGroup:insert(serverAnswer)
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
