-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local characterInterface = require("characterInterface")

local scene = composer.newScene()

composer.recycleAutomatically=false
local widget = require("widget")
local lunghezza =  display.contentWidth
local altezza = lunghezza*(9/16)

--Mosse e descrizione
local backgroundGroup
local textGroup
local midGroup
local testoMossa
local mossa1
local mossa2
local mossa3
local mossa4

--Game objects
local character
local numeroMossa
local chanceRandom
local totChance
local attackRandom
local totAttacco
local enemyImage
local enemy = {life = 250, armor = 2, damage = 50, speed = 10}

local lifeBarCharacter
local lifeBarCharacterBlack
local lifeBarEnemy
local lifeBarEnemyBlack

--Physics (necessaria per il movimento del personaggio(attacco e difesa))
local physics = require("physics")
physics.start()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function infoMossa1()
	numeroMossa = 1
  testoMossa.text = "Pugno : Stordisci il tuo avversario \nDamage = 60%\nHit chance = 20%\n"
end

local function infoMossa2()
	numeroMossa = 2
  testoMossa.text = "Mossa2 : Questa mossa ti fa il caffè\nAttacco = 30%\nDifesa = 50%\nVelocità = 80%"
end

local function infoMossa3()
	numeroMossa = 3
  testoMossa.text = "Mossa3 : Questa mossa ti fa accarezzare il gatto di titto\nAttacco = 20%\nDifesa = 90%\nVelocità = 60%"
end

local function infoMossa4()
	numeroMossa = 4
  testoMossa.text = "Mossa4 : Questa mossa genera gettere & settere\nAttacco = 20%\nDifesa = 50%\nVelocità = 20%"
end


local function eseguiMossa()
	if(numeroMossa == 1) then
	chanceRandom = math.random(1, 6)
	totChance = chanceRandom + mossa1.hitChance
	end

	if(totChance > enemy.armor) then
		attackRandom = math.random(1, 30)
		totAttacco = (attackRandom + character.damage) * mossa1.damage

		if(enemy.life > totAttacco) then
			--Rapporto dei pixel della barra con i punti vita, per poter convertire il danno in pixel da 'levare'
			local rapporto = lifeBarEnemy.width / enemy.life
			local x = totAttacco * rapporto		--Pixel dal levare

			enemy.life = enemy.life - totAttacco
			lifeBarEnemy.width = lifeBarEnemy.width - x
			lifeBarEnemy.x = lifeBarEnemy.x - x/2
		else --Danno > vita => nemico morto
			enemy.life = 0
			display.remove( lifeBarEnemy )
		end
	end
end

-- create()
function scene:create( event )

	local sceneGroup = self.view

	backgroundGroup = display.newGroup()
	sceneGroup:insert(backgroundGroup)

	textGroup = display.newGroup()
	sceneGroup:insert(textGroup)

	midGroup = display.newGroup()
	sceneGroup:insert(midGroup)

	-- Code here runs when the scene is first created but has not yet appeared on screen

--****************BACKGROUND GROUP********************************

 local background = display.newImageRect( backgroundGroup, "Images/Backgrounds/proceduralBack/Stanze/back1.jpg", 1280, 720 )
 background.x = display.contentCenterX
 background.y = display.contentCenterY - 200

 local underBar = display.newImageRect( backgroundGroup, "Images/Backgrounds/FightBar.png", 1280, 720)
 underBar.x = display.contentCenterX
 underBar.y = display.contentCenterY

 --*******************TEXT GROUP************************************

 testoMossa = display.newText( textGroup, "" ,1050, 585, 450, 0, native.systemFont, 20 )
 testoMossa:setFillColor( 1, 1, 1 )

 mossa1 = display.newText( textGroup, "Mossa1", 200, 515, native.systemFont, 50 )
 mossa1.hitChance = 5
 mossa1.damage = 1
 mossa1:setFillColor( 0.82, 0.86, 1 )

 mossa2 = display.newText( textGroup, "Mossa2", 560, 515, native.systemFont, 50 )
 mossa2.hitChance = 2
 mossa2.damage = 20
 mossa2:setFillColor( 0.82, 0.86, 1 )

 mossa3 = display.newText( textGroup, "Mossa3", 200, 650, native.systemFont, 50 )
 mossa3.hitChance = 3
 mossa3.damage = 30
 mossa3:setFillColor( 0.82, 0.86, 1 )

 mossa4 = display.newText( textGroup, "Mossa4", 560, 650, native.systemFont, 50 )
 mossa4.hitChance = 4
 mossa4.damage = 40
 mossa4:setFillColor( 0.82, 0.86, 1 )

 mossa1:addEventListener( "tap", infoMossa1 )
 mossa2:addEventListener( "tap", infoMossa2 )
 mossa3:addEventListener( "tap", infoMossa3 )
 mossa4:addEventListener( "tap", infoMossa4 )

		--*************MID GROUP*************************************************

		--Displaying character
	  character = characterInterface.creaPersonaggio(self)
		midGroup:insert(character)
		character.x = display.contentCenterX - 250
		character.y = display.contentCenterY + 100
		lifeBarCharacterBlack = display.newImageRect( midGroup, "Images/Utility/lifeBarBlack.png", 200, 200 )
		lifeBarCharacterBlack.x = display.contentCenterX - 250
		lifeBarCharacterBlack.y = display.contentCenterY - 250
		lifeBarCharacter = display.newImageRect( midGroup, "Images/Utility/lifeBarGreen.png", 200, 200 )
		lifeBarCharacter.x = display.contentCenterX - 250
		lifeBarCharacter.y = display.contentCenterY - 250


		--Displaying enemy
	  enemyImage = display.newImageRect( midGroup, "Images/Characters/joker.png", 200, 200)
		enemyImage.x = display.contentCenterX + 250
		enemyImage.y = display.contentCenterY
		lifeBarEnemyBlack = display.newImageRect( midGroup, "Images/Utility/lifeBarBlack.png", 200, 200 )
		lifeBarEnemyBlack.x = display.contentCenterX + 250
		lifeBarEnemyBlack.y = display.contentCenterY - 250
		lifeBarEnemy = display.newImageRect( midGroup, "Images/Utility/lifeBarGreen.png", 200, 200 )
		lifeBarEnemy.x = display.contentCenterX + 250
		lifeBarEnemy.y = display.contentCenterY - 250

		enemyImage:addEventListener("tap", eseguiMossa)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
    -- audio.play( menuTrack, {channel =1 , loops = -1})
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
    -- Stop the music!

	end
end


-- destroy()
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
