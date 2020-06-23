local M = {}
local json = require( "json" )
local defaultLocation = system.DocumentsDirectory
local customFont="MadnessHyperactive.otf"
--local customFont=native.systemFont

local function urlencode(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
		function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--carica save: si occupa di caricare il salvataggio sullo script php e quindi sul database
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function M.caricaSave(salvataggio, stringaSalvataggio)

local function uploadListener( event )
  if ( event.isError ) then
     print( "Network Error." )
     print(event.response)
  else
     if ( event.phase == "began" ) then
        print( "Upload started" )
     elseif ( event.phase == "progress" ) then
        print( "Uploading... bytes transferred ", event.bytesTransferred )
     elseif ( event.phase == "ended" ) then
        print( "Upload ended..." )
        print( "Status:", event.status )
        print( "Response:", event.response )
     end
  end
end

local url = "https://appmcsite.000webhostapp.com/caricaSave.php?name=".. urlencode( stringaSalvataggio )
local method = "POST"

local params = {
  timeout = 120,
  progress = true,
  bodyType = "binary"
}

local filename = stringaSalvataggio
local baseDirectory = system.DocumentsDirectory
local contentType = "application/json"
print(system.pathForFile(filename))
local headers = {}
headers.filename = filename
params.headers = headers
print(salvataggio)
network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
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
        file:write( json.encode( t, {indent = true} ) )
        print("File written successfullt into: ", path)
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
        print("legegndo file da: ", path)
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
