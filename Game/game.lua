local composer = require("composer")
local scene = composer.newScene()

--Layering groups
local backgroundGroup
local midGroup
local inventoryGroup
local mapGroup

--create
function scene:create(event)
  local sceneGroup = self.view

  backgroundGroup = display.newGroup()
  sceneGroup:insert(backgroundGroup)

  midGroup = display.newGroup()
  sceneGroup:insert(midGroup)

  inventoryGroup = display.newGroup()
  sceneGroup:insert(inventoryGroup)

  mapGroup = display.newGroup()
  sceneGroup:insert(mapGroup)

  local background = display.newImageRect( backgroundGroup, "background.png", display.contentWidth, display.contentWidth * (9/16))
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local plainBack = display.newImageRect( midGroup, "plainBack.png", background.width, background.height * 0.3)
  plainBack.anchorX = 0
  plainBack.anchorY = 1
  plainBack.x = 0
  plainBack.y = display.contentHeight

  local character = display.newImageRect( midGroup, "deadpool.png", background.width * 0.15, (background.width * 0.15) * (9/16))
  character.anchorY = 1
  character.x = display.contentWidth * 0.1
  character.y = display.contentHeight - plainBack.height

  local enemy = display.newImageRect( midGroup, "joker.png", background.width * 0.15, (background.width * 0.15) * (9/16))
  enemy.anchorY = 1
  enemy.x = display.contentWidth - (display.contentWidth * 0.1)
  enemy.y = display.contentHeight - plainBack.height

  local inventory = display.newRect( 0, 0, background.width * 0.3, plainBack.height - (plainBack.height * 0.1) )
  inventory.anchorX = 0
  inventory.anchorY = 1
  inventory.x = display.contentWidth * 0.01
  inventory.y = plainBack.y - (plainBack.height * 0.05)

  local map = display.newRect( 0, 0,  background.width * 0.3,  plainBack.height - (plainBack.height * 0.1))
  map.anchorX = 1
  map.anchorY = 1
  map.x = display.contentWidth - (display.contentWidth * 0.01)
  map.y = plainBack.y - (plainBack.height * 0.05)
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
