local composer= require("composer")
local customFont="MadnessHyperactive.otf"
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local math = require("math")
local nemici = require("nemici")
local spawnRatioNemici = 2
local numeroBackgroundTotali = 9
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
  local seed = math.random(1, numeroBackgroundTotali)
  if index>0 then
    x=math.random(1, index)
    a=mappa[x].x
    b=mappa[x].y
  else
    x=1
    a=primaX
    b=primaY
    local spawnNemico = math.random(1, spawnRatioNemici)
    local stringaNemico = "nemico"..spawnNemico
    local nemico = nemici[stringaNemico]

    local stanza={NORD=nil, SUD=nil, EST=nil, OVEST=nil, TESTO=index, visitato=false, corrente=false, seedBackground=seed, x=a, y=b, nemici={nemico}, oggetti={}}
    mappa[x]=stanza
    trovato=true
    tabella[a][b]=true
    index=index+1
  end

  while trovato==false do
    cardinale=math.random(1, 4)
    if (cardinale == 1) and (mappa[x].NORD == nil) and (tabella[a][b+1]==false) then
      mappa[x].seedNORD=seed
      local spawnNemico = math.random(1, spawnRatioNemici)
      local stringaNemico = "nemico"..spawnNemico
      local nemico = nemici[stringaNemico]

      local stanza = {NORD=nil, SUD=mappa[x], EST=nil, OVEST=nil, TESTO=index, visitato=false, corrente=false, seedBackground=seed, x=a, y=b+1, seedSUD=seed, nemici={nemico}, oggetti={}}
      mappa[x].NORD = stanza
      index=index+1
      mappa[index]=stanza
      b=b+1
      tabella[a][b]=true
      trovato=true
    end

    if (cardinale == 2) and (mappa[x].SUD == nil) and (tabella[a][b-1]==false) then
      mappa[x].seedSUD=seed
      local spawnNemico = math.random(1, spawnRatioNemici)
      local stringaNemico = "nemico"..spawnNemico
      local nemico = nemici[stringaNemico]

      local stanza = {NORD=mappa[x], SUD=nil, EST=nil, OVEST=nil, TESTO=index, visitato=false, corrente=false,  seedBackground=seed, x=a, y=b-1, seedNORD=seed, nemici={nemico}, oggetti={}}
      mappa[x].SUD = stanza
      index=index+1
      mappa[index]=stanza
      b=b-1
      tabella[a][b]=true
      trovato=true
    end

    if (cardinale == 3) and (mappa[x].EST == nil) and (tabella[a+1][b]==false) then
      mappa[x].seedEST=seed
      local spawnNemico = math.random(1, spawnRatioNemici)
      local stringaNemico = "nemico"..spawnNemico
      local nemico = nemici[stringaNemico]

      local stanza = {NORD=nil, SUD=nil, EST=nil, OVEST=mappa[x], TESTO=index, visitato=false, corrente=false, seedBackground=seed, x=a+1, y=b, seedOVEST=seed,nemici={nemico}, oggetti={}}
      mappa[x].EST = stanza
      index=index+1
      mappa[index]=stanza
      a=a+1
      tabella[a][b]=true
      trovato=true
    end

    if (cardinale == 4) and (mappa[x].OVEST == nil) and (tabella[a-1][b]==false) then
      mappa[x].seedOVEST=seed
      local spawnNemico = math.random(1, spawnRatioNemici)
      local stringaNemico = "nemico"..spawnNemico
      local nemico = nemici[stringaNemico]

      local stanza = {NORD=nil, SUD=nil, EST=mappa[x], OVEST=nil, TESTO=index, visitato=false, corrente=false, seedBackground=seed, x=a-1, y=b, seedEST=seed, nemici={nemico}, oggetti={}}
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
  (function(inventario, handler, inventoryGroup)
    local index=1
    local partenzax = display.contentCenterX-310
    local partenzay= display.contentCenterY-85
    local griglia = {}

    composer.setVariable( "grigliaOggetti", griglia )
    composer.setVariable("invx", partenzax)
    composer.setVariable("invy", partenzay)

    --Ciclo di creazione delle caselle dell'inventario
    --TABELLA: parte dalle coordinate {partenzaX, partenzaY} (angolo alto a sinistra)
    --         si estende di 500*140
    --CASELLE: ognuna ha dimensioni 100*70
    --         ci sono 5 caselle per riga e 2 righe
    local posizioneX = partenzax    --Posizione dell'angolo in alto a sinistra di ogni casella
    local posizioneY = partenzay
    for x=1, 2, 1 do
      for y=1, 5, 1 do
        local casellaX = posizioneX + 50
        local casellaY = posizioneY + 35
        local griglia = composer.getVariable( "grigliaOggetti" )

        --Ogni casella della griglia è composta dalle coordinate centrali della casella e da un booleano che inidica se la casella è occupata o meno
        griglia[index]={casellaX, casellaY, false, nil}
        composer.setVariable( "grigliaOggetti",  griglia)

        posizioneX = posizioneX + 112
        index=index+1
      end

      posizioneX = partenzax
      posizioneY = posizioneY + 75
    end

    --Ciclo di visualizzazione degli oggetti dell'inventario
    local griglia = composer.getVariable( "grigliaOggetti" )
    for x=1, 10, 1 do
      if(not(inventario[x] == "vuoto")) then
        local item = display.newImageRect( inventoryGroup, inventario[x], 50, 50)
        item.x = griglia[x][1]
        item.y = griglia[x][2]
        item.id = x
        griglia[x][3] = true
        griglia[x][4] = item

        -- print("Visualizzato oggetto: " .. inventario[x] .. " in posizione (" .. griglia[x][1] .. ", " .. griglia[x][2] .. ") della griglia")

        inventoryGroup:insert(item)
        item:addEventListener("touch", handler)
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

    -- print("coordinate mappa: (" .. (display.contentCenterX+150) .. ", " .. (display.contentCenterY+100) .. ")")

    if((event.x > (display.contentCenterX+150) and event.x < (lunghezza-125)) and (event.y > (display.contentCenterY+100) and event.y < (altezza-75))) then
      item.touchOffsetX=event.x-item.x
      item.touchOffsetY=event.y-item.y
    end
  elseif("moved"==phase) then
      -- Muove la nave
    if((event.x > (display.contentCenterX+150) and event.x < (lunghezza-125)) and (event.y > (display.contentCenterY+100) and event.y < (altezza-75))) then
      item.x=event.x-item.touchOffsetX
      item.y=event.y-item.touchOffsetY
    end
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
  local griglia = composer.getVariable( "grigliaOggetti" )
  local inventario = composer.getVariable( "inv" )
  local invx = composer.getVariable( "invx" )
  local invy = composer.getVariable( "invy" )
  local partenza = griglia[idItem]

  if("began"==phase) then
    display.currentStage:setFocus(item)

    -- print("coordinate mappa: (" .. invx .. ", " .. invy .. ")")

    if( not((item.x < invx or item.x > (invx+500)) or (item.y < invy or item.y > (invy+140))) ) then
      item.touchOffsetX=event.x-item.x
      item.touchOffsetY=event.y-item.y
    end
  elseif("moved"==phase) then
      -- Muove la nave
      item.x=event.x-item.touchOffsetX
      item.y=event.y-item.touchOffsetY
  elseif("ended"==phase or "cancelled"==phase) then
    --Oggetto fuori dall'inventario (tentativo di rimozione)
    if( (item.x < invx or item.x > (invx+500)) or (item.y < invy or item.y > (invy+140)) ) then
      display.remove( item )
      inventario[idItem] = "vuoto"
      griglia[idItem][3] = false
      griglia[idItem][4] = nil

      composer.setVariable( "inv", inventario )
      composer.setVariable( "grigliaOggetti", griglia )
    else
      -- VA IMPLEMENTATO L'AUTO POSIZIONAMENTO DEGLI ITEM E LO SCAMBIO DI POSTO
      local xRel = item.x - invx
      local yRel = item.y - invy
      local numCol, restCol = math.modf(xRel/100)
      local numRiga, restRiga = math.modf(yRel/70)
      local numCasella = 0

      numCol = numCol + 1
      numRiga = numRiga + 1

      --Prendo il numero della casella dove si trova l'oggetto
      if(numRiga < 2) then
        numCasella = numCol
      else
        numCasella = numCol + 5
      end

      --Casella uguale a quella di partenza
      if(numCasella == idItem) then
        item.x = partenza[1]
        item.y = partenza[2]
      else
        --Casella diversa
        if(griglia[numCasella][3] == true) then
          --Casella occupata
          griglia[numCasella][4].x = partenza[1]
          griglia[numCasella][4].y = partenza[2]
          griglia[numCasella][4].id = idItem

          item.x = griglia[numCasella][1]
          item.y = griglia[numCasella][2]
          item.id = numCasella

          griglia[idItem][4] = griglia[numCasella][4]
          griglia[numCasella][4] = item

          local altroOggetto = inventario[numCasella]
          inventario[numCasella] = inventario[idItem]
          inventario[idItem] = altroOggetto

          composer.setVariable( "inv", inventario )
          composer.setVariable( "grigliaOggetti", griglia )
        else
          --Casella non occupata
          griglia[idItem][3] = false
          griglia[idItem][4] = nil
          item.x = griglia[numCasella][1]
          item.y = griglia[numCasella][2]
          item.id = numCasella
          griglia[numCasella][3] = true
          griglia[numCasella][4] = item

          inventario[numCasella] = inventario[idItem]
          inventario[idItem] = "vuoto"

          composer.setVariable( "inv", inventario )
          composer.setVariable( "grigliaOggetti", griglia )
        end
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
