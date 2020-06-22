local composer= require("composer")
local customFont="MadnessHyperactive.otf"
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- classe che si occupa di fornire tutte le funzioni tecniche per generare e costruire l'interfaccia bassa del gioco
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione che genera una mappa procedurale a partire da un numero di stanze desiderato. Per farlo costruisce una tabella con una stanza, la quale è a sua volta una tabella
--con le varie direzioni NORD SUD EST OVEST alle quali sono associate altre stanze. Per gestire la mappa ed evitare l'appallottolarsi di stanze usa una tabella x, y che mano
--mano viene riempita di token per segnare che la stanza è stata creata
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function proceduraleMappaFunzione(index, mappa, numero, tabella, primaX, primaY)
  local x
  local a, b
  local cardinale
  local trovato = false
  local seed = math.random(1, 5)
  if index>0 then
    x=math.random(1, index)
    a=mappa[x].x
    b=mappa[x].y
  else
    x=1
    a=primaX
    b=primaY
    local stanza={NORD=nil, SUD=nil, EST=nil, OVEST=nil, TESTO=index, visitato=false, corrente=false, seedBackground=seed, x=a, y=b}
    mappa[x]=stanza
    trovato=true
    tabella[a][b]=true
    index=index+1
  end

  while trovato==false do
    cardinale=math.random(1, 4)
    if (cardinale == 1) and (mappa[x].NORD == nil) and (tabella[a][b+1]==false) then
      mappa[x].seedNORD=seed
      local stanza = {NORD=nil, SUD=mappa[x], EST=nil, OVEST=nil, TESTO=index, visitato=false, corrente=false, seedBackground=seed, x=a, y=b+1, seedSUD=seed}
      mappa[x].NORD = stanza
      index=index+1
      mappa[index]=stanza
      b=b+1
      tabella[a][b]=true
      trovato=true
    end

    if (cardinale == 2) and (mappa[x].SUD == nil) and (tabella[a][b-1]==false) then
      mappa[x].seedSUD=seed
      local stanza = {NORD=mappa[x], SUD=nil, EST=nil, OVEST=nil, TESTO=index, visitato=false, corrente=false,  seedBackground=seed, x=a, y=b-1, seedNORD=seed}
      mappa[x].SUD = stanza
      index=index+1
      mappa[index]=stanza
      b=b-1
      tabella[a][b]=true
      trovato=true
    end

    if (cardinale == 3) and (mappa[x].EST == nil) and (tabella[a+1][b]==false) then
      mappa[x].seedEST=seed
      local stanza = {NORD=nil, SUD=nil, EST=nil, OVEST=mappa[x], TESTO=index, visitato=false, corrente=false, seedBackground=seed, x=a+1, y=b, seedOVEST=seed}
      mappa[x].EST = stanza
      index=index+1
      mappa[index]=stanza
      a=a+1
      tabella[a][b]=true
      trovato=true
    end

    if (cardinale == 4) and (mappa[x].OVEST == nil) and (tabella[a-1][b]==false) then
      mappa[x].seedOVEST=seed
      local stanza = {NORD=nil, SUD=nil, EST=mappa[x], OVEST=nil, TESTO=index, visitato=false, corrente=false, seedBackground=seed, x=a-1, y=b, seedEST=seed}
      mappa[x].OVEST = stanza
      index=index+1
      mappa[index]=stanza
      a=a-1
      tabella[a][b]=true
      trovato=true
    end
  end
  if index==numero then
    return mappa[1]
  end

  return proceduraleMappaFunzione(index, mappa, numero, tabella, primaX, primaY)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione di supporto che annulla l'attributo "visitato" delle stanze, che deve rimanere flase, ma che è impostato a true per via della creazione ricorsiva della mappa
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function annullaVisitefunzione(primaStanza, stanza)
  stanza.visitato=false
  if stanza.NORD~=nil and stanza.NORD.visitato==true then
    annullaVisitefunzione(primaStanza, stanza.NORD)
  end
  if stanza.SUD~=nil and stanza.SUD.visitato==true then
    annullaVisitefunzione(primaStanza, stanza.SUD)
  end
  if stanza.EST~=nil and stanza.EST.visitato==true then
    annullaVisitefunzione(primaStanza, stanza.EST)
  end
  if stanza.OVEST~=nil and stanza.OVEST.visitato==true then
    annullaVisitefunzione(primaStanza, stanza.OVEST)
  end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione ricorsova che si occupa di fare il display della mappa stanza dopo stanza. Parte infatti dallla stanza attuale e mano mano si porta l'offset x e y per stampare le stanze in posizione corretta
--crea anche il corridoio tra una stanza e l'altra
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function displayStanzaFunzione(stanza, offx, offy)
  local dimensioniStanza = 50
  local spessoreCorridoio = 10
  local lunghezzaCorridoio = 100
  local coloreCorrente = {0, 1, 1}
  local coloreStanza={1, 0, 0}
  local coloreCorridoio={1, 0, 0}
  local item = display.newRect( offx, offy, dimensioniStanza, dimensioniStanza )
  item:setFillColor(coloreStanza[1], coloreStanza[2], coloreStanza[3])

  if(stanza.corrente==true) then
    item:setFillColor(coloreCorrente[1], coloreCorrente[2], coloreCorrente[3])
  end
  mapGroup:insert(item)

  if stanza.NORD~=nil and stanza.NORD.visitato~=true then
    item=display.newRect( offx, offy-(dimensioniStanza/2)-(lunghezzaCorridoio/2), spessoreCorridoio, lunghezzaCorridoio )
    item:setFillColor(coloreCorridoio[1], coloreCorridoio[2], coloreCorridoio[3])
    mapGroup:insert(item)
    stanza.NORD.visitato=true
    displayStanzaFunzione(stanza.NORD, offx, (offy-lunghezzaCorridoio-(dimensioniStanza/2)))
  end

  if stanza.SUD~=nil and stanza.SUD.visitato~=true then
    item=display.newRect( offx, offy+(dimensioniStanza/2)+(lunghezzaCorridoio/2), spessoreCorridoio, lunghezzaCorridoio )
    item:setFillColor(1, 0, 0)
    mapGroup:insert(item)
    stanza.SUD.visitato=true
    displayStanzaFunzione(stanza.SUD, offx, (offy+lunghezzaCorridoio+(dimensioniStanza/2)))
  end

  if stanza.EST~=nil and stanza.EST.visitato~=true then
    item=display.newRect( offx+(dimensioniStanza/2)+(lunghezzaCorridoio/2), offy, lunghezzaCorridoio, spessoreCorridoio )
    item:setFillColor(1, 0, 0)
    mapGroup:insert(item)
    stanza.EST.visitato=true
    displayStanzaFunzione(stanza.EST, offx+lunghezzaCorridoio+(dimensioniStanza/2), offy)
  end

  if stanza.OVEST~=nil and stanza.OVEST.visitato~=true then
    item=display.newRect( offx-(dimensioniStanza/2)-(lunghezzaCorridoio/2), offy, lunghezzaCorridoio, spessoreCorridoio )
    item:setFillColor(1, 0, 0)
    mapGroup:insert(item)
    stanza.OVEST.visitato=true
    displayStanzaFunzione(stanza.OVEST, offx-lunghezzaCorridoio-(dimensioniStanza/2), offy)
  end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--questa è una tabella che contiene delle funzioni
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local interfacciaConfig = {
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--la prima funzione, displayGrid, si occupa di stampare gli oggetti dell'inventario in ordine di righe e colonne in modo da poter rimanere nella griglia dell'inventario
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  displayGrid=
  (function(input, colonne, righe, handler)
    local index=1
    local partenzax = display.contentCenterX-370
    local partenzay= display.contentCenterY-150
    for x=1, colonne, 1 do
      for y=1, righe, 1 do
        local positioningX = partenzax+(x*150)
        local positioningY = partenzay+(y*100)
        local tabella = composer.getVariable( "tabellaOgegttiInventario" )
        tabella[index]={positioningX, positioningY}
        composer.setVariable( "tabellaOggettiInventario",  tabella)
        -- local item = (display.newText( input[index], positioningX, positioningY,  native.systemFont, 30))
        local item = display.newImageRect( inventoryGroup, input[index], 50, 50)
        item.x = positioningX
        item.y = positioningY
        item.id=index
        -- item:setFillColor(1, 0, 0)
        item:addEventListener("touch", handler)
        -- inventoryGroup:insert(item)
        index=index+1
        if (index > #input) then
          return
        end
      end
    end
  end),
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--questa funzione si riferisce a quella sopra e qui può essere usata da funzioni esterne. Si deve fare così per via della ricorsività
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  proceduraleMappa=
  (proceduraleMappaFunzione),
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--come sopra
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  displayStanza=
  (displayStanzaFunzione),
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--come sopra
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  annullaVisite=
  (annullaVisitefunzione),
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione di handle per il movimento della mappa. è importante perchè comunica al composer l'ultima posizione della mappa dato che quando si cambia da una stanza
--all'altra la mappa non deve teletrasportarsi
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dragMapSet=
(function(event)
  local item=event.target
  local phase=event.phase
  if("began"==phase) then
      display.currentStage:setFocus(item)
      item.touchOffsetX=event.x-item.x
      item.touchOffsetY=event.y-item.y
    elseif("moved"==phase) then
      -- Muove la nave
      item.x=event.x-item.touchOffsetX
      item.y=event.y-item.touchOffsetY
   elseif("ended"==phase or "cancelled"==phase) then
     --rilascio del tocco
     composer.setVariable( "mapx", item.x )
     composer.setVariable( "mapy", item.y )
     display.currentStage:setFocus(nil)
    end
    return true
end),
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione per l'handle del movimento degli oggetti dell'inventario. è da rivedere dato che ancora non controlla perfettamente l'agancio degli oggetti nelle posizioni
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
dragItem=
(function(event)
  local item=event.target
  local phase=event.phase
  local idItem = item.id
  local tabella = composer.getVariable( "tabellaOgegttiInventario" )
  local partenza = tabella[idItem]
  if("began"==phase) then
      display.currentStage:setFocus(item)
      item.touchOffsetX=event.x-item.x
      item.touchOffsetY=event.y-item.y
    elseif("moved"==phase) then
      -- Muove la nave
      item.x=event.x-item.touchOffsetX
      item.y=event.y-item.touchOffsetY
    elseif("ended"==phase or "cancelled"==phase) then
     --rilascio del tocco
      local bordoXSUP=partenza[1]+70
      local bordoXINF=partenza[1]-70
      local bordoYSUP=partenza[2]+70
      local bordoYINF=partenza[2]-70

      if(item.x<bordoXSUP and item.x>bordoXINF) then
       if(item.y<bordoYSUP and item.y>bordoYINF) then
         item.y=partenza[2]
         item.x=partenza[1]
       end

      end
      display.currentStage:setFocus(nil)
    end
    return true
end),
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione che costruisce la tabella di token per la mappa
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
tabellaFunction=
(function (n)
  local tabella={}
  local numero = (2*n)+1
  for i=1, numero, 1 do
    tabella[i]={}
    for j=1, numero, 1 do
      tabella[i][j]=false
    end
  end
  return tabella
end),
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--numero di stanze
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
numeroStanze=8
}
return interfacciaConfig
