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
local customFont="MadnessHyperactive.otf"
local oggetti = stanzaCorrente.oggetti
local gameTrack = audio.loadStream( "audio/back/Monsters-Underground.mp3")

--Physics (necessaria per il movimento del personaggio)
local physics = require("physics")
physics.start()
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Variabili personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local character
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione per caricare un nuovo livello quando sono stati sconfitti tutti i nemici
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function nuovoLivello(self)
  local sceneGroup = self.view
  local interfaccia = require("interfaceConfig")
  local numero = interfaccia.numeroStanze
  local tabella = interfaccia.tabellaFunction(numero)
  mappa = lowerFixedMenu.create.mappaGenerata(0, {}, numero, tabella, numero+1, numero+1)
  mappa.corrente=true

  local newLevelBack = display.newImageRect(sceneGroup, "Images/Backgrounds/Black.jpg", 1280, 720)
  newLevelBack.x = display.contentCenterX
  newLevelBack.y = display.contentCenterY
  local newLevel = display.newText(sceneGroup, "LIVELLO COMPLETATO", 600, 200, native.systemFont, 100)
  newLevel.x = display.contentCenterX
  newLevel.y = display.contentCenterY
  newLevel:setFillColor(0, 1, 0)

  local function goToNuovoLivello()
    composer.setVariable( "stanzaCorrente", mappa )
    composer.setVariable( "mappa", mappa )
    composer.setVariable( "mapx", 352 )
    composer.setVariable( "mapy", 200 )
    composer.removeScene( "Scenes.livello1" )
    composer.gotoScene("Scenes.livello1")
  end

  timer.performWithDelay( 2000, goToNuovoLivello )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione per tornare al menu. Quando chiamata deve salvare tutti i dati in maniera persistente per poter recuperare la partita in qualsiasi momento
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function gotoMenu()
  audio.stop( 2 )
  audio.play( menuTrack, {channel =1 , loops = -1})
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
    speedBuff = composer.getVariable("speedBuff"),
    nemici = composer.getVariable( "nemici" )
  }


  local stringaSalvataggio = "save".."$$"..composer.getVariable("username")..".json"
  local tabelloneSalvataggi = fileHandler.loadTable(stringaSalvataggio)
  if(tabelloneSalvataggi == nil) then
    tabelloneSalvataggi = {}
    table.insert(tabelloneSalvataggi, salvataggio)
  else
    local statoPartita = composer.getVariable( "statoPartita" )
    if(statoPartita.stato == "salvata") then
      tabelloneSalvataggi[statoPartita.indice] = salvataggio
    else
      table.insert(tabelloneSalvataggi, salvataggio)
    end
  end

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
  local errorText = display.newText( message, display.contentCenterX, display.contentCenterY + 50, native.newFont( customFont), 40 )
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

  local titolo = display.newText("Scegli una direzione", menuScelta.x, menuScelta.y - (altezzaFinestra/2), native.newFont( customFont), 80)
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
  if(composer.getVariable( "endFight" ) == nil) then
    composer.setVariable("endFight", "false")
  end



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
    if not(stanzaCorrente.oggetti[j]==nil) then
      local oggetto = display.newImageRect("Images/Icons/icons3/"..stanzaCorrente.oggetti[j], 50, 50)
      if not(oggetto==nil) then
        oggetto.x=lunghezza * 0.7
        oggetto.y = altezza-390
        mainGroup:insert(oggetto)
      end
    end
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

  local scoreText = display.newText( mainGroup,   "",  150, 150, customFont)
  scoreText.x = display.contentCenterX+550
  scoreText.y = display.contentCenterY-275
  scoreText.text = "score: " .. composer.getVariable( "score" )

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

  if composer.getVariable( "endFight" ) == "true" then
    --print("composer end fight : true")
  else
    --print("composer end fight : false")
  end

  if (composer.getVariable("characterFood") == 0 and not(composer.getVariable( "endFight" )=="true")) then

    local textDamage = display.newText(mainGroup, "", character.x, character.y - character.height-50, native.newFont( customFont), 100)

    local function removeTextDamage()
      textDamage.alpha = 0
    end

    	textDamage:setFillColor(1, 0, 0)
      local danno = 500
      textDamage.alpha = 1
  		textDamage.text = danno

      local vitaPersonaggio = composer.getVariable( "characterLife" )

      local  lifeBarCharacterBlack = display.newImageRect( mainGroup, "Images/Utility/lifeBarBlack.png", 200, 200 )
      lifeBarCharacterBlack.alpha = 1
    	lifeBarCharacterBlack.x = character.x
    	lifeBarCharacterBlack.y = character.y - character.height

    	local lifeBarCharacter = display.newImageRect( mainGroup, "Images/Utility/lifeBarGreen.png", 200, 200 )
      lifeBarCharacter.anchorX = 0
      lifeBarCharacter.anchorY = 0.5
      lifeBarCharacter.alpha = 1
    	lifeBarCharacter.x = lifeBarCharacterBlack.x - (lifeBarCharacterBlack.width/2)
    	lifeBarCharacter.y = character.y - character.height
      --print("lunghezza barra prima: " .. lifeBarCharacter.width)
      local rapporto = lifeBarCharacter.width / 3000
      --print("rapporto: " .. rapporto)
      --print("vitaPersonaggio prima: " .. vitaPersonaggio)
      local x = (3000 - (vitaPersonaggio - danno)) * rapporto		--Pixel dal levare
      --print("pixel calcolati: " .. x)
      lifeBarCharacter.width = lifeBarCharacter.width - x
      --print("lunghezza barra dopo: " .. lifeBarCharacter.width)
      composer.setVariable( "characterLife", vitaPersonaggio-danno)
      --print("vitaPersonaggio dopo: " .. vitaPersonaggio-danno)

      local function removeBarDamage()
        lifeBarCharacter.alpha = 0
        lifeBarCharacterBlack.alpha = 0
      end
      timer.performWithDelay(1500, removeTextDamage)
      timer.performWithDelay(1500, removeBarDamage)

    textDamage:setFillColor(1, 0, 0)
    local danno = 500
    textDamage.alpha = 1
    textDamage.text = danno
  end


  if composer.getVariable("characterLife")<=0 then
    characterInterface.gameOver(mainGroup)
  end
  sceneGroup:insert(mainGroup)
  sceneGroup:insert(hidingGroup)
  composer.setVariable("sceneGroup", sceneGroup)

  local endFight = composer.getVariable( "endFight" )

  if (endFight=="true") then
    local interface = require("interfaceConfig")
    interface.dropItemFunction(composer.getVariable( "enemyX" ), composer.getVariable( "enemyY" ), composer.getVariable( "tabDrop" ))
  end

  --Controllo se il livello è stato superato
  local nemici = composer.getVariable( "nemici" )
  if not(nemici == "vuoto") then
    if(#nemici==0) then
      --print("controllo true")
      nuovoLivello(self)
    end

    for i=1, #nemici, 1 do
      --print(nemici[i].id .. ": " .. nemici[i].enemy.immagine)
    end
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
    audio.stop( 1 )
    audio.play( gameTrack, { channel=2, loops=-1 } )
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
  composer.setVariable("endFight", "false")
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
