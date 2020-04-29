
local composer = require("composer")
local interfaccia = require("interfaceConfig")
local inventario =
{
  display=
  (function (self, mappaGenerata, inventario)
  local sceneGroup = self.view
  inventoryGroup=display.newGroup()
  mapGroup=display.newGroup()
  backGroup=display.newGroup()
  overlayGroup=display.newGroup()
  midBackGroup=display.newGroup()

  local midBackground = display.newRect( display.contentCenterX-136, display.contentCenterY+95, 300, 130 )
  midBackground:setFillColor(0.18, 0.18, 0.23)
  midBackGroup:insert(midBackground)

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

  local handler=interfaccia.dragItem
  interfaccia.displayGrid(inventario, 4, 2, handler)


  local mapBackground1 = display.newRect( display.contentCenterX, display.contentCenterY-55, lunghezza-60, 5 )
  mapBackground1:setFillColor(0.9, 0.9, 0.9)
  overlayGroup:insert(mapBackground1)

  local mapBackground2 = display.newRect( display.contentCenterX, display.contentCenterY+55, lunghezza-60, 5 )
  mapBackground2:setFillColor(0.9, 0.9, 0.9)
  overlayGroup:insert(mapBackground2)

  local mapBackground3 = display.newRect( display.contentCenterX+90, display.contentCenterY, 5, altezza-5 )
  mapBackground3:setFillColor(0.9, 0.9, 0.9)
  overlayGroup:insert(mapBackground3)

  local mapBackground4 = display.newRect( display.contentCenterX-90, display.contentCenterY, 5, altezza-5 )
  mapBackground4:setFillColor(0.9, 0.9, 0.9)
  overlayGroup:insert(mapBackground4)
---------------------------------------------------------------------------------------------------------------------------
  local mapBackground5 = display.newRect( display.contentCenterX+118, display.contentCenterY, 53, altezza+11 )
  mapBackground5:setFillColor(0.18, 0.18, 0.23)
  overlayGroup:insert(mapBackground5)

  local mapBackground6 = display.newRect( display.contentCenterX-116, display.contentCenterY, 47, altezza+11 )
  mapBackground6:setFillColor(0.18, 0.18, 0.23)
  overlayGroup:insert(mapBackground6)

  local mapBackground7 = display.newRect( display.contentCenterX, display.contentCenterY-61, lunghezza-55, 8 )
  mapBackground7:setFillColor(0.18, 0.18, 0.23)
  overlayGroup:insert(mapBackground7)

  local mapBackground8 = display.newRect( display.contentCenterX, display.contentCenterY+61, lunghezza-55, 8 )
  mapBackground8:setFillColor(0.18, 0.18, 0.23)
  overlayGroup:insert(mapBackground8)


  local map = display.newRect( display.contentCenterX, display.contentCenterY, 800, 700 )
  map:setFillColor(0.18, 0.18, 0.23)
  mapGroup:insert(map)
  interfaccia.annullaVisite(mappaGenerata, mappaGenerata)
  interfaccia.displayStanza(mappaGenerata, display.contentCenterX, display.contentCenterY)-- -60, -30
  mapGroup.x=composer.getVariable( "mapx" )
  mapGroup.y=composer.getVariable( "mapy" )
  overlayGroup.x=140
  overlayGroup.y=95
  inventoryGroup.x=-120
  inventoryGroup.y=95
  mapGroup:addEventListener("touch", interfaccia.dragMapSet)

  sceneGroup:insert(mapGroup)
  sceneGroup:insert(midBackGroup)
  -----stacca----------------------

  sceneGroup:insert(backGroup)
  sceneGroup:insert(inventoryGroup)
  sceneGroup:insert(overlayGroup)
end),
create={inventario={"ITEM", "ITEM", "ITEM", "ITEM"}, mappaGenerata = interfaccia.proceduraleMappa(0, {}, 7)}
}
return inventario
