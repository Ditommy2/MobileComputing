local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local username
local password
local json=require("json")
local filePath=system.pathForFile("savedDatas.json", system.DocumentsDirectory)
local filePathComandi=system.pathForFile("binario.json", system.DocumentsDirectory)
local json=require("json")
local contents
local confermapassword
local lunghezza =  display.contentWidth
local altezza=  lunghezza*(9/16)
--local function handleButtonEvent( event )
  --  if ( "ended" == event.phase ) then
  --  	local URL = "http://web.web.com/yourscript.php?username=" .. urlencode( username.text ) .. "&password=" .. urlencode(password.text)
--network.request(URL, "GET", networkListener)


--	end
--end
--http://localhost/mobilecomputing/insert.php?name=braga&password=123
--delete from user where name!='paolo'
-----------------------------------------------------------------------------------------------------
local function urlencode(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
		function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str
end
---------------------------------------------------------------------------------------------------
local function saveDatas(str1, str2)
	local file = io.open( filePath, "w" )
	if file then
		local stringa = str1.." "..str2
		file:write(json.encode(stringa))
		io.close(file)
	end
end
---------------------------------------------------------------------------------------------------
local function loadDatas()

    local file = io.open( filePath, "r" )

    if file then
        contents = file:read( "*a" )
				--local printare = json.decode(cotents)
				print(contents)
        io.close( file )
		end
end
---------------------------------------------------------------------------------------------------
local function networkListener( event )

    if ( event.isError ) then
			print("Cozzio che è successo?")
    else
    	print( event.response .."EVENTO")
			if event.response=="" then
				saveDatas(username.text, password.text)
				loadDatas()
				local file = io.open( filePathComandi, "w" )
		    if file then
					local stringa = "false"
					file:write(json.encode(stringa))
					io.close(file)
				end
				for i = loginGroup.numChildren, 1, -1 do
          loginGroup[i]:removeSelf()
          loginGroup[i] = nil
        end
				composer.gotoScene( "livello1" )
				--composer.gotoScene("register")
			elseif event.response == ("Duplicate entry '"..username.text.."' for key 'PRIMARY'") then
			print("Username gia in uso")

			local file = io.open( filePathComandi, "w" )

	    if file then
				local stringa = "true"
				file:write(json.encode(stringa))
				io.close(file)
			end
			composer.gotoScene("register")
			end
    end
end

--https://mobilecompfra.000webhostapp.com/public_html/insert.php
---------------------------------------------------------------------------------------------------
local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
			if(password.text ~= confermapassword.text) then
				local file = io.open( filePathComandi, "w" )

		    if file then
					local stringa = "confermapassword"
					file:write(json.encode(stringa))
					io.close(file)
				end
				composer.gotoScene("register")
else
    	local URL = "https://appmcsite.000webhostapp.com/insert.php?username=" .. urlencode( username.text ) .. "&password=" ..urlencode(password.text)
			--local URL = "".. urlencode( username.text ) .. "&password=" ..urlencode(password.text)
        network.request(URL, "GET", networkListener)

			end
	end
end

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()---------------------------------------------------------------------------------------------------
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	loginGroup=display.newGroup()

	local background=display.newImageRect(sceneGroup, "background.png", lunghezza, altezza)
	background.x=display.contentCenterX
	background.y=display.contentCenterY
	local lunghezzaFinestra=lunghezza-400
	local altezzzaFinestra=lunghezzaFinestra*(9/16)
	sceneGroup:insert(background)
	local midBackground = display.newRect( display.contentCenterX, display.contentCenterY-180, lunghezzaFinestra, altezzzaFinestra )
	midBackground:setFillColor(0.18, 0.18, 0.23)
	loginGroup:insert(midBackground)

 username = native.newTextField( display.contentCenterX, display.contentCenterY-350, lunghezzaFinestra-30, 80 )
username.placeholder = "Username"
loginGroup:insert(username)

 password = native.newTextField( display.contentCenterX, display.contentCenterY-250, lunghezzaFinestra-30, 80 )
password.isSecure = true
password.placeholder = "Password"
loginGroup:insert(password)

confermapassword = native.newTextField( display.contentCenterX, display.contentCenterY-150, lunghezzaFinestra-30, 80 )
confermapassword.isSecure = true
confermapassword.placeholder = "Conferma Password"
loginGroup:insert(confermapassword)

local file = io.open( filePathComandi, "r" )

if file then
		local contents = file:read( "*a" )
		--local printare = json.decode(cotents)
		print(contents)
		io.close( file )
		if contents=="\"true\"" then
			local risposta = display.newText( sceneGroup, "Username già in uso",display.contentCenterX, display.contentCenterY-160, native.systemFont, 30)
			risposta.x=display.contentCenterX
			risposta.y = username.y-55
			risposta:setFillColor(0.5, 0, 0)
		end
		if contents=="\"confermapassword\"" then
			local risposta = display.newText( loginGroup, "Le password sono diverse",display.contentCenterX, display.contentCenterY-160, native.systemFont, 30)
			risposta.x=display.contentCenterX
			risposta.y = username.y-55
			risposta:setFillColor(0.5, 0, 0)
		end
end
--if(json.decode(contents)=="false") then
--local risposta = diaplay.newText(sceneGroup, "Password gia in uso")
--risposta.x = display.contentCenterX
--risposta.y = display.contentCenterY
--end

local Button = widget.newButton(
   {
       shape = "roundedRect",
       left = 70,
       top = 360,
			 width=lunghezzaFinestra-200,
			 height=90,
       id = "Nuova",
       label = "Nuova Partita",
			 labelColor={default={0.5, 0, 0}},
			 fontSize=50,
       onEvent = handleButtonEvent
   }
)
loginGroup:insert(Button)
Button.x=display.contentCenterX
Button.y=display.contentCenterY
-- loginGroup.x=500
 loginGroup.y=display.contentCenterY-150
end



-- show()---------------------------------------------------------------------------------------------------
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()---------------------------------------------------------------------------------------------------
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene("register")

	end
end


-- destroy()---------------------------------------------------------------------------------------------------
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
