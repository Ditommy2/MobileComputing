
local composer = require("composer")
local interfaccia = require("interfaceConfig")
local numero = 7
local tabella = interfaccia.tabellaFunction(numero)

local inventario =
{
  display=
  (function (self, mappaGenerata, inventario)
    local lunghezza =  display.contentWidth
    local altezza=  lunghezza*(9/16)
  local sceneGroup = self.view
  inventoryGroup=display.newGroup()
  mapGroup=display.newGroup()
  backGroup=display.newGroup()
  overlayGroup=display.newGroup()
  midBackGroup=display.newGroup()
  local altezzaMidBackground=altezza-400
  local lunghezzaMidBackground=lunghezza-510
  local midBackground = display.newRect( display.contentCenterX, display.contentCenterY, lunghezzaMidBackground, altezzaMidBackground )
  midBackground:setFillColor(0.18, 0.18, 0.23)
  midBackGroup:insert(midBackground)
  print(display.contentWidth, " altezza display")
  local spessore = 5
   local lunghezzaInventario=lunghezza-700
   local altezzaInventario=altezza-500
   local invBack = display.newRect( display.contentCenterX, display.contentCenterY, lunghezzaInventario, altezzaInventario )
   invBack:setFillColor(0.9, 0.9, 0.9)
   inventoryGroup:insert(invBack)
   local column1 = display.newRect( display.contentCenterX-((lunghezzaInventario)/4), display.contentCenterY, spessore, altezzaInventario )
   column1:setFillColor(0.1, 0.1, 0.1)
   inventoryGroup:insert(column1)
   local column2 = display.newRect( display.contentCenterX+((lunghezzaInventario)/4), display.contentCenterY, spessore, altezzaInventario )
   column2:setFillColor(0.1, 0.1, 0.1)
   inventoryGroup:insert(column2)
   local column3 = display.newRect( display.contentCenterX, display.contentCenterY, spessore, altezzaInventario )
   column3:setFillColor(0.1, 0.1, 0.1)
   inventoryGroup:insert(column3)
   local row = display.newRect( display.contentCenterX, display.contentCenterY, lunghezzaInventario, spessore)
   row:setFillColor(0.1, 0.1, 0.1)
   inventoryGroup:insert(row)

   local handler=interfaccia.dragItem
   interfaccia.displayGrid(inventario, 4, 2, handler)
   local lunghezzaMapBackground=lunghezza-800
   local altezzaMapBackground=lunghezzaMapBackground*(9/16)
   local mapBackground1 = display.newRect( display.contentCenterX, display.contentCenterY+(altezzaMapBackground/2), lunghezzaMapBackground, 5 )
   mapBackground1:setFillColor(0.9, 0.9, 0.9)
   overlayGroup:insert(mapBackground1)
--
   local mapBackground2 = display.newRect( display.contentCenterX, display.contentCenterY-(altezzaMapBackground/2), lunghezzaMapBackground, 5 )
   mapBackground2:setFillColor(0.9, 0.9, 0.9)
   overlayGroup:insert(mapBackground2)

   local mapBackground3 = display.newRect( display.contentCenterX+(lunghezzaMapBackground/2), display.contentCenterY, 5, altezzaMapBackground+5 )
   mapBackground3:setFillColor(0.9, 0.9, 0.9)
   overlayGroup:insert(mapBackground3)
--
   local mapBackground4 = display.newRect( display.contentCenterX-(lunghezzaMapBackground/2), display.contentCenterY, 5, altezzaMapBackground+5 )
   mapBackground4:setFillColor(0.9, 0.9, 0.9)
   overlayGroup:insert(mapBackground4)
-- ---------------------------------------------------------------------------------------------------------------------------
   local mapBackground5 = display.newRect( display.contentCenterX+270, display.contentCenterY, 53, altezzaMidBackground )
   mapBackground5:setFillColor(0.18, 0.18, 0.23) --0.18
   overlayGroup:insert(mapBackground5)
--
   local mapBackground6 = display.newRect( display.contentCenterX-270, display.contentCenterY, 47, altezzaMidBackground )
   mapBackground6:setFillColor(0.18, 0.18, 0.23)
   overlayGroup:insert(mapBackground6)
--
   local mapBackground7 = display.newRect( display.contentCenterX, display.contentCenterY-149, lunghezzaMapBackground+20, 23 )
   mapBackground7:setFillColor(0.18, 0.18, 0.23)
   overlayGroup:insert(mapBackground7)
--
   local mapBackground8 = display.newRect( display.contentCenterX, display.contentCenterY+149, lunghezzaMapBackground+20, 22 )
   mapBackground8:setFillColor(0.18, 0.18, 0.23)
   overlayGroup:insert(mapBackground8)
--
--
   local map = display.newRect( display.contentCenterX, display.contentCenterY, lunghezza+1000, altezza+1000 )
   map:setFillColor(0.18, 0.18, 0.23)
   mapGroup:insert(map)
   interfaccia.annullaVisite(mappaGenerata, mappaGenerata)
   interfaccia.displayStanza(mappaGenerata, display.contentCenterX, display.contentCenterY)-- -60, -30
   mapGroup.x=composer.getVariable( "mapx" )
   mapGroup.y=composer.getVariable( "mapy" )
   overlayGroup.x=352
   overlayGroup.y=200
   inventoryGroup.x=-250
   inventoryGroup.y=200
   midBackGroup.x=inventoryGroup.x-20
   midBackGroup.y=inventoryGroup.y
   mapGroup:addEventListener("touch", interfaccia.dragMapSet)

  sceneGroup:insert(mapGroup)
  sceneGroup:insert(midBackGroup)
  -----stacca----------------------

  sceneGroup:insert(backGroup)
  sceneGroup:insert(inventoryGroup)
  sceneGroup:insert(overlayGroup)
end),
create={inventario={"ITEM", "ITEM", "ITEM", "ITEM", "ITEM", "ITEM"}, mappaGenerata = interfaccia.proceduraleMappa(0, {}, numero, tabella, numero+1, numero+1)}
}
return inventario
