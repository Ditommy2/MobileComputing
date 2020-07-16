local composer = require( "composer" )
local lowerFixedMenu= require("lowerFixedMenu")
local widget = require("widget")
local characterInterface = require("characterInterface")
local interfaceConfig = require("interfaceConfig")
local scene = composer.newScene()
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local funzioneEseguiDisplay= composer.getVariable( "funzione" )
local mappaloc= composer.getVariable( "mappa" )
local invloc= composer.getVariable( "inv" )
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
local prossimaStanza=composer.getVariable( "prossimaStanza" )
local customFont="MadnessHyperactive.otf"

--Physics (necessaria per il movimento del personaggio)
local physics = require("physics")
physics.start()

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione gestione cambio stanza
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function opposite(dir)
  local res = nil

  if(dir=="SUD") then
    res="NORD"
  end

  if(dir=="NORD") then
    res="SUD"
  end

  if(dir=="EST") then
    res="OVEST"
  end

  if(dir=="OVEST") then
    res="EST"
  end

  return res
end

function goBack()
  local direction = composer.getVariable("direzione")
  stanzaCorrente.corridoioCorrente = nil
  stanzaCorrente.corrente=true
  composer.setVariable("stanzaCorrente", stanzaCorrente)
  composer.setVariable( "direzione", opposite(direction) )
  timer.cancel(moveTimer)
  composer.removeScene("Scenes.corridoio")
  composer.gotoScene("Scenes.livello1")
end

function changeRoom()
  local direction = composer.getVariable( "direzione" )
  stanzaCorrente.corridoioCorrente = nil
  timer.cancel(moveTimer)
  composer.setVariable( "stanzaCorrente", stanzaCorrente[direction])
  local prossimaStanza =composer.getVariable( "stanzaCorrente" )
  prossimaStanza.corrente=true

  composer.removeScene( "Scenes.corridoio")
  composer.gotoScene( "Scenes.livello1")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase create del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local phase = event.phase

  funzioneEseguiDisplay(self,  stanzaCorrente, invloc)
  local direzioneCorridoio = composer.getVariable( "direzione" )
  local seedDirezionale = "seed"..direzioneCorridoio
  local numeroRandomico = stanzaCorrente[seedDirezionale]
  local background=display.newImageRect(backGroup, "Images/Backgrounds/proceduralBack/Corridoi/back"..numeroRandomico..".png", lunghezza, altezza-300)
  background.direzione=stanzaCorrente.corridoioCorrente
  background.x=display.contentCenterX
  background.y=display.contentCenterY-150
  background:addEventListener("touch", characterInterface.listener)
  background:addEventListener("touch", interfaceConfig.tokenListener)
  --Setting non-movement area
  local area = {minX=lunghezza*0.2, minY=0, maxX=lunghezza-(lunghezza*0.2), maxY= altezza-300}
  background.nonMovementArea = area

  --Displaying character and setting sprite sheets
  character =  characterInterface.creaPersonaggio(self)
  mainGroup=display.newGroup()
  mainGroup:insert(character)

  --Barre nere laterali
  local hidingGroup = display.newGroup()

  if(display.actualContentWidth > lunghezza) then
    local barLeft = display.newRect(display.screenOriginX, display.screenOriginY, (display.actualContentWidth/2) - (lunghezza/2), altezza)
    local barRight = display.newRect(display.contentCenterX + (lunghezza/2), 0, (display.actualContentWidth/2) - (lunghezza/2), altezza)

    barLeft.anchorX = 0
    barLeft.anchorY = 0
    barRight.anchorX = 0
    barRight.anchorY = 0

    barLeft:setFillColor(0,0,0)
    barRight:setFillColor(0,0,0)

    hidingGroup:insert(barLeft)
    hidingGroup:insert(barRight)
  elseif(display.actualContentHeight > altezza) then
    local barUp = display.newRect(display.screenOriginX, display.screenOriginY, display.actualContentWidth, (display.actualContentHeight - altezza)/2)
    local barDown = display.newRect(display.screenOriginX, altezza, display.actualContentWidth, (display.actualContentHeight - altezza)/2)
    barUp.anchorX = 0
    barUp.anchorY = 0
    barDown.anchorX = 0
    barDown.anchorY = 0

    barUp:setFillColor(0,0,0)
    barDown:setFillColor(0,0,0)

    hidingGroup:insert(barUp)
    hidingGroup:insert(barDown)
  end


  local foodBarGreen = display.newImageRect( mainGroup, "Images/Utility/lifeBarGreen.png", 500, 100 )
  foodBarGreen.x = display.contentCenterX
	foodBarGreen.y = display.contentCenterY - 300
  mainGroup:insert(foodBarGreen)
  local foodToken = display.newImageRect( mainGroup, "Images/Icons/icons3/054-ham.png", 50, 50 )
  --print("food situation: " .. (composer.getVariable( "characterMaxFood" )-composer.getVariable( "characterFood" )))
  foodToken.x = (foodBarGreen.x + foodBarGreen.width/2) - (composer.getVariable( "characterMaxFood" )-composer.getVariable( "characterFood" ))
  foodToken.maxX = foodBarGreen.x + foodBarGreen.width/2
  foodToken.minX = foodBarGreen.x - foodBarGreen.width/2
  --print("impostato food token x :"..foodToken.x)
  foodToken.y = foodBarGreen.y
  composer.setVariable("foodToken", foodToken)

  sceneGroup:insert(mainGroup)
  sceneGroup:insert(hidingGroup)
  composer.setVariable("sceneGroup", sceneGroup)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase show del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- show()
function scene:show( event )

	local sceneGroup = self.view
  local phase=event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase hide del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase destroy del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- destroy()
function scene:destroy( event )

  local sceneGroup = scene.view
	-- Code here runs prior to the removal of scene's view
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

scene.goBack = (goBack)
scene.changeRoom = (changeRoom)

return scene
