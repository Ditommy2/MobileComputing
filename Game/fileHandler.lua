local M = {}
local json = require( "json" )
local defaultLocation = system.DocumentsDirectory
local customFont="MadnessHyperactive.otf"
--local customFont=native.systemFont
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--carica save: si occupa di caricare il salvataggio sullo script php e quindi sul database
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function M.caricaSave(salvataggio, stringaSalvataggio)

local function uploadListener( event )
  if ( event.isError ) then
     print( "Network Error." )
     print(event.response)
     -- This is likely a time out or server being down. In other words,
     -- It was unable to communicate with the web server. Now if the
     -- connection to the web server worked, but the request is bad, this
     -- will be false and you need to look at event.status and event.response
     -- to see why the web server failed to do what you want.
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

-- Sepcify the URL of the PHP script to upload to. Do this on your own server.
-- Also define the method as "PUT".
local url = "https://appmcsite.000webhostapp.com/caricaSave.php"
local method = "PUT"

-- Set some reasonable parameters for the upload process:
local params = {
  timeout = 12000000, 
  progress = true,
  bodyType = "binary"
}

-- Specify what file to upload and where to upload it from.
-- Also, set the MIME type of the file so that the server knows what to expect.
local filename = stringaSalvataggio
local baseDirectory = system.DocumentsDirectory
local contentType = "application/json"  --another option is "text/plain"
print(system.pathForFile(filename))
-- There is no standard way of using HTTP PUT to tell the remote host what
-- to name the file. We'll make up our own header here so that our PHP script
-- expects to look for that and provides the name of the file. Your PHP script
-- needs to be "hardened" because this is a security risk. For example, someone
-- could pass in a path name that might try to write arbitrary files to your
-- server and overwrite critical system files with malicious code.
-- Don't assume "This won't happen to me!" because it very well could.
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
        file:write( json.encode( t ) )
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
