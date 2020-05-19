local M = {}
local json = require( "json" )
local defaultLocation = system.DocumentsDirectory
local customFont="MadnessHyperactive.otf"
--local customFont=native.systemFont
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--carica save: si occupa di caricare il salvataggio sullo script php e quindi sul database
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function M.caricaSave(stringaSalvataggio)
local function networkListener( event )
  print("FASE DOWNLOAD: "..event.phase)
    if ( event.isError ) then
        print( "Network error: ", event.response )
    elseif ( event.phase == "ended" ) then
        print ( "Upload complete!" )
    end
end
local loc = defaultLocation
  local URL = "https://appmcsite.000webhostapp.com/caricaSave.php"
  print("PROVA DI UPLOAD DEL FILE "..stringaSalvataggio.." NELL URL "..URL)
  local path = system.pathForFile( stringaSalvataggio, loc )
  print("IL FILE HA PATH "..path)
--network.request(URL, "POST", networkListener, stringaSalvataggio, system.DocumentsDirectory, "application/json")
network.request(URL, "POST", networkListener, {body={filename=stringaSalvataggio, baseDirectory=system.DocumentsDirectory}, bodyType="text", timeout=100})
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione per salvare su filepath una tabella
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function M.saveTable( t, filename, location )

    local loc = location
    if not location then
      print("IMPOSTATA LA DEF LOC")
        loc = defaultLocation
    end

    -- Path for the file to write
    local path = system.pathForFile( filename, loc )

    -- Open the file handle
    local file, errorString = io.open( path, "w" )

    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Write encoded JSON data to file
        file:write( json.encode( t , {indent=true}) )
        -- Close the file handle
        io.close( file )
        return true
    end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione per risolvere i cicli di ricorsione che si generano sul file-----------------------------------ERRORE
--annotazioni: le back cycling sono assolutamente insensate, puntano a se stesse o a stanze casuali, è per questo che si rompe tutto
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function antiReferenceCycle(precedente, attuale)
-- print("ITERAZIONE ANTICICLO SU STANZA ", attuale.TESTO)
  -- for i = 1, #startingTable, 1 do
  --   if
  --   if startingTable[i]=="<reference cycle>" then
  --     print("swappato il reference")
  --     startingTable[i]=startingTable
  --   else
  --     print("non era ciclato")
  --     t=antiReferenceCycle(startingTable[i])
  --   end
  -- end
  local t = attuale
  if not (attuale.NORD == nil) then
    if attuale.NORD=="<reference cycle>" then
      -- print("swappato il reference")
      attuale.NORD=precedente
    else
      -- print("non era ciclato")
      -- t=
      antiReferenceCycle(attuale, attuale.NORD)
    end
  end

  if not (attuale.SUD == nil) then
    if attuale.SUD=="<reference cycle>" then
      -- print("swappato il reference")
      attuale.SUD=precedente
    else
      -- print("non era ciclato")
      -- t=
      antiReferenceCycle(attuale, attuale.SUD)
    end
  end

  if not (attuale.EST == nil) then
    if attuale.EST=="<reference cycle>" then
      -- print("swappato il reference")
      attuale.EST=precedente
    else
      -- print("non era ciclato")
      -- t=
      antiReferenceCycle(attuale, attuale.EST)
    end
  end

  if not (attuale.OVEST == nil) then
    if attuale.OVEST=="<reference cycle>" then
      -- print("swappato il reference")
      attuale.OVEST=precedente
    else
      -- print("non era ciclato")
      -- t=
      antiReferenceCycle(attuale, attuale.OVEST)
    end
  end

  -- return t
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione per caricare da filepath una tabella
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function M.loadTable( filename, location )

    local loc = location
    if not location then
        loc = defaultLocation
    end

    -- Path for the file to read
    local path = system.pathForFile( filename, loc )

    -- Open the file handle
    local file, errorString = io.open( path, "r" )

    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Read data from file
        local contents = file:read( "*a" )
        -- Decode JSON data into Lua table
        local t = json.decode( contents )
        -- Close the file handle
        -- print("ANTICICLO SULLA MAPPA")

        -- t.mappaToSave=
        antiReferenceCycle(t.mappaToSave, t.mappaToSave)
        -- print("ANTICICLO SULLA STANZA")
        -- t.stanzaCorrenteToSave=
        antiReferenceCycle(t.stanzaCorrenteToSave, t.stanzaCorrenteToSave)
        io.close( file )
        -- Return table
        return t
    end
end
return M
