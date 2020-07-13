local M = {}
local composer= require("composer")
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
--scarica save: si occupa di scaricare il salvataggio dal database
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function M.scaricaSave(stringaSalvataggio)
	local function networkListener( event )
		if ( event.isError ) then
			print( "Network error - download failed: ", event.response )
		elseif ( event.phase == "began" ) then
			print( "Progress Phase: began" )
		elseif ( event.phase == "ended" ) then
			print( "Download completed for filename :"..stringaSalvataggio  )
			print(event.response.filename)
			-- local t = M.loadTable(event.response.filename, event.response.baseDirectory)
			-- M.saveTable(t, event.response.filename, system.documentsDirectory)
		end
	end
	print("Download Richiesto: "..stringaSalvataggio)
	local params = {}
	params.progress = true
	network.download(
	"https://appmcsite.000webhostapp.com/upload/"..stringaSalvataggio,
	"GET",
	networkListener,
	params,
	stringaSalvataggio,
	defaultLocation
)
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
				print( "Upload started for filename :"..stringaSalvataggio  )
			elseif ( event.phase == "progress" ) then
				print( "Uploading... bytes transferred ", event.bytesTransferred )
			elseif ( event.phase == "ended" ) then
				print( "Upload ended for filename :"..stringaSalvataggio  )
				print( "Status:", event.status )
				print( "Response:", event.response )
			end
		end
	end
	local username = composer.getVariable( "username" )
	local url = "https://appmcsite.000webhostapp.com/caricaSave.php"
	local method = "POST"

	local params = {
		timeout = 120,
		progress = true,
		bodyType = "binary"
	}

	local filename = stringaSalvataggio
	local baseDirectory = system.DocumentsDirectory
	local contentType = "application/json"
	local headers = {}
	headers.filename = filename
	params.headers = headers
	network.upload( url , method, uploadListener, params, filename, baseDirectory, contentType )
end
function M.caricaScore(salvataggio, stringaSalvataggio)

	local function uploadListener( event )
		if ( event.isError ) then
			print( "Network Error." )
			print(event.response)
		else
			if ( event.phase == "began" ) then
				print( "Upload started for filename :"..stringaSalvataggio  )
			elseif ( event.phase == "progress" ) then
				print( "Uploading... bytes transferred ", event.bytesTransferred )
			elseif ( event.phase == "ended" ) then
				print( "Upload ended for filename :"..stringaSalvataggio )
				print( "Status:", event.status )
				print( "Response:", event.response )
			end
		end
	end
	local username = composer.getVariable( "username" )
	local url = "https://appmcsite.000webhostapp.com/caricaScore.php"
	local method = "POST"

	local params = {
		timeout = 120,
		progress = true,
		bodyType = "binary"
	}

	local filename = stringaSalvataggio
	local baseDirectory = system.DocumentsDirectory
	local contentType = "application/json"
	local headers = {}
	headers.filename = filename
	params.headers = headers
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
		print("File written successfully into: ", path)
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
        print( "File error: " .. errorString.." for filename "..filename )
    else
        -- Read data from file
        local contents = file:read( "*a" )
        print("leggendo file da: ", path)
        -- Decode JSON data into Lua table
        local t = json.decode( contents )
        -- Close the file handle
        -- print("ANTICICLO SULLA MAPPA")
        -- t.mappaToSave=
				if(t==nil) then
				return {}
				end
				for i=#t, 1, -1 do
				antiReferenceCycle(t[i].mappaToSave, t[i].mappaToSave)
        -- print("ANTICICLO SULLA STANZA")
        -- t.stanzaCorrenteToSave=
        antiReferenceCycle(t[i].stanzaCorrenteToSave, t[i].stanzaCorrenteToSave)
			end
        io.close( file )
        -- Return table
        return t
    end
end


function M.loadTableScores( filename, location )
	local loc = location
	if not location then
		loc = defaultLocation
	end

	-- Path for the file to read
	local path = system.pathForFile( filename, loc )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
		local url = "https://appmcsite.000webhostapp.com/Upload/prendiSave.php"

	  print(url)

	  network.request( url, "GET", networkListener)
	end

	-- Open the file handle
	if(file==nil) then return {} end

	local file, errorString = io.open( path, "r" )
	-- Error occurred; output the cause
	-- Read data from file
	local contents = file:read( "*a" )
	-- Decode JSON data into Lua table
	local t = json.decode( contents )
	-- Close the file handle

	io.close( file )
	return t
end

return M
