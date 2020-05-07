local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene( )

--Game window (16:9 aspect ratio)
local width = display.contentWidth
local height = display.contentWidth * (9/16)

local utenteTextField
local passTextField
local button
local serverAnswer
local loginGroup

local function networkListener( event )
  local risposta = event.response

  print(event.response)

    if ( event.isError ) then
        print( "Network error: ", risposta )
    else
      if(risposta == "" ) then
        serverAnswer.text = "Username o password errati."
        serverAnswer:setFillColor(1,0,0)
        serverAnswer.alpha = 1
        transition.to( serverAnswer, { time=4000, alpha=0 } )
      else
        composer.gotoScene("Scenes.nuovaCarica")
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

  local background=display.newImageRect(sceneGroup, "Images/Backgrounds/background.png", width, height)
  background.x=display.contentCenterX
  background.y=display.contentCenterY
  sceneGroup:insert(background)

  local title = display.newImageRect( sceneGroup, "Images/Utility/title.png", 600, 100 )
   title.x = display.contentCenterX
   title.y = 200

  loginGroup = display.newGroup()

  utenteTextField = native.newTextField( 0, height*0.1, width*0.4, height * 0.1)
  utenteTextField.placeholder = "username"
  loginGroup:insert(utenteTextField)

  passTextField = native.newTextField( 0, utenteTextField.height + utenteTextField.height*2, width*0.4, utenteTextField.height)
  passTextField.placeholder = "password"
  loginGroup:insert(passTextField)

  button = widget.newButton({
      shape = "roundedRect",
      x = width*0.6,
      y = height*0.25,
      width=width*0.3,
      height= height * 0.2,
      id = "login",
      label = "Login",
      labelColor={default={0.5, 0, 0}},
      fontSize=50,
      onEvent = handleButtonEvent
  })
  loginGroup:insert(button)

  utenteTextField.anchorX = 0
  utenteTextField.anchorY = 0
  passTextField.anchorX = 0
  passTextField.anchorY = 0
  passTextField.anchorX = 0
  passTextField.anchorY = 0
  button.anchorX = 0

  loginGroup.y = height * 0.35

  button:addEventListener("tap", getSavings)

  sceneGroup:insert(loginGroup)

  serverAnswer = display.newText("", display.contentCenterX, height*0.85, native.systemFont, height*0.1)
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
    for i = loginGroup.numChildren, 1, -1 do
      loginGroup[i]:removeSelf()
      loginGroup[i] = nil
    end

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
