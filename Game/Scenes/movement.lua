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
local animationTimer

--Character walking sheet
local sheet_walking_Options =
{
  width=144,
  height=256,
  numFrames=9,
}

--Loading sprite sheet
local sheet_walking = graphics.newImageSheet( "Images/Characters/TrumpPiccolo.png", sheet_walking_Options )

--Character walking sequences table
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

--Layering groups
local backgroundGroup
local midGroup
local inventoryGroup
local mapGroup
local hidingGroup

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
  local background = display.newImageRect( backgroundGroup, "Images/Backgrounds/proceduralBack/Stanze/back5.jpg", width, height*0.7)
  background.x = display.contentCenterX
  background.y = display.contentCenterY - height*0.15
  physics.addBody(background, "static", {shape={ 0, 0, width, 0, width, height - (height*0.3), 0, height - (height*0.3)}})
  background:addEventListener("touch", moveListener)

  --Setting non-movement area
  local area = {minX=width*0.2, minY=0, maxX=width-(width*0.2), maxY=height - (height*0.3)}
  background.nonMovementArea = area

  --Displaying status bar background
  local plainBack = display.newImageRect( midGroup, "Images/Backgrounds/proceduralBack/Stanze/back5.jpg", width, height * 0.3)
  plainBack.anchorX = 0
  plainBack.anchorY = 1
  plainBack.x = 0
  plainBack.y = height

  --Displaying character and setting sprite sheets
  character = display.newSprite( sheet_walking, sequences_walking )
  character:setSequence(rightWalk)
  character:setFrame(1)
  character.anchorY = 1
  character.x = display.contentWidth * 0.1
  character.y = display.contentHeight - plainBack.height

  --Displaying enemy
  enemy = display.newImageRect( midGroup, "Images/Characters/joker.png", width * 0.15, height * 0.2)
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

  --Displaying black bars
  -- hidingGroup =display.newGroup()
  -- sceneGroup:insert(hidingGroup)

  local barLeft = display.newRect(display.screenOriginX, display.screenOriginY, (display.actualContentWidth/2) - (width/2), height)
  local barRight = display.newRect(display.contentCenterX + (width/2), 0, (display.actualContentWidth/2) - (width/2), height)
  barLeft.anchorX = 0
  barLeft.anchorY = 0
  barRight.anchorX = 0
  barRight.anchorY = 0

  barLeft:setFillColor(0,0,0)
  barRight:setFillColor(0,0,0)
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
