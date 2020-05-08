local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene( )

--Game window (16:9 aspect ratio)
local width = display.contentWidth
local height = display.contentWidth * (9/16)

local buttonNuova
local buttonCarica
local serverAnswer

local function gotoMenu()
		composer.gotoScene( "Scenes.menu", {time=800, effect="crossFade"} )
end

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

  local background=display.newImageRect(sceneGroup, "Images/Backgrounds/background.png", width, height)
  background.x=display.contentCenterX
  background.y=display.contentCenterY
  sceneGroup:insert(background)

  local title = display.newImageRect( sceneGroup, "Images/Utility/title.png", 600, 100 )
   title.x = display.contentCenterX
   title.y = 200

  local gameGroup = display.newGroup()

  buttonNuova = widget.newButton({
      shape = "roundedRect",
      x = width*0.1,
      y = height*0.25,
      width=width*0.3,
      height= height * 0.2,
      id = "nuova",
      label = "Nuova Partita",
      labelColor={default={0.5, 0, 0}},
      fontSize=50,
      onEvent = handleButtonEvent
  })

  gameGroup:insert(buttonNuova)

  buttonCarica = widget.newButton({
      shape = "roundedRect",
      x = width*0.6,
      y = height*0.25,
      width=width*0.3,
      height= height * 0.2,
      id = "carica",
      label = "Carica Partita",
      labelColor={default={0.5, 0, 0}},
      fontSize=50,
      onEvent = handleButtonEvent
  })

  gameGroup:insert(buttonCarica)

  buttonNuova.anchorX = 0
  buttonCarica.anchorX = 0

  gameGroup.y = height * 0.35

  --button:addEventListener("tap", getSavings)

  sceneGroup:insert(gameGroup)

  serverAnswer = display.newText("", display.contentCenterX, 200, native.systemFont, 20)
  serverAnswer.alpha=0
  sceneGroup:insert(serverAnswer)

local returnButton = display.newImageRect( gameGroup, "images/Utility/returnArrow.png", 200, 200 )
returnButton.x = display.screenOriginX+100
returnButton.y = display.screenOriginY-150
returnButton:addEventListener("tap", gotoMenu)
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
    composer.removeScene("Scenes.nuovaCarica")

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
