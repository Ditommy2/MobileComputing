local M = {}
local json = require( "json" )
local defaultLocation = system.DocumentsDirectory
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--funzione per salvare su filepath una tabella
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function M.saveTable( t, filename, location )

    local loc = location
    if not location then
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
local function antiReferenceCycle(t)
local startingTable = t
print("ITERAZIONE ANTICICLO SU STANZA ", startingTable.TESTO)
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

  if not (startingTable.NORD == nil) then
    if startingTable.NORD=="<reference cycle>" then
      print("swappato il reference")
      startingTable.NORD=startingTable
    else
      print("non era ciclato")
      t=antiReferenceCycle(startingTable.NORD)
    end
  end

  if not (startingTable.SUD == nil) then
  if startingTable.SUD=="<reference cycle>" then
    print("swappato il reference")
    startingTable.SUD=startingTable
  else
    print("non era ciclato")
    t=antiReferenceCycle(startingTable.SUD)
  end
  end

  if not (startingTable.EST == nil) then
  if startingTable.EST=="<reference cycle>" then
    print("swappato il reference")
    startingTable.EST=startingTable
  else
    print("non era ciclato")
    t=antiReferenceCycle(startingTable.EST)
  end
  end

  if not (startingTable.OVEST == nil) then
  if startingTable.OVEST=="<reference cycle>" then
    print("swappato il reference")
    startingTable.OVEST=startingTable
  else
    print("non era ciclato")
    t=antiReferenceCycle(startingTable.OVEST)
  end
  end

  return startingTable
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
        print("ANTICICLO SULLA MAPPA")

        t.mappaToSave=antiReferenceCycle(t.mappaToSave)
        print("ANTICICLO SULLA STANZA")
        t.stanzaCorrenteToSave=antiReferenceCycle(t.stanzaCorrenteToSave)
        io.close( file )
        -- Return table
        return t
    end
end
return M
