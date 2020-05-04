local composer= require("composer")
-----------------------------------------------------------------------------------
local function proceduraleMappaFunzione(index, mappa, numero, a, b, tabella)
  print("punto di partenza: ", a, " ", b)
  local x
  local cardinale
  local trovato = false
  local seed = math.random(1, 5)
  if index>0 then
    x=math.random(1, index)

    print("genera un random 1, ", index)
    print("esce ", x)
  else
    x=1
    print("genera prima stanza")
    local stanza={NORD=nil, SUD=nil, EST=nil, OVEST=nil, TESTO=index, visitato=false, corrente=false, seedBackground=seed}
    mappa[x]=stanza
    trovato=true
    tabella[a][b]=true
    index=index+1
  end
  while trovato==false do
    cardinale=math.random(1, 4)
    if (cardinale == 1) and (mappa[x].NORD == nil) and (tabella[a][b+1]==false) then
      print("assegna alla stanza ", x, " una stanza a NORD")
      local stanza = {NORD=nil, SUD=mappa[x], EST=nil, OVEST=nil, TESTO=index, visitato=false, corrente=false, seedBackground=seed}
      mappa[x].NORD = stanza
      index=index+1
      mappa[index]=stanza
      b=b+1
      tabella[a][b]=true
      trovato=true
    end

    if (cardinale == 2) and (mappa[x].SUD == nil) and (tabella[a][b-1]==false) then
      print("assegna alla stanza ", x, " una stanza a SUD")
      local stanza = {NORD=mappa[x], SUD=nil, EST=nil, OVEST=nil, TESTO=index, visitato=false, corrente=false,  seedBackground=seed}
      mappa[x].SUD = stanza
      index=index+1
      mappa[index]=stanza
      b=b-1
      tabella[a][b]=true
      trovato=true
    end

    if (cardinale == 3) and (mappa[x].EST == nil) and (tabella[a+1][b]==false) then
      print("assegna alla stanza ", x, " una stanza a EST")
      local stanza = {NORD=nil, SUD=nil, EST=nil, OVEST=mappa[x], TESTO=index, visitato=false, corrente=false, seedBackground=seed}
      mappa[x].EST = stanza
      index=index+1
      mappa[index]=stanza
      a=a+1
      tabella[a][b]=true
      trovato=true
    end

    if (cardinale == 4) and (mappa[x].OVEST == nil) and (tabella[a-1][b]==false) then
      print("assegna alla stanza ", x, " una stanza a OVEST")
      local stanza = {NORD=nil, SUD=nil, EST=mappa[x], OVEST=nil, TESTO=index, visitato=false, corrente=false, seedBackground=seed}
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
  return proceduraleMappaFunzione(index, mappa, numero, a, b, tabella)
end
--------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------
local function displayStanzaFunzione(stanza, offx, offy)
  local dimensioniStanza = 20
  local spessoreCorridoio = 5
  local lunghezzaCorridoio = 50
  local coloreCorrente = {0, 1, 1}
  local coloreStanza={1, 0, 0}
  local coloreCorridoio={1, 0, 0}
local item = display.newRect( offx, offy, dimensioniStanza, dimensioniStanza )
item:setFillColor(coloreStanza[1], coloreStanza[2], coloreStanza[3])
if(stanza.corrente==true) then item:setFillColor(coloreCorrente[1], coloreCorrente[2], coloreCorrente[3])
end
mapGroup:insert(item)
print("stanza stampata: ")
print(stanza.TESTO)
if stanza.NORD~=nil and stanza.NORD.visitato~=true then
  item=display.newRect( offx, offy-10-(lunghezzaCorridoio/2), spessoreCorridoio, lunghezzaCorridoio )
  item:setFillColor(coloreCorridoio[1], coloreCorridoio[2], coloreCorridoio[3])
  mapGroup:insert(item)
  stanza.NORD.visitato=true
  displayStanzaFunzione(stanza.NORD, offx, (offy-lunghezzaCorridoio-10))

end

if stanza.SUD~=nil and stanza.SUD.visitato~=true then
  item=display.newRect( offx, offy+10+(lunghezzaCorridoio/2), spessoreCorridoio, lunghezzaCorridoio )
  item:setFillColor(1, 0, 0)
  mapGroup:insert(item)
  stanza.SUD.visitato=true
  displayStanzaFunzione(stanza.SUD, offx, (offy+lunghezzaCorridoio+10))

end

if stanza.EST~=nil and stanza.EST.visitato~=true then
  item=display.newRect( offx+10+(lunghezzaCorridoio/2), offy, lunghezzaCorridoio, spessoreCorridoio )
  item:setFillColor(1, 0, 0)
  mapGroup:insert(item)
  stanza.EST.visitato=true
  displayStanzaFunzione(stanza.EST, offx+lunghezzaCorridoio+10, offy)

end

if stanza.OVEST~=nil and stanza.OVEST.visitato~=true then
  item=display.newRect( offx-10-(lunghezzaCorridoio/2), offy, lunghezzaCorridoio, spessoreCorridoio )
  item:setFillColor(1, 0, 0)
  mapGroup:insert(item)
  stanza.OVEST.visitato=true
  displayStanzaFunzione(stanza.OVEST, offx-lunghezzaCorridoio-10, offy)

end
end
--------------------------------------------------------------------------------------------------------------
local interfacciaConfig = {
  displayGrid=
  (function(input, colonne, righe, handler)
    local index=1
    local partenzax = display.contentCenterX-150
    local partenzay= display.contentCenterY-90
  for x=1, colonne, 1 do
    for y=1, righe, 1 do
      local item = (display.newText( input[index], partenzax+(x*60), partenzay+(y*60),  native.systemFont, 16))
      item:setFillColor(1, 0, 0)
      item:addEventListener("touch", handler)
      inventoryGroup:insert(item)
      index=index+1
      if (index > #input) then
        return
      end
    end
  end
end),
---------------------------------------------------------------------------------------------------------------------------------------------------
  proceduraleMappa=
  (proceduraleMappaFunzione),
  -----------------------------------------------------------------------------------------------------------
  displayStanza=
  (displayStanzaFunzione),
  ------------------------------------------------------------------------------------------------------------------
  annullaVisite=
  (annullaVisitefunzione),
--------------------------------------------------------------------------------------------------------------------
dragItem=
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
     display.currentStage:setFocus(nil)
    end
    return true
end),
-----------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------
tabellaFunction=
(function (n)
  local tabella={}
  local numero = (2*n)+1
  for i=1, numero, 1 do
    tabella[i]={}
    print("creata colonna numero ", i)
    for j=1, numero, 1 do
      print("creata casella in ", i, " ", j)
      tabella[i][j]=false
    end
  end
  return tabella
end),
-----------------------------------------------------------------------------------------------

}
return interfacciaConfig
