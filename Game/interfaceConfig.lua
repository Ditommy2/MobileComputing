local composer= require("composer")
local customFont="MadnessHyperactive.otf"
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
local math = require("math")
local nemici = require("nemici")
local curios = require("curios")
local spawnRatioNemiciUpper = 27  --circa il 70% di spawn rate
local spawnRatioNemiciLower = 1
local spawnRatioCurioLower = 3
local spawnRatioCurioUpper = 4
local numeroBackgroundTotali = 9
local token
--Physics (necessaria per il movimento del personaggio)
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- classe che si occupa di fornire tutte le funzioni tecniche per generare e costruire l'interfaccia bassa del gioco
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- funzione che displeya la desc dell'oggetto nell'inventario
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function viewDesc(event)
  local item = event.target
  local desc = display.newText(inventoryGroup, item.description , item.x, item.y - 60, native.newFont( customFont), 40)
  transition.to( desc , { time=2000, alpha=0 } )
end
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
    local spawnNemico = math.random(spawnRatioNemiciLower, spawnRatioNemiciUpper)
    local spawnCurio = math.random(spawnRatioCurioLower, spawnRatioCurioUpper)
    local stringaNemico = "nemico"..spawnNemico
    local stringaCurio = "curio"..spawnCurio
    local nemico = nemici[stringaNemico]

    if(nemico==nil) then
      local stanza={
        NORD=nil,
        SUD=nil,
        EST=nil,
        OVEST=nil,
        TESTO=index,
        visitato=false,
        corrente=false,
        seedBackground=seed,
        x=a,
        y=b,
        nemici={nemico},
        curios = {stringaCurio},
        oggetti={},
        corridoioCorrente=nil
      }
      mappa[x]=stanza
      trovato=true
      tabella[a][b]=true
      index=index+1
    else
      --Aggiunta del nemico al composer
      local nemici = composer.getVariable( "nemici" )
      local idNemico
      if(nemici=="vuoto") then
        nemici = {}
        idNemico = 1
      else
        idNemico = #nemici + 1
      end
      table.insert(nemici, {id=index, enemy=nemico})
      composer.setVariable( "nemici", nemici )

      local stanza={
        NORD=nil,
        SUD=nil,
        EST=nil,
        OVEST=nil,
        TESTO=index,
        visitato=false,
        corrente=false,
        seedBackground=seed,
        x=a,
        y=b,
        nemici={nemico},
        curios = {nil},
        oggetti={},
        corridoioCorrente=nil
      }
      mappa[x]=stanza
      trovato=true
      tabella[a][b]=true
      index=index+1
    end
  end

  while trovato==false do
    cardinale=math.random(1, 4)
    if (cardinale == 1) and (mappa[x].NORD == nil) and (tabella[a][b+1]==false) then
      mappa[x].seedNORD=seed
      local spawnNemico = math.random(spawnRatioNemiciLower, spawnRatioNemiciUpper)
      local spawnCurio = math.random(spawnRatioCurioLower, spawnRatioCurioUpper)
      local stringaNemico = "nemico"..spawnNemico
      local stringaCurio = "curio"..spawnCurio
      local nemico = nemici[stringaNemico]
      if(nemico==nil) then
        local stanza = {
          NORD=nil,
          SUD=mappa[x],
          EST=nil,
          OVEST=nil,
          TESTO=index,
          visitato=false,
          corrente=false,
          seedBackground=seed,
          x=a,
          y=b+1,
          seedSUD=seed,
          nemici={nemico},
          curios = {stringaCurio},
          oggetti={},
          corridoioCorrente=nil
        }
        mappa[x].NORD = stanza
        index=index+1
        mappa[index]=stanza
        b=b+1
        tabella[a][b]=true
        trovato=true
      else
        --Aggiunta del nemico al composer
        local nemici = composer.getVariable( "nemici" )
        local idNemico
        if(nemici=="vuoto") then
          nemici = {}
          idNemico = 1
        else
          idNemico = #nemici + 1
        end
        table.insert(nemici, {id=index, enemy=nemico})
        composer.setVariable( "nemici", nemici )

        local stanza = {
          NORD=nil,
          SUD=mappa[x],
          EST=nil,
          OVEST=nil,
          TESTO=index,
          visitato=false,
          corrente=false,
          seedBackground=seed,
          x=a,
          y=b+1,
          seedSUD=seed,
          nemici={nemico},
          curios = {nil},
          oggetti={},
          corridoioCorrente=nil
        }
        mappa[x].NORD = stanza
        index=index+1
        mappa[index]=stanza
        b=b+1
        tabella[a][b]=true
        trovato=true
      end
    end

    if (cardinale == 2) and (mappa[x].SUD == nil) and (tabella[a][b-1]==false) then
      mappa[x].seedSUD=seed
      local spawnNemico = math.random(spawnRatioNemiciLower, spawnRatioNemiciUpper)
      local spawnCurio = math.random(spawnRatioCurioLower, spawnRatioCurioUpper)
      local stringaNemico = "nemico"..spawnNemico
      local stringaCurio = "curio"..spawnCurio
      local nemico = nemici[stringaNemico]
      if(nemico==nil) then
        local stanza = {
          NORD=mappa[x],
          SUD=nil,
          EST=nil,
          OVEST=nil,
          TESTO=index,
          visitato=false,
          corrente=false,
          seedBackground=seed,
          x=a,
          y=b-1,
          seedNORD=seed,
          nemici={nemico},
          curios = {stringaCurio},
          oggetti={},
          corridoioCorrente=nil
        }
        mappa[x].SUD = stanza
        index=index+1
        mappa[index]=stanza
        b=b-1
        tabella[a][b]=true
        trovato=true
      else
        --Aggiunta del nemico al composer
        local nemici = composer.getVariable( "nemici" )
        local idNemico
        if(nemici=="vuoto") then
          nemici = {}
          idNemico = 1
        else
          idNemico = #nemici + 1
        end
        table.insert(nemici, {id=index, enemy=nemico})
        composer.setVariable( "nemici", nemici )

        local stanza = {
          NORD=mappa[x],
          SUD=nil,
          EST=nil,
          OVEST=nil,
          TESTO=index,
          visitato=false,
          corrente=false,
          seedBackground=seed,
          x=a,
          y=b-1,
          seedNORD=seed,
          nemici={nemico},
          curios = {nil},
          oggetti={},
          corridoioCorrente=nil
        }
        mappa[x].SUD = stanza
        index=index+1
        mappa[index]=stanza
        b=b-1
        tabella[a][b]=true
        trovato=true
      end
    end

    if (cardinale == 3) and (mappa[x].EST == nil) and (tabella[a+1][b]==false) then
      mappa[x].seedEST=seed
      local spawnNemico = math.random(spawnRatioNemiciLower, spawnRatioNemiciUpper)
      local spawnCurio = math.random(spawnRatioCurioLower, spawnRatioCurioUpper)
      local stringaNemico = "nemico"..spawnNemico
      local stringaCurio = "curio"..spawnCurio
      local nemico = nemici[stringaNemico]
      if(nemico==nil) then
        local stanza = {
          NORD=nil,
          SUD=nil,
          EST=nil,
          OVEST=mappa[x],
          TESTO=index,
          visitato=false,
          corrente=false,
          seedBackground=seed,
          x=a+1, y=b,
          seedOVEST=seed,
          nemici={nemico},
          curios = {stringaCurio},
          oggetti={},
          corridoioCorrente=nil
        }
        mappa[x].EST = stanza
        index=index+1
        mappa[index]=stanza
        a=a+1
        tabella[a][b]=true
        trovato=true
      else
        --Aggiunta del nemico al composer
        local nemici = composer.getVariable( "nemici" )
        local idNemico
        if(nemici=="vuoto") then
          nemici = {}
          idNemico = 1
        else
          idNemico = #nemici + 1
        end
        table.insert(nemici, {id=index, enemy=nemico})
        composer.setVariable( "nemici", nemici )

        local stanza = {
          NORD=nil,
          SUD=nil,
          EST=nil,
          OVEST=mappa[x],
          TESTO=index,
          visitato=false,
          corrente=false,
          seedBackground=seed,
          x=a+1, y=b,
          seedOVEST=seed,
          nemici={nemico},
          curios = {nil},
          oggetti={},
          corridoioCorrente=nil
        }
        mappa[x].EST = stanza
        index=index+1
        mappa[index]=stanza
        a=a+1
        tabella[a][b]=true
        trovato=true
      end
    end

    if (cardinale == 4) and (mappa[x].OVEST == nil) and (tabella[a-1][b]==false) then
      mappa[x].seedOVEST=seed
      local spawnNemico = math.random(spawnRatioNemiciLower, spawnRatioNemiciUpper)
      local spawnCurio = math.random(spawnRatioCurioLower, spawnRatioCurioUpper)
      local stringaNemico = "nemico"..spawnNemico
      local stringaCurio = "curio"..spawnCurio
      local nemico = nemici[stringaNemico]
      if(nemico==nil) then
        local stanza = {
          NORD=nil,
          SUD=nil,
          EST=mappa[x],
          OVEST=nil,
          TESTO=index,
          visitato=false,
          corrente=false,
          seedBackground=seed,
          x=a-1,
          y=b,
          seedEST=seed,
          nemici={nemico},
          curios = {stringaCurio},
          oggetti={},
          corridoioCorrente=nil
        }
        mappa[x].OVEST = stanza
        index=index+1
        mappa[index]=stanza
        a=a-1
        tabella[a][b]=true
        trovato=true
      else
        --Aggiunta del nemico al composer
        local nemici = composer.getVariable( "nemici" )
        local idNemico
        if(nemici=="vuoto") then
          nemici = {}
          idNemico = 1
        else
          idNemico = #nemici + 1
        end
        table.insert(nemici, {id=index, enemy=nemico})
        composer.setVariable( "nemici", nemici )

        local stanza = {
          NORD=nil,
          SUD=nil,
          EST=mappa[x],
          OVEST=nil,
          TESTO=index,
          visitato=false,
          corrente=false,
          seedBackground=seed,
          x=a-1,
          y=b,
          seedEST=seed,
          nemici={nemico},
          curios = {nil},
          oggetti={},
          corridoioCorrente=nil
        }
        mappa[x].OVEST = stanza
        index=index+1
        mappa[index]=stanza
        a=a-1
        tabella[a][b]=true
        trovato=true
      end
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
--listener per il movimento del token quando si muove il personaggio
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function move(event)

  local dir = event.source.params.direction
  if not(dir==nil) then

    if(dir=="dietroNORD") then
      token.y = token.y + 1
    elseif(dir=="dietroSUD") then
      token.y = token.y - 1
    elseif(dir == "dietroEST") then
      token.x = token.x - 1
    elseif(dir == "dietroOVEST") then
      token.x = token.x + 1
    elseif(dir == "avantiNORD") then
      token.y = token.y - 1
    elseif(dir == "avantiSUD") then
      token.y = token.y + 1
    elseif(dir == "avantiEST") then
      token.x = token.x + 1
    elseif (dir == "avantiOVEST") then
      token.x = token.x - 1
    end

    if token.x < token.partenzaX - token.movimentoMassimo or token.x > token.partenzaX + token.movimentoMassimo then
      timer.cancel(moveTimer)
    end

    if token.y < token.partenzaY - token.movimentoMassimo or token.y > token.partenzaY  + token.movimentoMassimo then
      timer.cancel(moveTimer)
    end
  end
end

--Movement Listener
local function moveListener(event)
  local phase = event.phase
  local target = event.target
  local dir
  if(phase=="began") then
    moveTimer = timer.performWithDelay( 30, move, 0)

    if(not((event.x > target.nonMovementArea.minX and event.x < target.nonMovementArea.maxX) or (event.y > target.nonMovementArea.maxY))) then
      --Touch in the movement area, starting the right movement sprite animation
      if((event.x < target.nonMovementArea.minX) and (event.y < target.nonMovementArea.maxY)) then
        if target.direzione == "NORD" then
          --sta andando indietro in una strada a nord, dunque va verso sud
          dir = "dietroNORD"
          moveTimer.isPaused = false
          moveTimer.params = {direction=dir}
        elseif target.direzione == "SUD" then
          --sta andando indietro in una strada a sud dunque va verso nord
          dir = "dietroSUD"
          moveTimer.isPaused = false
          moveTimer.params = {direction=dir}
        elseif target.direzione == "EST" then
          --sta andando indietro in una strada a est dunque va verso ovest
          dir = "dietroEST"
          moveTimer.isPaused = false
          moveTimer.params = {direction=dir}
        elseif target.direzione == "OVEST" then
          --sta andando indietro in una strada verso ovest dunque va verso est
          dir = "dietroOVEST"
          moveTimer.isPaused = false
          moveTimer.params = {direction=dir}
        end

      elseif((event.x > target.nonMovementArea.maxX) and (event.y < target.nonMovementArea.maxY)) then
        if target.direzione == "NORD" then
          --sta andando avanti in una strada a nord, dunque va verso nord
          dir = "avantiNORD"
          moveTimer.isPaused = false
          moveTimer.params = {direction=dir}
        elseif target.direzione == "SUD" then
          --sta andando avanti in una strada a sud dunque va verso sud
          dir = "avantiSUD"
          moveTimer.isPaused = false
          moveTimer.params = {direction=dir}
        elseif target.direzione == "EST" then
          --sta andando avanti in una strada a est dunque va verso est
          dir = "avantiEST"
          moveTimer.isPaused = false
          moveTimer.params = {direction=dir}
        elseif target.direzione == "OVEST" then
          --sta andando avanti in una strada verso ovest dunque va verso ovest
          dir = "avantiOVEST"
          moveTimer.isPaused = false
          moveTimer.params = {direction=dir}
        end
      end
    end

    moveTimer.isPaused = false
    moveTimer.params = {direction=dir}
  elseif(phase=="moved") then   --Touch moved
    -- --Touch falls in the non-movement area
    if((event.x > target.nonMovementArea.minX and event.x < target.nonMovementArea.maxX) or (event.y > target.nonMovementArea.maxY)) then
      if not(moveTimer==nil) then
        timer.cancel( moveTimer )
      end
      return true
    end
  elseif (phase=="ended" or phase=="cancelled") then
    if not(moveTimer==nil) then
      timer.cancel( moveTimer )
    end
  end
  return true
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione ricorsova che si occupa di fare il display della mappa stanza dopo stanza. Parte infatti dallla stanza attuale e mano mano si porta l'offset x e y per stampare le stanze in posizione corretta
--crea anche il corridoio tra una stanza e l'altra
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function displayStanzaFunzione(stanza, offx, offy)
  local dimensioniStanza = 70
  local spessoreCorridoio = 100
  local lunghezzaCorridoio = 100
  local coloreCorrente = {0, 1, 1}
  local coloreStanza={1, 0, 0}
  local coloreCorridoio={1, 0, 0}
  local tokenGroup = display.newGroup()

  local item = display.newImageRect( "Images/Icons/stanza.png", dimensioniStanza, dimensioniStanza )
  item.x=offx
  item.y=offy
  local diff = 6
  mapGroup:insert(item)

  if(stanza.corrente==true) then
    token = display.newImageRect("Images/Icons/icons3/020-crown.png", dimensioniStanza/1.5, dimensioniStanza/1.5 )
    token.movimentoMassimo=lunghezzaCorridoio
    token.x = item.x
    token.y = item.y
    tokenGroup:insert(token)
  end

  if stanza.NORD~=nil and stanza.NORD.visitato~=true then
    item=display.newImageRect( "Images/Icons/corridoioVert.png",  spessoreCorridoio, lunghezzaCorridoio )
    item.x = offx
    item.y = offy-(dimensioniStanza/2)-(lunghezzaCorridoio/2)+diff
    mapGroup:insert(item)
    stanza.NORD.visitato=true
    if(stanza.corridoioCorrente=="NORD") then
      token = display.newImageRect("Images/Icons/icons3/020-crown.png", dimensioniStanza/1.5, dimensioniStanza/1.5 )
      token.movimentoMassimo=lunghezzaCorridoio
      token.direzione="NORD"
      token.partenzaX = item.x
      token.partenzaY = item.y + lunghezzaCorridoio/2
      token.x = item.x
      token.y = item.y + lunghezzaCorridoio/2
      tokenGroup:insert(token)
    end
    displayStanzaFunzione(stanza.NORD, offx, (offy-lunghezzaCorridoio-(dimensioniStanza/2)))
  end

  if stanza.SUD~=nil and stanza.SUD.visitato~=true then
    item=display.newImageRect( "Images/Icons/corridoioVert.png",  spessoreCorridoio, lunghezzaCorridoio )
    item.x=offx
    item.y=offy+(dimensioniStanza/2)+(lunghezzaCorridoio/2)-diff
    mapGroup:insert(item)
    stanza.SUD.visitato=true
    if(stanza.corridoioCorrente=="SUD") then
      token = display.newImageRect("Images/Icons/icons3/020-crown.png", dimensioniStanza/1.5, dimensioniStanza/1.5 )
      token.movimentoMassimo=lunghezzaCorridoio
      token.direzione="SUD"
      token.partenzaX = item.x
      token.partenzaY = item.y - lunghezzaCorridoio/2
      token.x = item.x
      token.y = item.y - lunghezzaCorridoio/2
      tokenGroup:insert(token)
    end
    displayStanzaFunzione(stanza.SUD, offx, (offy+lunghezzaCorridoio+(dimensioniStanza/2)))
  end

  if stanza.EST~=nil and stanza.EST.visitato~=true then
    item=display.newImageRect( "Images/Icons/corridoioOriz.png",  lunghezzaCorridoio, spessoreCorridoio )
    item.x=offx+(dimensioniStanza/2)+(lunghezzaCorridoio/2)-diff
    item.y=offy
    mapGroup:insert(item)
    stanza.EST.visitato=true
    if(stanza.corridoioCorrente=="EST") then
      token = display.newImageRect("Images/Icons/icons3/020-crown.png", dimensioniStanza/1.5, dimensioniStanza/1.5 )
      token.movimentoMassimo=lunghezzaCorridoio
      token.direzione="EST"
      token.partenzaX = item.x - lunghezzaCorridoio/2
      token.partenzaY = item.y
      token.x = item.x - lunghezzaCorridoio/2
      token.y = item.y
      tokenGroup:insert(token)
    end
    displayStanzaFunzione(stanza.EST, offx+lunghezzaCorridoio+(dimensioniStanza/2), offy)
  end

  if stanza.OVEST~=nil and stanza.OVEST.visitato~=true then
    item=display.newImageRect( "Images/Icons/corridoioOriz.png",   lunghezzaCorridoio, spessoreCorridoio )
    item.x=offx-(dimensioniStanza/2)-(lunghezzaCorridoio/2)+diff
    item.y=offy

    mapGroup:insert(item)
    stanza.OVEST.visitato=true
    if(stanza.corridoioCorrente=="OVEST") then
      token =  display.newImageRect("Images/Icons/icons3/020-crown.png", dimensioniStanza/1.5, dimensioniStanza/1.5 )
      token.movimentoMassimo=lunghezzaCorridoio
      token.direzione="OVEST"
      token.partenzaX = item.x + lunghezzaCorridoio/2
      token.partenzaY = item.y
      token.x = item.x + lunghezzaCorridoio/2
      token.y = item.y
      tokenGroup:insert(token)
    end
    displayStanzaFunzione(stanza.OVEST, offx-lunghezzaCorridoio-(dimensioniStanza/2), offy)
  end
  mapGroup:insert(tokenGroup)
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
    local itemInterface = require("itemsInterface")
    --print(display.contentCenterX.."---"..display.contentCenterY)
    local partenzax = display.contentCenterX-625
    local partenzay= display.contentCenterY+80
    local griglia = {}

    composer.setVariable( "grigliaOggetti", griglia )
    composer.setVariable("invx", partenzax)
    composer.setVariable("invy", partenzay)

    --Ciclo di creazione delle caselle dell'inventario
    --TABELLA: parte dalle coordinate {partenzaX, partenzaY} (angolo alto a sinistra)
    --         si estende di 700*272
    --CASELLE: ognuna ha dimensioni 140*136
    --         ci sono 5 caselle per riga e 2 righe
    local posizioneX = partenzax    --Posizione dell'angolo in alto a sinistra di ogni casella
    local posizioneY = partenzay
    for x=1, 2, 1 do
      for y=1, 5, 1 do
        local casellaX = posizioneX + 70
        local casellaY = posizioneY + 68
        -- --print("casella = "..casellaX..", "..casellaY)
        local griglia = composer.getVariable( "grigliaOggetti" )

        --Ogni casella della griglia è composta dalle coordinate centrali della casella e da un booleano che inidica se la casella è occupata o meno
        griglia[index]={casellaX, casellaY, false, nil}
        composer.setVariable( "grigliaOggetti",  griglia)

        posizioneX = posizioneX + 140
        index=index+1
      end

      posizioneX = partenzax
      posizioneY = posizioneY + 136
    end

    --Ciclo di visualizzazione degli oggetti dell'inventario
    local griglia = composer.getVariable( "grigliaOggetti" )
    for x=1, 10, 1 do
      if(not(inventario[x] == "vuoto")) then
        local nomeItem = inventario[x]

        item = display.newImageRect(inventoryGroup,  itemInterface[nomeItem].location..itemInterface[nomeItem].nome, 70, 70)
        item.x = griglia[x][1]
        item.y = griglia[x][2]
        item.id = x
        item.nome = itemInterface[nomeItem].nome
        item.location = itemInterface[nomeItem].location
        item.activateFunction = itemInterface[nomeItem].activateFunction
        item.description = itemInterface[nomeItem].description
        griglia[x][3] = true
        griglia[x][4] = item


        item:addEventListener("tap", viewDesc)

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

      if((event.x > (display.contentCenterX+150) and event.x < (lunghezza-50)) and (event.y > (display.contentCenterY+75) and event.y < (altezza-25))) then
        item.touchOffsetX=event.x-item.x
        item.touchOffsetY=event.y-item.y
      end
    elseif("moved"==phase) then
      -- Muove la nave

      if((event.x > (display.contentCenterX+150) and event.x < (lunghezza-50)) and (event.y > (display.contentCenterY+75) and event.y < (altezza-25))) then
        if not((item.touchOffsetX==nil) and (item.touchOffsetY==nil)) then
          item.x=event.x-item.touchOffsetX
          item.y=event.y-item.touchOffsetY
        end
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
    local curiosInterface = require("curiosInterface")
    local curios = composer.getVariable( "activeCurios" )
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


      item.touchOffsetX=event.x-item.x
      item.touchOffsetY=event.y-item.y
      -- end
    elseif("moved"==phase) then
      -- Muove la nave
      if not((item.touchOffsetX==nil) and (item.touchOffsetY==nil)) then
        item.x=event.x-item.touchOffsetX
        item.y=event.y-item.touchOffsetY
      end
    elseif("ended"==phase or "cancelled"==phase) then
      --Oggetto fuori dall'inventario (tentativo di rimozione)
      if( (item.x < invx or item.x > (invx+700)) or (item.y < invy or item.y > (invy+272)) ) then
        item.activateFunction(item.x, item.y)
        --print("appoggiato")
        for i=#curios, 1, -1 do
          if (item.x < curios[i].areaXUpper and item.x > curios[i].areaXLower and item.y < curios[i].areaYUpper and item.y > curios[i].areaYLower) then
            if curios[i].funzione(item, curios[i]) then
              local app = curios[i]
              composer.getVariable( "activeCurios" )[i]=curiosInterface.createCurio(self, app.sostitutivo)
              composer.getVariable( "mainGroup" ):insert(composer.getVariable( "activeCurios" )[i])
              composer.getVariable( "activeCurios" )[i]:toBack()
              for j = #composer.getVariable( "stanzaCorrente" ).curios, 1, -1 do
                if composer.getVariable( "stanzaCorrente" ).curios[j] == app.nome then
                  composer.getVariable( "stanzaCorrente" ).curios[j] = composer.getVariable( "activeCurios" )[i].nome
                end
              end

            else
              item.x = partenza[1]
              item.y = partenza[2]
            end
          end
        end
        if not(inventario[idItem]=="vuoto") and not(griglia[idItem]==nil) then
          --print("rimosso")
          inventario[idItem] = "vuoto"
          griglia[idItem][3] = false
          griglia[idItem][4] = nil
        end
        display.remove( item )
      else
        -- VA IMPLEMENTATO L'AUTO POSIZIONAMENTO DEGLI ITEM E LO SCAMBIO DI POSTO
        --print("considerato dentroo")
        local xRel = item.x - invx
        local yRel = item.y - invy
        local numCol, restCol = math.modf(xRel/140)
        local numRiga, restRiga = math.modf(yRel/136)
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
            if not(griglia[idItem]==nil) then
              griglia[idItem][3] = false
              griglia[idItem][4] = nil
            end
            item.x = griglia[numCasella][1]
            item.y = griglia[numCasella][2]
            item.id = numCasella

            griglia[numCasella][3] = true
            griglia[numCasella][4] = item
            if not(griglia[idItem]==nil) then
              inventario[numCasella] = inventario[idItem]
              inventario[idItem] = "vuoto"
            else
              local curio = item.curio
              if(not(curio== nil)) then
                  inventario[numCasella] = curio.oggetto
                  local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
                  for i = #stanzaCorrente.oggetti, 1, -1 do
                    if stanzaCorrente.oggetti[i] == curio.oggetto then
                      table.remove(stanzaCorrente.oggetti, i)
                    end
                  end
              end

              if(not(item.oggetto == nil)) then
                  inventario[numCasella] = item.oggetto

              end
            end
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

  tokenListener=(moveListener),
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  --numero di stanze
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  numeroStanze=8,

  dropItemFunction=
  (function(x, y, drop)
    local itemInterface = require("itemsInterface")
    local interfaccia = require("interfaceConfig")
    local handler=interfaccia.dragItem
    local tabDrop = drop
    local n = math.random(1, 2)
    local oggetto = itemInterface[tabDrop[n]]
    local item = display.newImageRect( oggetto.location .. oggetto.nome, 70, 70)
    item.activateFunction = oggetto.activateFunction
    item.x = x
    item.y = y - 100
    item.id = 11
    item.oggetto = tabDrop[n]
    item:addEventListener("touch", handler)
    composer.getVariable( "sceneGroup" ):insert(item)
    item:toFront()
    --print("Droppato oggetto")
    composer.setVariable( "endFight", "false" )
  end)
}
return interfacciaConfig
