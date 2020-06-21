
local composer = require( "composer" )
local lowerFixedMenu= require("lowerFixedMenu")
local widget = require("widget")
local characterInterface = require("characterInterface")
local scene = composer.newScene()
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local funzioneEseguiDisplay= composer.getVariable( "funzione" )
local mappaloc= composer.getVariable( "mappa" )
local invloc= composer.getVariable( "inv" )
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
composer.recycleOnSceneChange = true
local customFont="MadnessHyperactive.otf"
--local customFont=native.systemFont
--Physics (necessaria per il movimento del personaggio)
local physics = require("physics")
physics.start()
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Variabili personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local character

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione per tornare al menu. Quando chiamata deve salvare tutti i dati in maniera persistente per poter recuperare la partita in qualsiasi momento
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function gotoMenu()
  local fileHandler = require("fileHandler")
  local salvataggio = {
    stanzaCorrenteToSave = composer.getVariable( "stanzaCorrente" ),
    invToSave = composer.getVariable( "inv" ),
    mappaToSave = composer.getVariable( "mappa" ),
    mapxToSave = composer.getVariable( "mapx" ),
    mapyToSave = composer.getVariable( "mapy" ),
    nomeSalvataggio = composer.getVariable( "nomePartita" ),
    giocatore = composer.getVariable( "username" ),
    nomePartita = composer.getVariable( "nomePartita" )
    --displayFunzioneToSave = composer.getVariable( "funzione" )
  }
  local stringaSalvataggio = "save".."$$"..composer.getVariable("username").."$$"..composer.getVariable("nomePartita")..".json"
  print(stringaSalvataggio)
  fileHandler.saveTable(salvataggio, stringaSalvataggio)
  fileHandler.caricaSave(salvataggio, stringaSalvataggio)
  composer.removeScene("Scenes.livello1")
 	composer.gotoScene( "Scenes.nuovaCarica", {time=800, effect="crossFade"} )
 end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione che gestisce la pressione dei tasti delle freccette. Anche questo è momentaneo, non rappresenta la versione finale
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

local function goTo(direction)
  stanzaCorrente.corrente=false
  composer.removeScene("Scenes.livello1")
  composer.gotoScene("Scenes.corridoio")
end

local function errorTab(message)
  local errorText = display.newText( message, display.contentCenterX, display.contentCenterY + 50, native.systemFont, 40 )
  errorText:setFillColor(1,0,0)
  transition.to(errorText, {time=2000, alpha=0, onComplete= function() display.remove( errorText) end})
end

local function handleDirectionChoose(event)
  local source = event.target
  local direction = source.id

  if(((direction == "NORD") and (stanzaCorrente.NORD ~= nil)) or
     ((direction == "SUD") and (stanzaCorrente.SUD ~= nil)) or
     ((direction == "EST") and (stanzaCorrente.EST ~= nil)) or
     ((direction == "OVEST") and (stanzaCorrente.OVEST ~= nil))) then

    composer.setVariable( "direzione", direction )
    goTo(direction)
  else
    --Show error tab
    errorTab("Direzione Inesistente")
  end
end

function goBack()
  local direction = composer.getVariable( "direzione" )

  if(direction~=nil) then
    composer.setVariable( "direzione", opposite(direction) )
    goTo(opposite(direction))
  else
    --Show error tab
    errorTab("Non puoi tornare indietro")
  end
end

function changeRoom()
  local sceneGroup = scene.view

  --Menu di scelta della direzione
  local lunghezzaFinestra=lunghezza-400
	local altezzaFinestra=lunghezzaFinestra*(9/16)

  local menuGroup = display.newGroup()

  local menuScelta = display.newRect( display.contentCenterX, display.contentCenterY, lunghezzaFinestra, altezzaFinestra )
	menuScelta:setFillColor(0.18, 0.18, 0.23)
	menuGroup:insert(menuScelta)

  local titolo = display.newText("Scegli una direzione", menuScelta.x, menuScelta.y - (altezzaFinestra/2), native.systemFontBold, 80)
  titolo:setFillColor(1,0,0)
  titolo.anchorY = 0
  menuGroup:insert(titolo)

  buttonNord = widget.newButton({
      shape = "roundedRect",
      x = menuScelta.x,
      y =  menuScelta.y - 100,
      width=150,
      height= 75,
      id = "NORD",
      label = "NORD",
      labelColor={default={0.5, 0, 0}},
      fontSize=20,
      onEvent = handleDirectionChoose
  })

  buttonSud = widget.newButton({
      shape = "roundedRect",
      x = menuScelta.x,
      y =  menuScelta.y + 200,
      width=150,
      height= 75,
      id = "SUD",
      label = "SUD",
      labelColor={default={0.5, 0, 0}},
      fontSize=20,
      onEvent = handleDirectionChoose
  })

  buttonEst = widget.newButton({
      shape = "roundedRect",
      x = menuScelta.x + 275,
      y =  menuScelta.y + 50,
      width=150,
      height= 75,
      id = "EST",
      label = "EST",
      labelColor={default={0.5, 0, 0}},
      fontSize=20,
      onEvent = handleDirectionChoose
  })

  buttonOvest = widget.newButton({
      shape = "roundedRect",
      x = menuScelta.x - 275,
      y =  menuScelta.y + 50,
      width=150,
      height= 75,
      id = "OVEST",
      label = "OVEST",
      labelColor={default={0.5, 0, 0}},
      fontSize=20,
      onEvent = handleDirectionChoose
  })

  menuGroup:insert(buttonNord)
  menuGroup:insert(buttonSud)
  menuGroup:insert(buttonEst)
  menuGroup:insert(buttonOvest)
  sceneGroup:insert(menuGroup)
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
  local numero = stanzaCorrente.seedBackground
  local immagine = "Images/Backgrounds/proceduralBack/Stanze/back"..numero..".jpg"
  local background=display.newImageRect(backGroup, immagine, lunghezza, altezza-300)
  background.x=display.contentCenterX
  background.y=display.contentCenterY-170
  physics.addBody(background, "static", {shape={ 0, 0, lunghezza, 0, lunghezza, altezza-300, 0, altezza-300}, isSensor=false})
  background:addEventListener("touch", characterInterface.listener)

  --Setting non-movement area
  local area = {minX=lunghezza*0.2, minY=0, maxX=lunghezza-(lunghezza*0.2), maxY= altezza-300}
  background.nonMovementArea = area

  --Displaying character and setting sprite sheets
  character = characterInterface.creaPersonaggio(self)

--  sceneGroup:insert(background)
  mainGroup=display.newGroup()

  mainGroup:insert(character)

  --Barre nere
  local hidingGroup = display.newGroup()

  if(display.actualContentWidth > lunghezza) then
    local barLeft = display.newRect(display.screenOriginX, 0, (display.actualContentWidth/2) - (lunghezza/2), altezza)
    local barRight = display.newRect(display.contentWidth, 0, (display.actualContentWidth/2) - (lunghezza/2), altezza)

    barLeft.anchorX = 0
    barLeft.anchorY = 0
    barRight.anchorX = 0
    barRight.anchorY = 0

    barLeft:setFillColor(0,0,0)
    barRight:setFillColor(0,0,0)

    barLeft.myName = "BarLeft"
    barRight.myName = "BarRight"

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

  local returnButton = display.newImageRect( mainGroup, "Images/Utility/returnArrow.png", 150, 150 )
  mainGroup:insert(returnButton)
  returnButton.x = display.contentCenterX-550
  returnButton.y = display.contentCenterY-300
  returnButton:addEventListener("tap", gotoMenu)

  sceneGroup:insert(mainGroup)
  sceneGroup:insert(hidingGroup)

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
    physics.start()

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
