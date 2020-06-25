
local composer = require("composer")
local interfaccia = require("interfaceConfig")
local customFont="MadnessHyperactive.otf"
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
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
    local sceneGroup = self.view

    mapGroup=display.newGroup()         --Ne fa parte la mappa
    backGroup=display.newGroup()        --Ne fa parte il background
    lowerOverlay=display.newGroup()     --Ne fa parte il background dell'inventario
    inventoryGroup=display.newGroup()   --Ne fanno parte gli oggetti dell'inventario

    local handler=interfaccia.dragItem                    --Handler del movimento degli oggeti
    interfaccia.displayGrid(inventario,handler, inventoryGroup)    --Crea la tabella degli ogetti

    --Creazionde della mappa
    local map = display.newRect( display.contentCenterX, display.contentCenterY, lunghezza+1000, altezza+1000 )
    map:setFillColor(0.18, 0.18, 0.23)
    mapGroup:insert(map)
    interfaccia.annullaVisite(mappaGenerata, mappaGenerata)
    interfaccia.displayStanza(mappaGenerata, display.contentCenterX, display.contentCenterY)-- -60, -30

    --Creazione del background dell'inventario
    local overlayBackground = display.newImageRect(lowerOverlay, "Images/Backgrounds/lowerBackground.png", lunghezza, altezza+150)
    overlayBackground.x=display.contentCenterX
    overlayBackground.y=display.contentCenterY-70

    --Posizionamento di mappa e inventario
    mapGroup.x=composer.getVariable( "mapx" )
    mapGroup.y=composer.getVariable( "mapy" )
    inventoryGroup.x=-250
    inventoryGroup.y=200

    --Listener per il drag della mappa
    mapGroup:addEventListener("touch", interfaccia.dragMapSet)

    sceneGroup:insert(mapGroup)
    sceneGroup:insert(backGroup)
    sceneGroup:insert(lowerOverlay)
    sceneGroup:insert(inventoryGroup)
  end),
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--coppia di valori da costruire: uno è l'inventario e l'altro è la mappa generata
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create={
  inventario={"Images/Objects/lifePotion.png", "Images/Objects/armorPotion.png", "Images/Objects/attackPotion.png", "Images/Objects/key.png", "Images/Objects/shovel.png", "vuoto", "vuoto", "vuoto", "vuoto", "vuoto"},
  mappaGenerata = interfaccia.proceduraleMappa
  }
}
return inventario
