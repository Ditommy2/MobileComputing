
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function convertTo2D(input, colonne, righe)
local grid = {}
local index=1
for x=1, colonne, 1 do
  if (index>#input) then
    return grid
  end
    grid[x]={}
  for y=1, righe, 1 do
    grid[x][y]=input[index]
    index=index+1
    if (index>#input) then
      return grid
    end
  end
end
return grid
end


-------------------------------------------------
local function displayStanza(stanza, offx, offy)
  local dimensioniStanza = 20
  local spessoreCorridoio = 5
  local lunghezzaCorridoio = 50
  local coloreStanza={1, 0, 0}
  local coloreCorridoio={1, 0, 0}
local item = display.newRect( offx, offy, dimensioniStanza, dimensioniStanza )
item:setFillColor(coloreStanza[1], coloreStanza[2], coloreStanza[3])
mapGroup:insert(item)
if stanza.NORD~=nil then
  item=display.newRect( offx, offy-10-(lunghezzaCorridoio/2), spessoreCorridoio, lunghezzaCorridoio )
  item:setFillColor(coloreCorridoio[1], coloreCorridoio[2], coloreCorridoio[3])
  mapGroup:insert(item)
  displayStanza(stanza.NORD, offx, (offy-lunghezzaCorridoio-10))
end

if stanza.SUD~=nil then
  item=display.newRect( offx, offy+10+(lunghezzaCorridoio/2), spessoreCorridoio, lunghezzaCorridoio )
  item:setFillColor(1, 0, 0)
  mapGroup:insert(item)
  displayStanza(stanza.SUD, offx, (offy+lunghezzaCorridoio+10))
end

if stanza.EST~=nil then
  item=display.newRect( offx+10+(lunghezzaCorridoio/2), offy, lunghezzaCorridoio, spessoreCorridoio )
  item:setFillColor(1, 0, 0)
  mapGroup:insert(item)
  displayStanza(stanza.EST, offx+lunghezzaCorridoio+10, offy)
end

if stanza.OVEST~=nil then
  item=display.newRect( offx-10-(lunghezzaCorridoio/2), offy, lunghezzaCorridoio, spessoreCorridoio )
  item:setFillColor(1, 0, 0)
  mapGroup:insert(item)
  displayStanza(stanza.OVEST, offx-lunghezzaCorridoio-10, offy)
end
end
--------------------------------------------------------


local function displayGrid(input, colonne, righe)
  local index=1
  local partenzax = display.contentCenterX-150
  local partenzay= display.contentCenterY-90
for x=1, colonne, 1 do
  for y=1, righe, 1 do
    local item = (display.newText( input[index], partenzax+(x*60), partenzay+(y*60),  native.systemFont, 16))
    item:setFillColor(1, 0, 0)
    inventoryGroup:insert(item)
    index=index+1
    if (index > #input) then return
    end
  end
end
end
-----------------------------------------------------------------------------
-- create()
function scene:create( event )

	local sceneGroup = self.view
  inventoryGroup=display.newGroup()
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local background=display.newImageRect(sceneGroup, "nuovaBackground.png", 800, 700)
	background.x=display.contentCenterX
	background.y=display.contentCenterY
	sceneGroup:insert(background)
  local midBackground = display.newRect( display.contentCenterX, display.contentCenterY+95, 568, 130 )
  midBackground:setFillColor(0.18, 0.18, 0.23)
  sceneGroup:insert(midBackground)
  local spessore = 5
  local lunghezza = 240
  local altezza=120
  local invBack = display.newRect( display.contentCenterX, display.contentCenterY, lunghezza, altezza )
  invBack:setFillColor(0.9, 0.9, 0.9)
  inventoryGroup:insert(invBack)
  local column1 = display.newRect( display.contentCenterX-(lunghezza/4), display.contentCenterY, spessore, altezza )
  column1:setFillColor(0.1, 0.1, 0.1)
  inventoryGroup:insert(column1)
  local column2 = display.newRect( display.contentCenterX+(lunghezza/4), display.contentCenterY, spessore, altezza )
  column2:setFillColor(0.1, 0.1, 0.1)
  inventoryGroup:insert(column2)
  local column3 = display.newRect( display.contentCenterX, display.contentCenterY, spessore, altezza )
  column3:setFillColor(0.1, 0.1, 0.1)
  inventoryGroup:insert(column3)
  local row = display.newRect( display.contentCenterX, display.contentCenterY, lunghezza, spessore)
  row:setFillColor(0.1, 0.1, 0.1)
  inventoryGroup:insert(row)

  local stanza3={}
  local stanza2={EST=stanza3}
  local stanza1={SUD=stanza2}

  local inventario={"ITEM", "ITEM", "ITEM", "ITEM"}
  displayGrid(inventario, 4, 2)

  mapGroup=display.newGroup()
  local mapBackground = display.newRect( display.contentCenterX, display.contentCenterY, lunghezza-60, altezza )
  mapBackground:setFillColor(0.9, 0.9, 0.9)
  mapGroup:insert(mapBackground)
  local map = display.newRect( display.contentCenterX, display.contentCenterY, lunghezza-64, altezza-4 )
  map:setFillColor(0.18, 0.18, 0.23)
  mapGroup:insert(map)
  displayStanza(stanza1, display.contentCenterX-60, display.contentCenterY-30)
  mapGroup.x=120
  mapGroup.y=95
  inventoryGroup.x=-120
  inventoryGroup.y=95
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
