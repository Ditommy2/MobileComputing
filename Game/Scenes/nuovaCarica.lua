local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene( )
local interfaccia = require("interfaceConfig")
--Game window (16:9 aspect ratio)
local width = display.contentWidth
local height = display.contentWidth * (9/16)
local nomePartita
local buttonNuova
local buttonCarica
local serverAnswer
local numeroStanze=interfaccia.numeroStanze
local numero = numeroStanze
local tabella = interfaccia.tabellaFunction(numero)
local sceneGroup
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--handle del bottone per 'overlay sottostante. Non so perchè ma non andava con quello classico
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function handleButtonEventNuovaNome(event)
	local bottone = event.target
    if ( "ended" == event.phase ) then
	if bottone.id=="NuovaPartitaNome" then
		composer.setVariable( "nomePartita", nomePartita.text )
		local table = {}
		table[1]={posizionamentoFixedX=0, posizionamentoFixedY=0}
		composer.setVariable( "tabellaOgegttiInventario", table )
		local lowerFixedMenu = require("lowerFixedMenu")
		inv = lowerFixedMenu.create.inventario
		mappa = lowerFixedMenu.create.mappaGenerata(0, {}, numero, tabella, numero+1, numero+1)
		mappa.corrente=true
		funzione=lowerFixedMenu.display
		composer.setVariable( "stanzaCorrente", mappa )
		composer.setVariable( "inv", inv )
		composer.setVariable( "mappa", mappa )
		composer.setVariable( "funzione", funzione )
		composer.setVariable( "mapx", 352 )
		composer.setVariable( "mapy", 200 )
		composer.removeScene( "Scenes.nuovaCarica" )
		composer.gotoScene("Scenes.livello1")
	end
end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--crea una finestra di dialogo per far inserire un nome al salvataggio che sis ta per creare
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function overlayNuovaNome()
	local nuovaPartitaOverlayGroup = display.newGroup()
	local lunghezza =  display.contentWidth
  local lunghezzaFinestra=lunghezza-400
	local altezzzaFinestra=lunghezzaFinestra*(9/16)
	local midBackground = display.newRect( display.contentCenterX, display.contentCenterY, lunghezzaFinestra, altezzzaFinestra )
	midBackground:setFillColor(0.18, 0.18, 0.23)
	nuovaPartitaOverlayGroup:insert(midBackground)

	nomePartita = native.newTextField( display.contentCenterX, display.contentCenterY-100, lunghezzaFinestra-30, 80 )
  nomePartita.placeholder = "Nuova Partita"
	nuovaPartitaOverlayGroup:insert(nomePartita)

	local Button = widget.newButton(
	   {
	       shape = "roundedRect",
	       left = 70,
	       top = 360,
				 width=lunghezzaFinestra-200,
				 height=90,
	       id = "NuovaPartitaNome",
	       label = "Nuova Partita",
				 labelColor={default={0.5, 0, 0}},
				 fontSize=50,
	       onEvent = handleButtonEventNuovaNome
	   }
	)
	nuovaPartitaOverlayGroup:insert(Button)
	Button.x=display.contentCenterX
	Button.y=display.contentCenterY+100
	nuovaPartitaOverlayGroup.x=display.contentCenterX-650
	nuovaPartitaOverlayGroup.y=display.contentCenterY-300
	sceneGroup:insert(nuovaPartitaOverlayGroup)

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--crea una finestra di dialogo in cui è possibile scegliere tutti i vari salvataggi
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--handle dei bottoni. ha due azioni differenti in caso si prema il bottone nuova o il bottone carica
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function handleButtonEvent( event )
	local bottone = event.target
    if ( "ended" == event.phase ) then
			--------------------------------------------------------------------------------------------------------------------------------------
			--se il bottone premuto è la nuova partita allora si deve generare una mappa e partire dal livello 1. il gioco ha inizio
			--------------------------------------------------------------------------------------------------------------------------------------
			if bottone.id=="nuova" then
				overlayNuovaNome()

			end
			--------------------------------------------------------------------------------------------------------------------------------------
			--se il bottone premuto è il carica si deve mostrare una lista di salvataggi collegati all'account che ha eseguito il login.
			--a quel punto la scelta di un salvataggio porterà a riprendere quella partita da dove è stat lasciata
			--------------------------------------------------------------------------------------------------------------------------------------
			if bottone.id=="carica" then
			local table = {}
			table[1]={posizionamentoFixedX=0, posizionamentoFixedY=0}
			composer.setVariable( "tabellaOgegttiInventario", table )
			local lowerFixedMenu = require("lowerFixedMenu")
			local fileHandler = require("fileHandler")
			local salvataggi = fileHandler.loadTable("saves"..composer.getVariable("username")..".json")
			print(salvataggi.stanzaCorrenteToSave)
			print(salvataggi.invToSave)
			print(salvataggi.mappaToSave)
			print(salvataggi.mapxToSave)
			print(salvataggi.mapyToSave)
			composer.setVariable( "stanzaCorrente", salvataggi.stanzaCorrenteToSave )
			composer.setVariable( "inv", salvataggi.invToSave )
			composer.setVariable( "mappa", salvataggi.mappaToSave )
			composer.setVariable( "mapx", salvataggi.mapxToSave )
			composer.setVariable( "mapy", salvataggi.mapyToSave )
			funzione=lowerFixedMenu.display
			composer.setVariable( "funzione", funzione )
			--composer.setVariable( "funzione", salvataggi.displayFunzioneToSave )
			composer.removeScene( "Scenes.nuovaCarica" )
			composer.gotoScene("Scenes.livello1")
			end


		end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	sceneGroup = self.view

  local background=display.newImageRect(sceneGroup, "Images/Backgrounds/proceduralBack/Corridoi/back1.jpg", width, height)
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
      label = "New Game",
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
      label = "Load Game",
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
returnButton.x = display.contentCenterX-550
returnButton.y = display.contentCenterY-550
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
	for i = sceneGroup.numChildren, 1, -1 do
		sceneGroup[i]:removeSelf()
		sceneGroup[i] = nil
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
