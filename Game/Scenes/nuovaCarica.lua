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
local customFont="MadnessHyperactive.otf"
local fileHandler = require("fileHandler")
--local customFont=native.systemFont
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--handle del bottone per 'overlay sottostante. Non so perchè ma non andava con quello classico
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function handleButtonEventNuovaNome(event)
	local bottone = event.target
	if ( "ended" == event.phase ) then
		if bottone.id=="NuovaPartitaNome" then
			composer.setVariable( "nomePartita", nomePartita.text )
			-- local table = {}
			-- table[1]={posizionamentoFixedX=0, posizionamentoFixedY=0}
			-- composer.setVariable( "tabellaOgegttiInventario", table )
			local partitaDaCercare = composer.getVariable( "nomePartita" )
			local t = fileHandler.loadTable("save$$"..composer.getVariable("username")..".json")
			local trovato = false
			if t == nil then
				t={}
			end
			for i=#t, 1, -1 do
				if t[i].nomePartita==partitaDaCercare then
					-- print("nome riscontrato")
					trovato = true
				end
			end

			if not trovato then
				local lowerFixedMenu = require("lowerFixedMenu")
				local inv = {"chiaveForziere", "cibo", "pozioneDanno", "pillolaSpeed", "pozioneMaxVita", "vuoto", "vuoto", "vuoto", "vuoto", "vuoto"}
				--local inv = {"I054-ham.png", "002-shield-2.png", "016-potion-1.png", "017-hammer.png", "029-key.png", "vuoto", "vuoto", "vuoto", "vuoto", "vuoto"}
				-- print("inventario caricato: " )
				-- for x=1, #inv, 1 do
				-- 	print(inv[x])
				-- end
				--
				-- local invComp = composer.getVariable( "inv" )
				--
				-- print("inventario composer prima: " )
				-- if(not(invComp ==nil)) then
				-- 	for x=1, #invComp, 1 do
				-- 		print(invComp[x])
				-- 	end
				-- end

				mappa = lowerFixedMenu.create.mappaGenerata(0, {}, numero, tabella, numero+1, numero+1)
				mappa.corrente=true
				funzione=lowerFixedMenu.display
				composer.setVariable( "stanzaCorrente", mappa )
				composer.setVariable( "inv", inv )

				invComp = composer.getVariable( "inv" )

				-- print("inventario composer dopo: " )
				-- if(not(invComp ==nil)) then
				-- 	for x=1, #invComp, 1 do
				-- 		print(invComp[x])
				-- 	end
				-- end


				composer.setVariable( "armorBuff", 0 )
				composer.setVariable( "damageBuff", 0 )
				composer.setVariable( "speedBuff", 0)
				composer.setVariable( "mappa", mappa )
				composer.setVariable( "funzione", funzione )
				composer.setVariable( "mapx", 352 )
				composer.setVariable( "mapy", 200 )
				composer.setVariable( "statoPartita", {stato = "nuova"} )
				composer.setVariable( "score", 0 )
				composer.removeScene( "Scenes.nuovaCarica" )
				composer.gotoScene("Scenes.livello1")
			else
				--il nome partia è già usato per questo utente
				print("il nome partita è già preso per questo utente")
				local serverAnswer = display.newText("", display.contentCenterX, height*0.85, customFont, height*0.1)
				serverAnswer.text = "Nome partita in uso"
				serverAnswer:setFillColor(1,0,0)
				serverAnswer.alpha = 1
				transition.to( serverAnswer, { time=4000, alpha=0 } )
				sceneGroup:insert(serverAnswer)
			end
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

	nomePartita = native.newTextField( display.contentCenterX, display.contentCenterY-100,  lunghezzaFinestra-30, 80 )
	nomePartita.font=native.newFont(customFont, 50)
	nomePartita.placeholder = "New Game"
	nuovaPartitaOverlayGroup:insert(nomePartita)

	local Button = widget.newButton(
	{
		shape = "roundedRect",
		left = 70,
		top = 360,
		width=lunghezzaFinestra-200,
		height=90,
		id = "NuovaPartitaNome",
		label = "New Game",
		labelColor={default={0.5, 0, 0}},
		fontSize=50,
		onEvent = handleButtonEventNuovaNome,
		font=customFont
	}
)
nuovaPartitaOverlayGroup:insert(Button)
Button.x=display.contentCenterX
Button.y=display.contentCenterY+90

local function handleBackButtonEventNuova(event)
	if ( "ended" == event.phase ) then
		nuovaPartitaOverlayGroup:remove( backButton )
	end
end

local backButtonNuova = widget.newButton(
{
	shape = "roundedRect",
	left = 70,
	top = 360,
	width=lunghezzaFinestra-200,
	height=90,
	id = "Back",
	label = "Back",
	labelColor={default={0.5, 0, 0}},
	fontSize=50,
	onEvent = handleBackButtonEventNuova,
	font=customFont
}
)
nuovaPartitaOverlayGroup:insert(backButtonNuova)
backButtonNuova.x=display.contentCenterX
backButtonNuova.y=display.contentCenterY+190

nuovaPartitaOverlayGroup.x=display.contentCenterX-650
nuovaPartitaOverlayGroup.y=display.contentCenterY-300
sceneGroup:insert(nuovaPartitaOverlayGroup)

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--crea la finestra di overlay per scegliere quale salvataggio caricare da file locali
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function overlayCaricaSalvataggi()
	local fileHandler = require("fileHandler")
	local salvataggi = fileHandler.loadTable("save".."$$"..composer.getVariable("username")..".json")
	if salvataggi == nil then
		salvataggi = {}
	end
	local caricaPartitaOverlayGroup = display.newGroup()
	local lunghezza =  display.contentWidth
	local lunghezzaFinestra=lunghezza-400
	local altezzzaFinestra=lunghezzaFinestra*(9/16)
	-- ScrollView listener
	local function scrollListener( event )

		local phase = event.phase
		if ( phase == "began" ) then
		elseif ( phase == "moved" ) then
		elseif ( phase == "ended" ) then
		end

		-- In the event a scroll limit is reached...
		if ( event.limitReached ) then
			if ( event.direction == "up" ) then
			elseif ( event.direction == "down" ) then
			elseif ( event.direction == "left" ) then
			elseif ( event.direction == "right" ) then
			end
		end

		return true
	end

	-- Create the widget
	local scrollView = widget.newScrollView(
	{
		horizontalScrollDisabled = true,
		width = lunghezzaFinestra,
		height = altezzzaFinestra,
		scrollWidth = lunghezzaFinestra,
		scrollHeight = 2,
		listener = scrollListener
	}
)
scrollView.x=display.contentCenterX
scrollView.y=display.contentCenterY
local background1 = display.newImageRect(  "Images/Backgrounds/brickWall.jpg", lunghezza, 920)
background1.x=scrollView.x-200
background1.y=scrollView.y
scrollView:insert( background1 )
local background2 = display.newImageRect(  "Images/Backgrounds/brickWall.jpg", lunghezza, 920)
background2.x=scrollView.x-200
background2.y=scrollView.y+920

scrollView:insert( background2 )

local function handleBackButtonEvent(event)
	if ( "ended" == event.phase ) then
		print("cancellato")
		caricaPartitaOverlayGroup:remove( scrollView )
	end
end

local function handleLoadButtonEvent(event)
	if ( "ended" == event.phase ) then
		local table = {}
		table[1]={posizionamentoFixedX=0, posizionamentoFixedY=0}
		-- composer.setVariable( "tabellaOgegttiInventario", table )
		local lowerFixedMenu = require("lowerFixedMenu")
		local fileHandler = require("fileHandler")
		--overlayCaricaSalvataggi()
		local salvataggio = salvataggi[event.target.id]
		composer.setVariable( "statoPartita", {stato = "salvata", indice = event.target.id} )
		composer.setVariable( "stanzaCorrente", salvataggio.stanzaCorrenteToSave )
		composer.setVariable( "inv", salvataggio.invToSave )
		composer.setVariable( "mappa", salvataggio.mappaToSave )
		composer.setVariable( "mapx", salvataggio.mapxToSave )
		composer.setVariable( "mapy", salvataggio.mapyToSave )
		composer.setVariable("nomePartita", salvataggio.nomeSalvataggio)
		funzione=lowerFixedMenu.display
		composer.setVariable( "funzione", funzione )
		composer.setVariable( "characterLife", salvataggio.vitaPersonaggio )
		composer.setVariable("characterFood", salvataggio.foodPersonaggio)
		composer.setVariable( "score", salvataggio.score )
		composer.setVariable( "armorBuff", salvataggio.armorBuff )
		composer.setVariable( "damageBuff", salvataggio.damageBuff )
		composer.setVariable( "speedBuff", salvataggio.speedBuff )
		composer.removeScene( "Scenes.nuovaCarica" )
		composer.gotoScene("Scenes.livello1")
	end
end

local backButton = widget.newButton({
	shape = "roundedRect",
	x = background1.x * 0.3,
	y = background1.y * 0.2,
	width=background1.width*0.09,
	height=background1.height * 0.07,
	id = "back",
	label = "BACK",
	labelColor={default={0.5, 0, 0}},
	fontSize=50,
	onEvent = handleBackButtonEvent,
	font=customFont
})





for i = #salvataggi, 1, -1 do
	print("nome del salvataggio: ")
	print (salvataggi[i].nomeSalvataggio)
	local saveButton = widget.newButton({
		shape = "roundedRect",
		x = background1.x * 0.3,
		y = background1.y * 0.2 * (i+1),
		width=background1.width*0.99999,
		height=background1.height * 0.07,
		id = i,
		label = "SAVE "..i..":"..salvataggi[i].nomeSalvataggio,
		labelColor={default={0.5, 0, 0}},
		fontSize=50,
		onEvent = handleLoadButtonEvent,
		font=customFont
	})
	scrollView:insert(saveButton)
end
scrollView:insert(backButton)
caricaPartitaOverlayGroup:insert(scrollView)
sceneGroup:insert(caricaPartitaOverlayGroup)
scrollView:setScrollHeight(1500)
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
			overlayCaricaSalvataggi()
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
	local stringaScores = "saveScore.json"
	fileHandler.scaricaSave(stringaScores)
	local background=display.newImageRect(sceneGroup, "Images/Backgrounds/proceduralBack/Corridoi/back1.png", width, height)
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
		onEvent = handleButtonEvent,
		font=customFont
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
		onEvent = handleButtonEvent,
		font=customFont
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

	local returnButton = display.newImageRect( gameGroup, "Images/Utility/returnArrow.png", 100, 100 )
	returnButton.x = display.contentCenterX-550
	returnButton.y = display.contentCenterY-550
	returnButton:addEventListener("tap", gotoMenu)

	local function goToScore()
		local scrollOverlayRequired = require("score")
		local lunghezza =  display.contentWidth
		local lunghezzaFinestra=lunghezza-400
		local altezzzaFinestra=lunghezzaFinestra*(9/16)
		local stringaScores = "saveScore.json"
		fileHandler.scaricaSave(stringaScores)
		scrollOverlayRequired.handleButton(display, lunghezzaFinestra, altezzaFinestra, sceneGroup)

	end

	local scoreButton = display.newText( gameGroup, "Scores",  150, 150, customFont, 60)
	scoreButton.x = display.contentCenterX+550
	scoreButton.y = display.contentCenterY-500
	scoreButton:addEventListener("tap", goToScore)
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
