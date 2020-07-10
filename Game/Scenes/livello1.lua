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
local enemyInterface = require("enemyInterface")
local curiosInterface = require("curiosInterface")
composer.recycleOnSceneChange = true
local customFont="MadnessHyperactive.otf"
local oggetti = stanzaCorrente.oggetti
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
    nomePartita = composer.getVariable( "nomePartita" ),
    vitaPersonaggio = composer.getVariable( "characterLife" ),
    foodPersonaggio = composer.getVariable( "characterFood" ),
    score = composer.getVariable("score"),
    armorBuff = composer.getVariable( "armorBuff" ),
    damageBuff = composer.getVariable("damageBuff"),
    speedBuff = composer.getVariable("speedBuff")
  }

  local score = composer.getVariable( "score" )
  local user = composer.getVariable( "username" )
  local game = composer.getVariable( "nomePartita" )
  local stringaScores = "saveScore".."$$"..".json"
  local tabellonePunteggi= fileHandler.loadTableScores(stringaScores)
  if(tabellonePunteggi == nil) then
    print("primoSalvataggio")
    tabellonePunteggi = {}
    -- table.insert(tabellonePunteggi, score .. "               " .. user .. "               " .. partita .. "\n")
    table.insert(tabellonePunteggi, {punteggio=score, utente=user, partita=game})
  else
    print("seguenti salvataggi")
    -- table.insert(tabellonePunteggi, score .. "               " .. user .. "               " .. partita .. "\n")
    table.insert(tabellonePunteggi, {punteggio=score, utente=user, partita=game})
  end

  fileHandler.saveTable(tabellonePunteggi, stringaScores)
  fileHandler.caricaSave(tabellonePunteggi, stringaScores)



  local stringaSalvataggio = "save".."$$"..composer.getVariable("username")..".json"
  -- print("caricando da ")
  -- print(stringaSalvataggio)
  local tabelloneSalvataggi = fileHandler.loadTable(stringaSalvataggio)
  if(tabelloneSalvataggi == nil) then
    -- print("primoSalvataggio")
    tabelloneSalvataggi = {}
    table.insert(tabelloneSalvataggi, salvataggio)
  else
    -- print("seguenti salvataggi")
    local statoPartita = composer.getVariable( "statoPartita" )
    if(statoPartita.stato == "salvata") then
      tabelloneSalvataggi[statoPartita.indice] = salvataggio
    else
    table.insert(tabelloneSalvataggi, salvataggio)
    end
  end

  -- print("salvando")
  -- print(tabelloneSalvataggi)
  fileHandler.saveTable(tabelloneSalvataggi, stringaSalvataggio)
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
  stanzaCorrente.corridoioCorrente=direction
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
  local mainGroup=display.newGroup()
  local phase = event.phase
  local curios = stanzaCorrente.curios
  local activeCurios = {}
  if not(curios==nil) then
    for i=#curios, 1, -1 do
        local curio = curiosInterface.createCurio(self, stanzaCorrente.curios[i])
        if not(curio==nil) then
          table.insert(activeCurios, curio)
          composer.setVariable("mainGroup", mainGroup)
          mainGroup:insert(curio)
        end
    end
  end

    composer.setVariable( "activeCurios", activeCurios )
    stanzaCorrente.curios=curios
    for j=#stanzaCorrente.oggetti, 1, -1 do
    local oggetto = display.newImageRect("Images/Icons/icons3/"..stanzaCorrente.oggetti[j], 50, 50)
    oggetto.x=lunghezza * 0.7
    oggetto.y = altezza-390
    mainGroup:insert(oggetto)
  end
  funzioneEseguiDisplay(self,  stanzaCorrente, invloc)
  local numero = stanzaCorrente.seedBackground
  local immagine = "Images/Backgrounds/proceduralBack/Stanze/back"..numero..".png"
  local background=display.newImageRect(backGroup, immagine, lunghezza, altezza-300)
  background.x=display.contentCenterX
  background.y=display.contentCenterY-150
  physics.addBody(background, "static", {shape={ 0, 0, lunghezza, 0, lunghezza, altezza-300, 0, altezza-300}, isSensor=false})
  background:addEventListener("touch", characterInterface.listener)

  --Setting non-movement area
  local area = {minX=lunghezza*0.2, minY=0, maxX=lunghezza-(lunghezza*0.2), maxY= altezza-300}
  background.nonMovementArea = area

  --Displaying character and setting sprite sheets
  character = characterInterface.creaPersonaggio(self)
  composer.setVariable("character", character)
    for i = #stanzaCorrente.nemici, 1, -1 do
        if(not(stanzaCorrente.nemici[i]==nil))then
          -- print("tabella nemico (in teoria)")
          -- print(stanzaCorrente.nemici[i].immagine)
          enemy = enemyInterface.createEnemy(self, stanzaCorrente.nemici[i])
          mainGroup:insert(enemy)
        end
    end




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

  local returnButton = display.newImageRect( mainGroup, "Images/Utility/returnArrow.png", 100, 100 )
  mainGroup:insert(returnButton)
  returnButton.x = display.contentCenterX-550
  returnButton.y = display.contentCenterY-300
  returnButton:addEventListener("tap", gotoMenu)

  Runtime:addEventListener('system', function(event)
    if(event.type == "applicationExit") then
      gotoMenu()
    end
  end )

  local function goToTutorial()
    local scrollOverlayRequired = require("tutorial")
    local lunghezza =  display.contentWidth
    local lunghezzaFinestra=lunghezza-400
  	local altezzzaFinestra=lunghezzaFinestra*(9/16)
    scrollOverlayRequired.handleButton(display, lunghezzaFinestra, altezzaFinestra, sceneGroup)

  end

  local tutorialButton = display.newText( mainGroup,   "How to Play",  150, 150, customFont)
  mainGroup:insert(returnButton)
  tutorialButton.x = display.contentCenterX+550
  tutorialButton.y = display.contentCenterY-300
  tutorialButton:addEventListener("tap", goToTutorial)

  local foodBarGreen = display.newImageRect( mainGroup, "Images/Utility/lifeBarGreen.png", 500, 100 )
  foodBarGreen.x = display.contentCenterX
	foodBarGreen.y = display.contentCenterY - 300
  mainGroup:insert(foodBarGreen)
  local foodToken = display.newImageRect( mainGroup, "Images/Icons/icons3/054-ham.png", 50, 50 )
  foodToken.x = (foodBarGreen.x + foodBarGreen.width/2) - (composer.getVariable( "characterMaxFood" )-composer.getVariable( "characterFood" ))
  foodToken.maxX = foodBarGreen.x + foodBarGreen.width/2
  foodToken.minX = foodBarGreen.x - foodBarGreen.width/2
  print("impostato food token x :"..foodToken.x)
  foodToken.y = foodBarGreen.y
  composer.setVariable("foodToken", foodToken)

  if composer.getVariable("characterFood") == 0 then

    local textDamage = display.newText(mainGroup, "", character.x, character.y - character.height-50, native.newFont( customFont), 100)

    local function removeTextDamage()
    	textDamage.alpha = 0
    end

  	textDamage:setFillColor(1, 0, 0)
    local danno = 3000 --500
    textDamage.alpha = 1
		textDamage.text = danno

    local vitaPersonaggio = composer.getVariable( "characterLife" )
    composer.setVariable( "characterLife", vitaPersonaggio-danno )

    local  lifeBarCharacterBlack = display.newImageRect( mainGroup, "Images/Utility/lifeBarBlack.png", 200, 200 )
    lifeBarCharacterBlack.alpha = 1
  	lifeBarCharacterBlack.x = character.x
  	lifeBarCharacterBlack.y = character.y - character.height

  	local lifeBarCharacter = display.newImageRect( mainGroup, "Images/Utility/lifeBarGreen.png", 200, 200 )
    lifeBarCharacter.alpha = 1
  	lifeBarCharacter.x = character.x
  	lifeBarCharacter.y = character.y - character.height
    local rapporto = lifeBarCharacter.width / composer.getVariable( "characterLife" )
    local x = danno * rapporto		--Pixel dal levare
    lifeBarCharacter.width = lifeBarCharacter.width - x
    lifeBarCharacter.x = lifeBarCharacter.x - x/2

    local function removeBarDamage()
      lifeBarCharacter.alpha = 0
      lifeBarCharacterBlack.alpha = 0
    end
    timer.performWithDelay(1500, removeTextDamage)
    timer.performWithDelay(1500, removeBarDamage)
  end


  if composer.getVariable("characterLife")<=0 then
    characterInterface.gameOver(mainGroup)
  end
  print("armor personaggio : "..character.armor)
  print("damage personaggio : "..character.damage)
  sceneGroup:insert(mainGroup)
  sceneGroup:insert(hidingGroup)
  composer.setVariable("sceneGroup", sceneGroup)

  --Drop item nemico
  local interfaceConfig = require("interfaceConfig")
  local enemyX = composer.getVariable( "enemyX" )
  local enemyY = composer.getVariable( "enemyY" )
  if not((enemyX==nil) and (enemyY==nil)) then
    interfaceConfig.dropItemFunction(enemyX, enemyY, sceneGroup)
    composer.setVariable( "enemyX", nil )
    composer.setVariable( "enemyY", nil )
  end

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase show del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- show()
function scene:show( event )

	local sceneGroup = self.view
  local phase=event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
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
