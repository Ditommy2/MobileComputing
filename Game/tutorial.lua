local customFont="MadnessHyperactive.otf"
local function handleButtonEventTutorialFunzione(display, lunghezza, altezza, sceneGroup)
  local widget = require( "widget" )

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
    width = lunghezza,
    height = altezza,
    scrollWidth = lunghezza,
    scrollHeight = 2,
    listener = scrollListener
  }
)
scrollView.x=display.contentCenterX
scrollView.y=display.contentCenterY
-- Create a image and insert it into the scroll view
local background1 = display.newImageRect(  "Images/Backgrounds/brickWall.jpg", lunghezza, 920)
background1.x=scrollView.x-200
background1.y=scrollView.y
scrollView:insert( background1 )
local background2 = display.newImageRect(  "Images/Backgrounds/brickWall.jpg", lunghezza, 920)
background2.x=scrollView.x-200
background2.y=scrollView.y+920
scrollView:insert( background2 )
local background3 = display.newImageRect(  "Images/Backgrounds/brickWall.jpg", lunghezza, 920)
background3.x=scrollView.x-200
background3.y=scrollView.y+1840
scrollView:insert( background3 )
local background4 = display.newImageRect(  "Images/Backgrounds/brickWall.jpg", lunghezza, 920)
background4.x=scrollView.x-200
background4.y=scrollView.y+2760
scrollView:insert( background4 )

local textBackground = display.newRect(background1.x, background1.y, lunghezza-40, 400)
textBackground:setFillColor(0.32, 0.36, 0.4)
scrollView:insert(textBackground)

local textTutorial1 = display.newText(  "Benvenuto nel Danger Dungeon!!\nIn queste gallerie senza fine gli Eroi hanno l'opportunita' di dimostrare il loro valore!\n\nLa tua avventura inizia in questa stanza, tocca il lato destro o sinistro per muoverti nella rispettiva direzione.\n\nQuando avrai raggiunto l'altro capo della stanza scegli la prossima destinazione d esplora il labirinto!\n\nRicordati di usare la mappa che ti e' stata data, che puoi navigare in basso a sinistra!",
textBackground.x,
textBackground.y,
customFont,
30)
scrollView:insert(textTutorial1)

local tutorial1Image = display.newImageRect("Images/Utility/tutorial1.png", textBackground.width, textBackground.height)
tutorial1Image.x = textBackground.x
tutorial1Image.y = textBackground.y + textBackground.height + 10
scrollView:insert(tutorial1Image)

local textBackground2 = display.newRect(tutorial1Image.x, tutorial1Image.y + tutorial1Image.height + 10, lunghezza-40, 400)
textBackground2:setFillColor(0.32, 0.36, 0.4)
scrollView:insert(textBackground2)

local textTutorial2 = display.newText(  "Nel corso della tua avventura potresti trovare degli oggetti utili o persino dei tesori.\n\nUn bravo avventuriero sa come ottenere il massimo da quello che trova,\nquindi ricordati di trascinare gli oggetti che trovi nel tuo inventario!\n\nTocca una volta l'oggetto raccolto per scoprirne gli effetti e trascinalo sul bersaglio quando desidedri usarlo.\n\nLa barra in alto indica la tua sazieta', \nricorda di fare particolare attenzione alle provviste, non vorrai morire di fame!",
textBackground2.x,
textBackground2.y,
customFont,
30)
scrollView:insert(textTutorial2)

local tutorial2Image = display.newImageRect("Images/Utility/tutorial2.png", textBackground.width, textBackground.height)
tutorial2Image.x = textBackground2.x
tutorial2Image.y = textBackground2.y + textBackground2.height + 10
scrollView:insert(tutorial2Image)

local textBackground3 = display.newRect(tutorial2Image.x, tutorial2Image.y + tutorial1Image.height + 10, lunghezza-40, 400)
textBackground3:setFillColor(0.32, 0.36, 0.4)
scrollView:insert(textBackground3)

local textTutorial3 = display.newText(  "Il Danger Dungeon e' un luogo persicoloso e pieno di insidie, tieniti pronto al combattimento!\n\nAppena ti avvicinerai ad un nemico comincera' il duello, \nil piu' veloce colpisce per primo!\n\nQuando e' il tuo turno tocca una volta l'attacco che intendi sferrare e poi tocca il nemico per colpire!\n\nSe sferri un colpo critico l'avversario verra' indebolito,\nma potrebbe succedere anche a te!\n\nSpera di essere tu il piu' veloce, letale e preciso o il Danger Dungeon avra' vinto!",
textBackground3.x,
textBackground3.y,
customFont,
30)
scrollView:insert(textTutorial3)

local tutorial3Image = display.newImageRect("Images/Utility/tutorial3.png", textBackground.width, textBackground.height)
tutorial3Image.x = textBackground3.x
tutorial3Image.y = textBackground3.y + textBackground3.height + 10
scrollView:insert(tutorial3Image)

local textBackground4 = display.newRect(tutorial3Image.x, tutorial3Image.y + tutorial3Image.height + 10, lunghezza-40, 400)
textBackground4:setFillColor(0.32, 0.36, 0.4)
scrollView:insert(textBackground4)

local textTutorial4 = display.newText(  "Ogni nemico sconfitto aumentera' il tuo punteggio da Eroe, \nassicurati quindi di controllare in ogni stanza, non lasciarti sfuggire nessuno!\n\nQuando avrai sconfitto tutti i nemici di un piano proseguirai con il prossimo, \nnessuno sa quanto sono profonde le gallerie del Danger Dungeon, sarai tu a scoprirlo?\n\nRipulisci da ogni nemico piano dopo piano e scolpisci il tuo nome nella classifica degli Eroi,\nil Danger Dungeon ti aspetta!!",
textBackground4.x,
textBackground4.y,
customFont,
30)
scrollView:insert(textTutorial4)

local colore={0.8, 0.58, 0.05}
textTutorial1:setFillColor(colore[1], colore[2], colore[3])
textTutorial2:setFillColor(colore[1], colore[2], colore[3])
textTutorial3:setFillColor(colore[1], colore[2], colore[3])
textTutorial4:setFillColor(colore[1], colore[2], colore[3])
local function handleButtonEvent(event)
  --print("non ended")
  if ( "ended" == event.phase ) then
    --print("cancellato")
    sceneGroup:remove( scrollView )
  end
end

local button = widget.newButton({
  shape = "roundedRect",
  x = background1.x * 0.3,
  y = background1.y * 0.2,
  width=background1.width*0.09,
  height=background1.height * 0.07,
  id = "back",
  label = "BACK",
  labelColor={default={0.5, 0, 0}},
  fontSize=50,
  onEvent = handleButtonEvent,
  font=customFont
})
scrollView:insert(button)
scrollView:setScrollHeight(3000)
sceneGroup:insert(scrollView)
end

local scrollOverlay = {
  handleButton = (handleButtonEventTutorialFunzione)
}

return scrollOverlay
