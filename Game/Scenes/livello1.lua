
local composer = require( "composer" )
composer.recycleAutomatically=false
local lowerFixedMenu= require("lowerFixedMenu")
local widget = require("widget")
local scene = composer.newScene()
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local funzione= composer.getVariable( "funzione" )
local mappaloc= composer.getVariable( "mappa" )
local invloc= composer.getVariable( "inv" )
local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
composer.recycleOnSceneChange = true

--Physics (necessaria per il movimento del personaggio)
local physics = require("physics")
physics.start()
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Variabili personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local character
local animationTimer
local moveTimer

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sheet options personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sheet_walking_Options =
{
  width=72,
  height=128,
  numFrames=9,
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sprite sheet personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sheet_walking = graphics.newImageSheet( "Images/Characters/Trump.png", sheet_walking_Options )

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Walking sequences table personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sequences_walking =
{
    --Right walking sequence
    {
        name = "rightWalk",
        start = 7,
        count = 3,
        time = 1000,
        loopCount = 0,
        loopDirection = "forward"
    },

    --Left walking sequence
    {
        name = "leftWalk",
        start = 4,
        count = 3,
        time = 1000,
        loopCount = 0,
        loopDirection = "forward"
    }
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Handle del movimento del personaggio
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Perform movement
local function move(event)
  local dir = event.source.params.direction

  if(not(dir==nil)) then
    if(dir=="r") then
      character.x = character.x + 5
    elseif(dir=="l") then
      character.x = character.x - 5
    end
  end
end

--Movement Listener
local function moveListener(event)
  local phase = event.phase
  local target = event.target
  local dir

  if(phase=="began") then
    display.getCurrentStage():setFocus(target)

    --Touch in the movement area, starting the right movement sprite animation
    if((event.x < target.nonMovementArea.minX) and (event.y < target.nonMovementArea.maxY)) then
      dir = "l"
      character:setSequence( "leftWalk" )
    elseif((event.x > target.nonMovementArea.maxX) and (event.y < target.nonMovementArea.maxY)) then
      dir = "r"
      character:setSequence( "rightWalk" )
    end

    --Start movement
    character:play()
    moveTimer = timer.performWithDelay( 30, move, 0)
    moveTimer.isPaused = false
    moveTimer.params = {direction=dir}
  elseif(phase=="moved") then   --Touch moved
    --Touch falls in the non-movement area
    if((event.x > target.nonMovementArea.minX and event.x < target.nonMovementArea.maxX) or (event.y > target.nonMovementArea.maxY)) then
      --Ending movement, canceling focus and stopping animation
      display.getCurrentStage():setFocus(nil)
      timer.cancel( moveTimer )
      character:pause()

      --Facing the right direction
      character:setFrame(1)
      return true
    end
  elseif (phase=="ended" or phase=="cancelled") then
    --Ending movement, canceling focus and stopping animation
    display.getCurrentStage():setFocus(nil)
    timer.cancel( moveTimer )
    character:pause()

    --Facing the right direction
    character:setFrame(1)
  end

  return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--sheet options per le freccette direzionali. è momentaneo dato che il movimento non verrà implementato così
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local sheetOptions=
{
  frames=
  {
    {--freccia nord
      x=53,
      y=56,
      width=909,
      height=624
    },
    {--freccia sud
      x=53,
      y=1357,
      width=963,
      height=641
    },
    {--freccia est
      x=1358,
      y=1,
      width=678,
      height=959
    },
    {--freccia ovest
      x=1074,
      y=1073,
      width=680,
      height=967
    },
  },
}
local objectSheet=graphics.newImageSheet( "Images/Utility/directionArrow.png", sheetOptions )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione per tornare al menu. Quando chiamata deve salvare tutti i dati in maniera persistente per poter recuperare la partita in qualsiasi momento
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function gotoMenu()
  -- local json=require("json")
  -- local filePathSalvataggio=system.pathForFile("salvataggi.json", system.DocumentsDirectory)
  -- local file = io.open( filePathComandi, "w" )
  -- if file then
  --   local stringa = "false"
  --   file:write(json.encode(stringa))
  --   io.close(file)
  -- end
  composer.removeScene("Scenes.livello1")
	composer.gotoScene( "Scenes.nuovaCarica", {time=800, effect="crossFade"} )
 end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione che gestisce la pressione dei tasti delle freccette. Anche questo è momentaneo, non rappresenta la versione finale
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function handleButtonEvent( event )
        local item=event.target
        local direzione = item.id
        composer.setVariable( "direzione", direzione )
      --  item:removeEventListener("tap", handleButtonEvent)
        -- print("DIREZIONE: ----------------------------------------------------------------------", direzione)
        -- print("MOVIMENTO DA ", stanzaCorrente.TESTO, " a ", stanzaCorrente[direzione].TESTO)
        stanzaCorrente.corrente=false
        composer.setVariable( "prossimaStanza", stanzaCorrente[direzione] )
      --  stanzaCorrente[direzione].corrente=true
      --  composer.setVariable( "stanzaCorrente", stanzaCorrente[direzione] )
      --  composer.removeScene( "livello1" )
      composer.removeScene("Scenes.livello1")
      composer.gotoScene("Scenes.corridoio")
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase create del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create()
function scene:create( event )
  -- print("SEED DIREZIONALE DEL CORRIDOIOOOO", stanzaCorrente.seedNORD)
  -- print("SEED DIREZIONALE DEL CORRIDOIOOOO", stanzaCorrente.seedSUD)
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local phase = event.phase
  funzione(self,  mappaloc, invloc)
  --composer.removeScene( "livello2")
  local numero = stanzaCorrente.seedBackground
  local immagine = "Images/Backgrounds/proceduralBack/Stanze/back"..numero..".jpg"
  -- print(immagine)
  local background=display.newImageRect(backGroup, immagine, lunghezza, altezza-300)
  background.x=display.contentCenterX
  background.y=display.contentCenterY-170
  physics.addBody(background, "static", {shape={ 0, 0, lunghezza, 0, lunghezza, altezza-300, 0, altezza-300}})
  background:addEventListener("touch", moveListener)

  --Setting non-movement area
  local area = {minX=lunghezza*0.2, minY=0, maxX=lunghezza-(lunghezza*0.2), maxY= altezza-300}
  background.nonMovementArea = area

  --Displaying character and setting sprite sheets
  character = display.newSprite( sheet_walking, sequences_walking )
  character:setSequence(rightWalk)
  character:setFrame(1)
  character.anchorY = 1
  character.x = lunghezza * 0.1
  character.y = altezza-310

--  sceneGroup:insert(background)
  mainGroup=display.newGroup()

  mainGroup:insert(character)
  -- print("stanza Corrente: ", stanzaCorrente.TESTO)
  if stanzaCorrente.NORD~=nil then
    local freccia = display.newImageRect(objectSheet, 1, 50, 50)
    freccia.id="NORD"
    freccia:addEventListener("tap", handleButtonEvent)
    mainGroup:insert(freccia)
    freccia.x=display.contentCenterX
    freccia.y=display.contentCenterY-325
  end

  if stanzaCorrente.SUD~=nil then
    local freccia = display.newImageRect(objectSheet, 2, 50, 50)
    freccia.id="SUD"
    freccia:addEventListener("tap", handleButtonEvent)
    mainGroup:insert(freccia)
    freccia.x=display.contentCenterX
    freccia.y=display.contentCenterY
  end

  if stanzaCorrente.EST~=nil then
    local freccia = display.newImageRect(objectSheet, 3, 50, 50)
    freccia.id="EST"
    freccia:addEventListener("tap", handleButtonEvent)
    mainGroup:insert(freccia)
    freccia.x=display.contentCenterX+600
    freccia.y=display.contentCenterY-150
  end

  if stanzaCorrente.OVEST~=nil then
    local freccia = display.newImageRect(objectSheet, 4, 50, 50)
    freccia.id="OVEST"
    freccia:addEventListener("tap", handleButtonEvent)
    mainGroup:insert(freccia)
    freccia.x=display.contentCenterX-600
    freccia.y=display.contentCenterY-150
  end

  --Barre nere
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

  local returnButton = display.newImageRect( mainGroup, "Images/Utility/returnArrow.png", 150, 150 )
  mainGroup:insert(returnButton)
  returnButton.x = display.contentCenterX-550
  returnButton.y = display.contentCenterY-300
  returnButton:addEventListener("tap", gotoMenu)
--local freccia = display.newImageRect(sceneGroup, objectSheet, 4, 50, 50)
--freccia.x=display.contentCenterX
--freccia.y=display.contentCenterY
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

--composer.removeScene("livello1")
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
   ---


	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--fase destroy del display
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- destroy()
function scene:destroy( event )

  local sceneGroup = scene.view
  print("Scena 'livello1' rimossa")
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

return scene
