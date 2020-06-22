
local composer = require("composer")
local interfaccia = require("interfaceConfig")
local customFont="MadnessHyperactive.otf"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--tutto il file lo chiama numero, ma numeroStanze è meglio quindi per non cambiare tutto ho usato sto metodo
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local numeroStanze=8
local numero = numeroStanze
local tabella = interfaccia.tabellaFunction(numero)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--grossa table che contiene le funzioni da trasportare nelle altre classi
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local inventario =
{
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione display che si occupa del display degli oggetti dell'interfaccia bassa
--ci sono delle parti commentate giganti che non mi sentirei di rimuovere. Fanno parte della vecchia costruzione dell'interfaccia prima del commit "implemented nuovo background"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
    lowerOverlay=display.newGroup()
    local altezzaMidBackground=altezza-400
    local lunghezzaMidBackground=lunghezza-510
    local midBackground = display.newRect( display.contentCenterX, display.contentCenterY, lunghezzaMidBackground, altezzaMidBackground )
    midBackground:setFillColor(0.18, 0.18, 0.23)
    midBackGroup:insert(midBackground)

    local spessore = 5
    local lunghezzaInventario=lunghezza-700
    local altezzaInventario=altezza-500

    local handler=interfaccia.dragItem
    interfaccia.displayGrid(inventario, 4, 2, handler)

    local map = display.newRect( display.contentCenterX, display.contentCenterY, lunghezza+1000, altezza+1000 )
    map:setFillColor(0.18, 0.18, 0.23)
    mapGroup:insert(map)
    interfaccia.annullaVisite(mappaGenerata, mappaGenerata)
    interfaccia.displayStanza(mappaGenerata, display.contentCenterX, display.contentCenterY)-- -60, -30
    local overlayBackground = display.newImageRect(lowerOverlay, "Images/Backgrounds/lowerBackground.png", lunghezza, altezza+150)
    overlayBackground.x=display.contentCenterX
    overlayBackground.y=display.contentCenterY-70
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
    sceneGroup:insert(backGroup)
    sceneGroup:insert(overlayGroup)
    sceneGroup:insert(lowerOverlay)
    sceneGroup:insert(inventoryGroup)
end),
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--coppia di valori da costruire: uno è l'inventario e l'altro è la mappa generata
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create={
  inventario={"ITEM", "ITEM", "ITEM", "ITEM", "ITEM"},
  mappaGenerata = interfaccia.proceduraleMappa
  }
}
return inventario
