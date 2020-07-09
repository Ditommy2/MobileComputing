local customFont="MadnessHyperactive.otf"
local composer = require( "composer" )
local fileHandler = require "fileHandler"
local rowText = ""
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

  -------------------------------------------------------------------------------------------------------------------------------------------
  -- Visualizzazione dell'elenco dei punteggi
  -------------------------------------------------------------------------------------------------------------------------------------------
  local function sortPunteggi(a, b)
    return a.punteggio > b.punteggio
  end

  local stringaScores = "saveScore".."$$"..".json"
  local tabellonePunteggi= fileHandler.loadTableScores(stringaScores)
  table.sort(tabellonePunteggi, sortPunteggi)

  local screenW, screenH, halfW, halfH = lunghezza, display.viewableContentHeight, lunghezza*0.5, display.viewableContentHeight*0.5

  local punteggiText = display.newText({text="PUNTEGGI", x=125, y=180, width=200, height=70, font=customFont, fontSize=60})
  local posText = display.newText({text="POS", x=125, y=250, width=200, height=70, font=customFont, fontSize=60})
  local scoreText = display.newText({text="SCORE", x=320, y=250, width=200, height=70, font=customFont, fontSize=60})
  local playerText = display.newText({text="PLAYER", x=520, y=250, width=200, height=70, font=customFont, fontSize=60})
  local gameText = display.newText({text="GAME", x=720, y=250, width=200, height=70, font=customFont, fontSize=60})

  scrollView:insert(punteggiText)
  scrollView:insert(posText)
  scrollView:insert(scoreText)
  scrollView:insert(playerText)
  scrollView:insert(gameText)

  -- Grid
  numberOfColumns = 4
  columnWidth = 200--math.floor( screenW / numberOfColumns )

  function getColumnPosition( columnNumber )
  	return 25 + ((columnNumber - 1) * columnWidth)
  end

  function getColumnWidth( numberOfColumns )
  	return numberOfColumns * columnWidth
  end

  -- Loop columns
  for i = 1, numberOfColumns do
  	-- Loop thru records
  	for y = 1, #tabellonePunteggi do
  		-- Set column and row
  		local column = i
  		local row = (y * 50 - 50) + 300

  		-- Set text of label
      if i == 1 then
  			text = y
  		end

  		if i == 2 then
  			text = tabellonePunteggi[y].punteggio
  		end

      if i == 3 then
  			text = tabellonePunteggi[y].utente
  		end

      if i == 4 then
  			text = tabellonePunteggi[y].partita
  		end

  		-- Add newText
  		local options =
  		{
  			text = text,
  			x = getColumnPosition(column),
  			y = row,
  			width = getColumnWidth(column+1),
        font = customFont,
  			fontSize = 40,
  			align = "left"
  		}
  		local label1 = display.newText( options )
  		label1.anchorX = 0
  		label1.anchorY = 0

      scrollView:insert(label1)
  	end
  end

  local function handleButtonEvent(event)
    print("non ended")
    if ( "ended" == event.phase ) then
      print("cancellato")
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
    scrollView:setScrollHeight(1500)
    sceneGroup:insert(scrollView)
  end

  local scrollOverlay = {
    handleButton = (handleButtonEventTutorialFunzione)
  }

return scrollOverlay
