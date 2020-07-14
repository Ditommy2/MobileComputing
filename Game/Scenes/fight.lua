-----------------------------------------------------------------------------------------
--
-- fight.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local characterInterface = require("characterInterface")
local interfaccia = require("interfaceConfig")
local enemyInterface = require("enemyInterface")
local fileHandler = require("fileHandler")
local customFont="MadnessHyperactive.otf"
local scene = composer.newScene()
local widget = require("widget")
local lunghezza =  display.contentWidth
local altezza = lunghezza*(9/16)
local fileHandler = require("fileHandler")
local fightTrack = audio.loadStream( "audio/fight/Ancient-Game-Open.mp3")


--Scenes
local backgroundGroup
local textGroup
local midGroup

--Mosse e descrizione
local testoMossa
local mossa1
local mossa2
local mossa3
local mossa4
local textDamage
local textDamageEnemy
local fightText

--Game objects
local character = characterInterface.creaPersonaggio(self)
character["stunned"] = 0
local startingStats = {
	speed = character.speed,
	armor = character.armor,
	damage = character.damage
}
local punteggioPartita = 0
-- local enemy1 = enemyInterface.createEnemy(self, stanzaCorrente.nemici[1])
local enemy1
local numeroMossa
local chanceRandom
local totChance
local attackRandom
local totAttacco
local sommaChance = 0
local turno
local turnoHourglass
-- local enemy = stanzaCorrente.nemici[1]
local enemy

--Life bar
local lifeBarCharacter
local lifeBarCharacterBlack
local lifeBarEnemy
local lifeBarEnemyBlack

--Physics (necessaria per il movimento del personaggio(attacco e difesa))
local physics = require("physics")
physics.start()

-- local function saveScore()
-- 	local score = composer.getVariable( "score" )
-- 	local user = composer.getVariable( "username" )
-- 	local game = composer.getVariable( "nomePartita" )
-- 	local stringaScores = "saveScore".."$$"..".json"
-- 	local tabellonePunteggi= fileHandler.loadTableScores(stringaScores)
-- 	if(tabellonePunteggi == nil) then
--     print("primoSalvataggio")
--     tabellonePunteggi = {}
--     -- table.insert(tabellonePunteggi, score .. "               " .. user .. "               " .. partita .. "\n")
--     table.insert(tabellonePunteggi, {punteggio=score, utente=user, partita=game})
--   else
--     print("seguenti salvataggi")
--     -- table.insert(tabellonePunteggi, score .. "               " .. user .. "               " .. partita .. "\n")
--     table.insert(tabellonePunteggi, {punteggio=score, utente=user, partita=game})
--   end
--
-- 	fileHandler.saveTable(tabellonePunteggi, stringaScores)
-- 	fileHandler.caricaSave(tabellonePunteggi, stringaScores)
-- end

-- -----------------------------------------------------------------------------------
-- Fine combattimento
-- -----------------------------------------------------------------------------------
local function gotoNuovaCarica()
	audio.stop( 2 )
	audio.stop( 3 )
	-- composer.setVariable( "characterLife", character.life )
	composer.removeScene( "Scenes.fight" )
	composer.gotoScene( "Scenes.nuovaCarica", {time=800, effect="crossFade"} )
end

local function gotoLivello1()
	audio.stop( 3 )
	audio.play( gameTrack, {channel =2 , loops = -1})
	composer.setVariable( "characterLife", character.life )
	composer.removeScene( "Scenes.fight" )
	composer.setVariable("endFight", "true")
	composer.setVariable( "enemyX", enemy1.x )
	composer.setVariable( "enemyY", enemy1.y )
	composer.setVariable( "tabDrop", enemy1.drop )
	-- composer.setVariable( "drop", true )
	composer.gotoScene( "Scenes.livello1", {time=800, effect="crossFade"} )
end

-- -----------------------------------------------------------------------------------
-- Gestione turno nemico
-- -----------------------------------------------------------------------------------
local function turnEnemy()
	local mossa = "mossa" .. 4--math.random(1, 4)
	print("statistiche enemy e enemy1:\n"..enemy.armor..", "..enemy1.armor.."\n"..enemy.life..", "..enemy1.life.."\n"..enemy.damage..", "..enemy1.damage)
	if enemy1.stunned == 0 then
		chanceRandom = math.random(1, 6)
		local criticalEffect = {target="false"}
		while(chanceRandom == 6) do --==6
			sommaChance = sommaChance + chanceRandom
			chanceRandom = math.random(1, 6)
			criticalEffect = enemy[mossa].effect
		end
		sommaChance = sommaChance + chanceRandom

		totChance = sommaChance + enemy[mossa].hitChance

		if(totChance > character.armor) then
			enemyInterface.attacca(enemy1)

			if not(criticalEffect.target == "false") then
				print("effetto critico aplicato : "..criticalEffect.target..", "..criticalEffect.value)
				fightText.alpha = 1
				fightText.x = 250
				fightText.text = "Critical Hit!"
			else

				fightText.alpha = 1
				fightText.x = 250
				fightText.text = "Hit!"


			end
			timer.performWithDelay( 1500, removeTextFight )
			characterInterface.esegui(5, character)
			attackRandom = math.random(1, 50)
			totAttacco = (attackRandom + enemy1.damage) * enemy[mossa].damage

			local attacco, resto = math.modf(totAttacco)
			textDamageEnemy.text = attacco
			textDamageEnemy.alpha = 1
			timer.performWithDelay(1500, removeTextDamageEnemy)

			if not(criticalEffect.target == "false") then
				local app = character[criticalEffect.target]
				character[criticalEffect.target] = app + criticalEffect.value

			end
			if(character.life > attacco) then
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

		else
			fightText.alpha = 1
			fightText.x = 250
			fightText.text = "Missed!"
			timer.performWithDelay( 1500, removeTextFight )
		end

	else
		fightText.alpha = 1
		fightText.x = 1000
		fightText.text = "Stunned!"
		timer.performWithDelay( 1500, removeTextFight )
		enemy1.stunned = 0
	end

	if(character.life > 0) then
		timer.performWithDelay( 1500, changeStarTuo)
		--timer.performWithDelay(3000, eseguiMossa)
		if character["stunned"]==0 then
			timer.performWithDelay(3000, addTasto)
		else
			local function stunnedCharacterFunction()
				fightText.alpha = 1
				fightText.x = 250
				fightText.text = "Stunned!"
				timer.performWithDelay( 1500, removeTextFight )
				enemy1.stunned = 0
				character["stunned"]=0
				timer.performWithDelay( 1000, changeStarAvv)
				timer.performWithDelay(3000, turnEnemy)
			end
			timer.performWithDelay( 3100, stunnedCharacterFunction )
		end
	else
		characterInterface.gameOver(textGroup)
		fightText:setFillColor(0, 0, 0)
		-- saveScore(punteggioPartita)
		-- timer.performWithDelay( 5000, gotoNuovaCarica )
	end

end

-- -----------------------------------------------------------------------------------
-- Gestione elementi dinamici durante il combattimento
-- -----------------------------------------------------------------------------------
function changeStarAvv()
	transition.to( turnoHourglass , { time=1500, alpha=1, x=890, y=250 } )
end

function changeStarTuo()
	transition.to( turnoHourglass , { time=1500, alpha=1, x=380, y=250 } )
end

function removeTextDamageEnemy()
	textDamageEnemy.alpha = 0
end

function removeTextFight()
	fightText.alpha = 0
end

function removeTextDamageCharacter()
	textDamage.alpha = 0
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

-- -----------------------------------------------------------------------------------
-- Assegna il primo turno
-- -----------------------------------------------------------------------------------
local function gameLoop()
	if((enemy.speed + math.random(1, 6)) < (character.speed + math.random(1, 6))) then
		transition.to( turnoHourglass , { time=4000, alpha=1, x=380, y=250 } )
		turno = "personaggio"
	else
		transition.to( turnoHourglass , { time=4000, alpha=1, x=890, y=250 } )
		turno = "nemico"
		timer.performWithDelay( 4000, turnEnemy )
	end
end

-- ------------------------------------------------------------------------------------
-- Calcola il danno di una mossa del personaggio
-- ------------------------------------------------------------------------------------
local function calcolaDanno()
	local mossa = "mossa" .. numeroMossa	--Prendo la mossa
	local criticalEffect = {target = "false"}
	--Vedo se colpisco il nemico
	chanceRandom = math.random(1, 6)
	while(chanceRandom == 6) do  --(chanceRandom == 6)
		sommaChance = sommaChance + chanceRandom
		chanceRandom = math.random(1, 6)
		criticalEffect = character[mossa].effect
	end

	sommaChance = sommaChance + chanceRandom + character[mossa].hitChance

	--Ho colpito il nemico
	if(sommaChance > enemy1.armor) then

		if not(criticalEffect.target == "false") then
			print("effetto critico aplicato : "..criticalEffect.target..", "..criticalEffect.value)
			fightText.alpha = 1
			fightText.x = 1000
			fightText.text = "Critical Hit!"
		else
			fightText.alpha = 1
			fightText.x = 1000
			fightText.text = "Hit!"
		end
		timer.performWithDelay( 1500, removeTextFight )

		attackRandom = math.random(1, 50)
		totAttacco = (attackRandom + character.damage) * character[mossa].damage

		local attacco, resto = math.modf(totAttacco)
		textDamage.text = attacco
		timer.performWithDelay(1500, removeTextDamageCharacter)

		if not(criticalEffect.target == "false") then
			local app = enemy1[criticalEffect.target]
			enemy1[criticalEffect.target] = app + criticalEffect.value
		end

		if(enemy1.life > attacco) then
			--Rapporto dei pixel della barra con i punti vita, per poter convertire il danno in pixel da 'levare'
			local rapporto = lifeBarEnemy.width / enemy1.life
			local y = totAttacco * rapporto		--Pixel dal levare
			local x, z = math.modf(y)

			enemy1.life = enemy1.life - totAttacco
			lifeBarEnemy.width = lifeBarEnemy.width - x
			lifeBarEnemy.x = lifeBarEnemy.x - x/2
		else --Danno > vita => nemico morto
			enemy1.life = 0
			display.remove( lifeBarEnemy )
			punteggioPartita = composer.getVariable("score") + enemy.points
			composer.setVariable( "score", punteggioPartita )

			local nemici = composer.getVariable( "nemici" )
			local stanzaCorrente = composer.getVariable( "stanzaCorrente" )

			print("stanza corrente: " ..  stanzaCorrente.TESTO)
			for i=1, #nemici, 1 do
				if(stanzaCorrente.TESTO == nemici[i].id) then
					table.remove( nemici, i )
					print("rimosso nemico numero: " ..  i)
					break
				end
			end

			character.speed = startingStats.speed
			character.armor = startingStats.armor
			character.damage = startingStats.damage
		end
	else
		fightText.alpha = 1
		fightText.x = 1000
		fightText.text = "Missed!"
		timer.performWithDelay( 1500, removeTextFight )
	end
end

-- -----------------------------------------------------------------------------------
-- Gestione turno personaggio
-- -----------------------------------------------------------------------------------
local function eseguiMossa()
	local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
	print("statistiche del personaggio (armor, life, damage): \n"..character.armor.."\n"..character.life.."\n"..character.damage.."\n"..character.stunned)
		if(not(numeroMossa==nil)) then
			if(turno == "personaggio") then
				calcolaDanno()
				characterInterface.esegui(numeroMossa, character)
				if(enemy1.life > 0) then
					turno = "nemico"
					timer.performWithDelay( 1000, changeStarAvv)
					timer.performWithDelay(3000, turnEnemy)
					textDamage.alpha = 1
					enemy1:removeEventListener("tap", eseguiMossa)
				else
					composer.setVariable( "damageBuff", 0 )
					composer.setVariable( "speedBuff", 0)
					enemy1:removeEventListener("tap", eseguiMossa)
					transition.to( enemy1 , { time=3000, alpha=0 } )
					stanzaCorrente.nemici[1] = nil
					composer.setVariable( "stanzaCorrente", stanzaCorrente )
					timer.performWithDelay( 5000, gotoLivello1 )
				end
			end
		end


end

function addTasto()
	enemy1:addEventListener("tap", eseguiMossa)
	turno = "personaggio"
end

-- -----------------------------------------------------------------------------------
-- create
-- -----------------------------------------------------------------------------------
function scene:create ( event )
	local sceneGroup = self.view
	local stanzaCorrente = composer.getVariable( "stanzaCorrente" )
	enemy = stanzaCorrente.nemici[1]

	backgroundGroup = display.newGroup()
	sceneGroup:insert(backgroundGroup)

	textGroup = display.newGroup()
	sceneGroup:insert(textGroup)

	midGroup = display.newGroup()
	sceneGroup:insert(midGroup)

	-- Code here runs when the scene is first created but has not yet appeared on screen

	--****************BACKGROUND GROUP********************************

	local numero = stanzaCorrente.seedBackground
	local background = display.newImageRect( backgroundGroup, "Images/Backgrounds/proceduralBack/Stanze/back"..numero..".png", 1280, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY - 200

	local underBar = display.newImageRect( backgroundGroup, "Images/Backgrounds/FightBar.png", 1280, 720)
	underBar.x = display.contentCenterX
	underBar.y = display.contentCenterY

	--*******************TEXT GROUP************************************

	testoMossa = display.newText( textGroup, "" ,1050, 600, 450, 0, native.newFont( customFont), 30 )
	testoMossa:setFillColor( 255,255,255 )

	mossa1 = display.newText( textGroup, "" , 200, 515, native.newFont( customFont), 50 )
	mossa1:setFillColor( 255,255,255 )


	mossa2 = display.newText( textGroup, "", 560, 515, native.newFont( customFont), 50 )
	mossa2:setFillColor( 255,255,255 )

	mossa3 = display.newText( textGroup, "", 200, 650, native.newFont( customFont), 50 )
	mossa3:setFillColor( 255,255,255 )

	mossa4 = display.newText( textGroup, "", 560, 650, native.newFont( customFont), 50 )
	mossa4:setFillColor( 255,255,255 )

	mossa1:addEventListener( "tap", infoMossa1 )
	mossa2:addEventListener( "tap", infoMossa2 )
	mossa3:addEventListener( "tap", infoMossa3 )
	mossa4:addEventListener( "tap", infoMossa4 )

	textDamage = display.newText(textGroup, "", 800, 200, native.newFont( customFont), 100)
	textDamage:setFillColor(1, 0, 0)

	textDamageEnemy = display.newText(textGroup, "", 500, 200, native.newFont( customFont), 100)
	textDamageEnemy:setFillColor(1, 0, 0)

	turnoHourglass = display.newImageRect( midGroup, "Images/Icons/icons2/038-hourglass.png", 50, 50)
	turnoHourglass.x = 600
	turnoHourglass.alpha = 0

	fightText = display.newText(textGroup, "", 2500000, 250, native.newFont( customFont), 150)
	fightText:setFillColor(255, 153, 0)

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
	local rapporto = lifeBarCharacter.width / 3000
	local x = character.life*rapporto
	lifeBarCharacter.width = x
	x = 200 - x
	lifeBarCharacter.x = lifeBarCharacter.x - x/2
	mossa1.text = character.mossa1.nome
	mossa2.text = character.mossa2.nome
	mossa3.text = character.mossa3.nome
	mossa4.text = character.mossa4.nome

	--Displaying enemy
	enemy1 = enemyInterface.createEnemy(self, enemy)
	midGroup:insert(enemy1)
	enemy1.y = altezza - 260
	lifeBarEnemyBlack = display.newImageRect( midGroup, "Images/Utility/lifeBarBlack.png", 200, 200 )
	lifeBarEnemyBlack.x = display.contentCenterX + 250
	lifeBarEnemyBlack.y = display.contentCenterY - 250
	lifeBarEnemy = display.newImageRect( midGroup, "Images/Utility/lifeBarGreen.png", 200, 200 )
	lifeBarEnemy.x = display.contentCenterX + 250
	lifeBarEnemy.y = display.contentCenterY - 250
	enemy1:addEventListener("tap", eseguiMossa)
	enemy1.life = enemy.life
	enemy1.armor = enemy.armor
	enemy1.speed = enemy.speed
	enemy1.damage = enemy.damage
	enemy1.stunned = 0
	timer.performWithDelay(2000, gameLoop())
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.stop( 2 )
		audio.play( fightTrack, { channel=3, loops=-1 } )
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
	for i = sceneGroup.numChildren, 1, -1 do
		sceneGroup[i]:removeSelf()
		sceneGroup[i] = nil
	end
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
