local customFont="MadnessHyperactive.otf"
local composer = require( "composer" )
local fileHandler = require "fileHandler"
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
  local textBackground = display.newRect(background1.x, background1.y, lunghezza-40, 400)
  textBackground:setFillColor(0.32, 0.36, 0.4)
  scrollView:insert(textBackground)

  local stringaScores = "saveScore".."$$"..".json"
  local tabellonePunteggi= fileHandler.loadTableScores(stringaScores)

  local titleScore = display.newText(  "SCORES\n\nPunteggio               Giocatore               Partita\n",
    textBackground.x,
    textBackground.y,
    customFont,
    30)

  if(not(tabellonePunteggi==nil)) then
    for i=1, #tabellonePunteggi, 1 do
      titleScore.text = titleScore.text .. tabellonePunteggi[i]
    end
  end

  scrollView:insert(titleScore)
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
