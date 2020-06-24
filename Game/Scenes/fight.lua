-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local characterInterface = require("characterInterface")
local enemyInterface = require("enemyInterface")

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
local textDamage
local textDamageEnemy
local turnoText
local character = characterInterface.creaPersonaggio(self)
local enemy = enemyInterface.createEnemy(self)
local turno
local sommaChance = 0

--Game objects
local numeroMossa
local chanceRandom
local totChance
local attackRandom
local totAttacco

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



local function turnEnemy()
	chanceRandom = math.random(1, 6)
	while(chanceRandom == 6) do
		sommaChance = sommaChance + chanceRandom
		chanceRandom = math.random(1, 6)
	end
		sommaChance = sommaChance + chanceRandom

	totChance = chanceRandom + sommaChance + 2000 -- mossa.hitChance
		if(totChance > character.armor) then
		attackRandom = math.random(1, 30)
		totAttacco = (attackRandom + enemy.damage) * 20 --mossa.damage
		textDamageEnemy.text = totAttacco
		local function removeText()
				textDamageEnemy.alpha = 0
		end
		timer.performWithDelay(1000, removeText)
		if(character.life > totAttacco) then
			--Rapporto dei pixel della barra con i punti vita, per poter convertire il danno in pixel da 'levare'
			local rapporto = lifeBarCharacter.width / character.life
			local x = totAttacco * rapporto		--Pixel dal levare

			character.life = character.life - totAttacco
			lifeBarCharacter.width = lifeBarCharacter.width - x
			lifeBarCharacter.x = lifeBarCharacter.x - x/2
		else --Danno > vita => nemico morto
			character.life = 0
			display.remove( lifeBarCharacter )
			end
		end
		if(character.life > 0) then
		local function changeText()
		turnoText.text = "Il tuo turno"
		end
		timer.performWithDelay( 2000, changeText)
		timer.performWithDelay(5000, eseguiMossa)
		timer.performWithDelay(5000, addTasto)
		textDamageEnemy.alpha = 1

		end
end



local function gameLoop()
if(enemy.speed < character.speed) then
	turnoText.text = "Il tuo turno"
	turno = "personaggio"
else
	turno = "nemico"
	 turnEnemy()
	end
end



local function infoMossa1()
  numeroMossa = 1
  testoMossa.text = character.testoMossa1
end

local function infoMossa2()
	numeroMossa = 2
	testoMossa.text = character.testoMossa2
end

local function infoMossa3()
	numeroMossa = 3
	testoMossa.text = character.testoMossa3
end

local function infoMossa4()
	numeroMossa = 4
	testoMossa.text = character.testoMossa4
end


local function eseguiMossa()

	if(turno == "personaggio") then

	if(numeroMossa == 1) then
		chanceRandom = math.random(1, 6)
		while(chanceRandom == 6) do
			sommaChance = sommaChance + chanceRandom
			chanceRandom = math.random(1, 6)
		end
			sommaChance = sommaChance + chanceRandom

	totChance = chanceRandom + sommaChance + character.mossa1.hitChance

	if(totChance > enemy.armor) then
		attackRandom = math.random(1, 30)
		totAttacco = (attackRandom + character.damage) * character.mossa1.damage
		textDamage.text = totAttacco
		local function removeText()
			textDamage.alpha = 0
	  end
	  timer.performWithDelay(1000, removeText)

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


	if(numeroMossa == 2) then
			chanceRandom = math.random(1, 6)
			while(chanceRandom == 6) do
				sommaChance = sommaChance + chanceRandom
				chanceRandom = math.random(1, 6)
			end
				sommaChance = sommaChance + chanceRandom

		totChance = chanceRandom + sommaChance + character.mossa2.hitChance

	if(totChance > enemy.armor) then
		attackRandom = math.random(1, 30)
		totAttacco = (attackRandom + character.damage) * character.mossa2.damage
		textDamage.text = totAttacco
		local function removeText()
			textDamage.alpha = 0
	  end
	  timer.performWithDelay(1000, removeText)

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


	if(numeroMossa == 3) then
			chanceRandom = math.random(1, 6)
			while(chanceRandom == 6) do
				sommaChance = sommaChance + chanceRandom
				chanceRandom = math.random(1, 6)
			end
				sommaChance = sommaChance + chanceRandom

		totChance = chanceRandom + sommaChance + character.mossa3.hitChance

	if(totChance > enemy.armor) then
		attackRandom = math.random(1, 30)
		totAttacco = (attackRandom + character.damage) * character.mossa3.damage
		textDamage.text = totAttacco
		local function removeText()
			textDamage.alpha = 0
	  end
	  timer.performWithDelay(1000, removeText)

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


	if(numeroMossa == 4) then
			chanceRandom = math.random(1, 6)
			while(chanceRandom == 6) do
				sommaChance = sommaChance + chanceRandom
				chanceRandom = math.random(1, 6)
			end
				sommaChance = sommaChance + chanceRandom

		totChance = chanceRandom + sommaChance + character.mossa4.hitChance

	if(totChance > enemy.armor) then
		attackRandom = math.random(1, 30)
		totAttacco = (attackRandom + character.damage) * character.mossa4.damage
		textDamage.text = totAttacco
		local function removeText()
	  		textDamage.alpha = 0
	  end
	  timer.performWithDelay(1000, removeText)

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

if(enemy.life > 0) then
local function changeTextAvv()
turnoText.text = "Turno avversario"
end
timer.performWithDelay( 2000, changeTextAvv)
timer.performWithDelay(5000, turnEnemy)
textDamage.alpha = 1
enemy:removeEventListener("tap", eseguiMossa)

end

end

end

function addTasto()
	enemy:addEventListener("tap", eseguiMossa)
end


-- create()
function scene:create ( event )

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

 mossa1 = display.newText( textGroup, "" , 200, 515, native.systemFont, 50 )
 mossa1:setFillColor( 0.82, 0.86, 1 )


 mossa2 = display.newText( textGroup, "", 560, 515, native.systemFont, 50 )
 mossa2:setFillColor( 0.82, 0.86, 1 )

 mossa3 = display.newText( textGroup, "", 200, 650, native.systemFont, 50 )
 mossa3:setFillColor( 0.82, 0.86, 1 )

 mossa4 = display.newText( textGroup, "", 560, 650, native.systemFont, 50 )
 mossa4:setFillColor( 0.82, 0.86, 1 )

 mossa1:addEventListener( "tap", infoMossa1 )
 mossa2:addEventListener( "tap", infoMossa2 )
 mossa3:addEventListener( "tap", infoMossa3 )
 mossa4:addEventListener( "tap", infoMossa4 )

 textDamage = display.newText(textGroup, "", 800, 200, native.systemFont, 50)
 textDamage:setFillColor(1, 0, 0)

 textDamageEnemy = display.newText(textGroup, "", 500, 200, native.systemFont, 50)
 textDamageEnemy:setFillColor(1, 0, 0)

 turnoText = display.newText(textGroup, "", 600, 50, native.systemFont, 50)
 turnoText:setFillColor(1, 0, 1)

		--*************MID GROUP*************************************************

		--Displaying character
		midGroup:insert(character)
		character.x = display.contentCenterX - 250
		character.y = display.contentCenterY + 100
		lifeBarCharacterBlack = display.newImageRect( midGroup, "Images/Utility/lifeBarBlack.png", 200, 200 )
		lifeBarCharacterBlack.x = display.contentCenterX - 250
		lifeBarCharacterBlack.y = display.contentCenterY - 250
		lifeBarCharacter = display.newImageRect( midGroup, "Images/Utility/lifeBarGreen.png", 200, 200 )
		lifeBarCharacter.x = display.contentCenterX - 250
		lifeBarCharacter.y = display.contentCenterY - 250
		mossa1.text = character.nomeMossa1
		mossa2.text = character.nomeMossa2
		mossa3.text = character.nomeMossa3
		mossa4.text = character.nomeMossa4



		--Displaying enemy
		midGroup:insert(enemy)
		lifeBarEnemyBlack = display.newImageRect( midGroup, "Images/Utility/lifeBarBlack.png", 200, 200 )
		lifeBarEnemyBlack.x = display.contentCenterX + 250
		lifeBarEnemyBlack.y = display.contentCenterY - 250
		lifeBarEnemy = display.newImageRect( midGroup, "Images/Utility/lifeBarGreen.png", 200, 200 )
		lifeBarEnemy.x = display.contentCenterX + 250
		lifeBarEnemy.y = display.contentCenterY - 250
		enemy:addEventListener("tap", eseguiMossa)

		gameLoop()
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
