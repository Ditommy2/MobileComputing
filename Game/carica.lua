local composer = require("composer")
local scene = composer.newScene( )

--Game window (16:9 aspect ratio)
local width = display.contentWidth
local height = display.contentWidth * (9/16)

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
  local url = "https://appmcsite.000webhostapp.com/carica.php?user=".. urlencode(utenteTextField.text) .. "&passw=" ..urlencode(passTextField.text)

  print(url)

  network.request( url, "GET", networkListener)
end

-- create()
function scene:create( event )
	local sceneGroup = self.view
  local loginGroup = display.newGroup()

  -- loginGroup.x = 0
  -- loginGroup.y = 0

  local utenteText = display.newText( "Username: ", 0, 0, native.systemFont, height*0.1)
  loginGroup:insert(utenteText)
  utenteTextField = native.newTextField( utenteText.x, utenteText.y + utenteText.height, width*0.4, utenteText.height)
  loginGroup:insert(utenteTextField)
  local utentePassw = display.newText( "Password: ", utenteText.x, utenteTextField.y + utenteTextField.height,native.systemFont, utenteText.height)
  loginGroup:insert(utentePassw)
  passTextField = native.newTextField( utentePassw.x, utentePassw.y + utentePassw.height, width*0.4, utenteText.height )
  loginGroup:insert(passTextField)
  button = display.newText("Carica", width*0.6, utenteText.y + utenteText.height + utenteTextField.height, native.systemFont, utenteText.height * 2)
  loginGroup:insert(button)

  utenteText.anchorX = 0
  utenteText.anchorY = 0
  utenteTextField.anchorX = 0
  utenteTextField.anchorY = 0
  utentePassw.anchorX = 0
  utentePassw.anchorY = 0
  passTextField.anchorX = 0
  passTextField.anchorY = 0
  passTextField.anchorX = 0
  passTextField.anchorY = 0
  button.anchorX = 0

  loginGroup.y = height * 0.25

  button:addEventListener("tap", getSavings)

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
