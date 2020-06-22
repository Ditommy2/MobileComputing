local function handleButtonEventTutorialFunzione(display, lunghezza, altezza)
  local widget = require( "widget" )

  -- ScrollView listener
  local function scrollListener( event )

      local phase = event.phase
      if ( phase == "began" ) then print( "Scroll view was touched" )
      elseif ( phase == "moved" ) then print( "Scroll view was moved" )
      elseif ( phase == "ended" ) then print( "Scroll view was released" )
      end

      -- In the event a scroll limit is reached...
      if ( event.limitReached ) then
          if ( event.direction == "up" ) then print( "Reached bottom limit" )
          elseif ( event.direction == "down" ) then print( "Reached top limit" )
          elseif ( event.direction == "left" ) then print( "Reached right limit" )
          elseif ( event.direction == "right" ) then print( "Reached left limit" )
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
  scrollView:setScrollHeight(1500)
end

local scrollOverlay = {
  handleButton = (handleButtonEventTutorialFunzione)
}

return scrollOverlay
