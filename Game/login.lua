-----------------------------------------------------------------------------------------
--
-- login.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- forward declare the text fields
local json = require("json")

local username
local password

local function urlencode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str
end

local function networkListener( event )

    if ( event.isError ) then
        print( "Network error. ")
    else
        if event.response == "success" then
            print("Success! We are now logged!")

            -- put the code here to go to where the user needs to be
            -- after a successful registration
            composer.gotoScene("stanza1")

        else
            -- put code here to notify the user of the problem, perhaps
            -- a native.alert() dialog that shows them the value of event.response
            -- and take them back to the registration screen to let them try again

            local alert = native.showAlert( "You are not registered. ", { "Try again"}, onComplete )

    end
  end
end

local function userRegister( event )
    if ( "ended" == event.phase ) then
        local URL = "https://appmcsite.000webhostapp.com/insert.php" .. username.text .. "&password=" .. password.text .. "&password2=" .. password2.text .. "&email=" .. urlencode( email.text )
        network.request(URL, "GET", networkListener)

    end
end

local function loginLink( event )
    if ( "ended" == event.phase ) then
         composer.gotoScene("login")
    end
end

function scene:create(event)
   local screenGroup = self.view

   display.setDefault("background", 0, 3, 5)

   username = native.newTextField( 160, 200, 180, 30 )  -- take the local off since it's forward declared
   username.placeholder = "Username"
   screenGroup:insert(username)

   password = native.newTextField( 160, 250,180, 30 ) -- take the local off since it's forward declared
   password.isSecure = true
   password.placeholder = "Password"
   screenGroup:insert(password)

   password2 = native.newTextField( 160, 300,180, 30 ) -- take the local off since it's forward declared
   password2.isSecure = true
   password2.placeholder = "Confirm Password"
   screenGroup:insert(password2)

   email = native.newTextField( 160, 350, 180, 30 ) -- take the local off since it's forward declared
   email.placeholder = "E-mail"
   screenGroup:insert(email)

 local Button = widget.newButton(
    {
        shape = "roundedRect",
        left = 70,
        top = 400,
        id = "Register",
        label = "Register",
        onEvent = userRegister
    }
)
screenGroup:insert(Button)


local Button2 = widget.newButton(
    {
        left = 70,
        top = 460,
        id = "Loginhere",
        label = "Login here",
        onEvent = loginLink
    }
)
screenGroup:insert(Button2)

end

function scene:show(event)
end

function scene:hide(event)
end

function scene:destroy(event)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
