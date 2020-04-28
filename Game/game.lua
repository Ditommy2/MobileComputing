local composer = require("composer")
local scene = composer.newScene()

--Physics
local physics = require("physics")
physics.start()

--Game window (16:9 aspect ratio)
local width = display.contentWidth
local height = display.contentWidth * (9/16)

--Game objects
local character
local enemy
local inventory
local map
local moveTimer

--Layering groups
local backgroundGroup
local midGroup
local inventoryGroup
local mapGroup

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

    --Touch in the movement area
    if((event.x < target.nonMovementArea.minX) and (event.y < target.nonMovementArea.maxY)) then
      dir = "l"
    elseif((event.x > target.nonMovementArea.maxX) and (event.y < target.nonMovementArea.maxY)) then
      dir = "r"
    end

    --Start movement
    moveTimer = timer.performWithDelay( 30, move, 0)
    moveTimer.params = {direction=dir}
  elseif(phase=="moved") then   --Touch moved
    --Touch falls in the non-movement area
    if((event.x > target.nonMovementArea.minX and event.x < target.nonMovementArea.maxX) or (event.y > target.nonMovementArea.maxY)) then
      --Pause movement
      timer.pause(moveTimer)
    else  --Touch back in the movement area
      --Eventually modifying movement direction
      if((event.x < target.nonMovementArea.minX) and (event.y < target.nonMovementArea.maxY)) then
        moveTimer.params.direction = "l"
      elseif((event.x > target.nonMovementArea.maxX) and (event.y < target.nonMovementArea.maxY)) then
        moveTimer.params.direction = "r"
      end

      --Resuming movement
      timer.resume( moveTimer )
    end
  elseif (phase=="ended" or phase=="cancelled") then
    --Ending movement and canceling focus
    display.getCurrentStage():setFocus(nil)
    timer.cancel( moveTimer )
  end

  return true
end

--create
function scene:create(event)
  local sceneGroup = self.view

  --Creating layering groups
  backgroundGroup = display.newGroup()
  sceneGroup:insert(backgroundGroup)

  midGroup = display.newGroup()
  sceneGroup:insert(midGroup)

  inventoryGroup = display.newGroup()
  sceneGroup:insert(inventoryGroup)

  mapGroup = display.newGroup()
  sceneGroup:insert(mapGroup)

  --Displaying background and adding movement listener
  local background = display.newImageRect( backgroundGroup, "background.png", width, height)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  physics.addBody(background, "static", {shape={ 0, 0, width, 0, width, height - (height*0.3), 0, height - (height*0.3)}})
  background:addEventListener("touch", moveListener)

  --Setting non-movement area
  local area = {minX=width*0.2, minY=0, maxX=width-(width*0.2), maxY=height - (height*0.3)}
  background.nonMovementArea = area

  --Displaying status bar background
  local plainBack = display.newImageRect( midGroup, "plainBack.png", width, height * 0.3)
  plainBack.anchorX = 0
  plainBack.anchorY = 1
  plainBack.x = 0
  plainBack.y = height

  --Displaying character
  character = display.newImageRect( midGroup, "deadpool.png", width * 0.15, height * 0.2)
  character.anchorY = 1
  character.x = display.contentWidth * 0.1
  character.y = display.contentHeight - plainBack.height

  --Displaying enemy
  enemy = display.newImageRect( midGroup, "joker.png", width * 0.15, height * 0.2)
  enemy.anchorY = 1
  enemy.x = width - (width * 0.1)
  enemy.y = height - plainBack.height

  --Displaying inventory
  inventory = display.newRect( 0, 0, width * 0.3, plainBack.height - (plainBack.height * 0.1) )
  inventory.anchorX = 0
  inventory.anchorY = 1
  inventory.x = width * 0.01
  inventory.y = height- (plainBack.height * 0.05)

  --Displaying map
  map = display.newRect( 0, 0,  width * 0.3,  plainBack.height - (plainBack.height * 0.1))
  map.anchorX = 1
  map.anchorY = 1
  map.x = width - (width * 0.01)
  map.y = height - (plainBack.height * 0.05)
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

	end
end

-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
