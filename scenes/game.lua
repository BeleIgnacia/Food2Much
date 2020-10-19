local composer = require('composer')
local physics = require( "physics" )

local scene = composer.newScene( )

local backGroup
local mainGroup
local uiGroup

local score
local scoreText
local player_x
local player_y
local player_size
local spawn_x
local spawn_y
local player_no_comer
local player_comer
local background
local platform
local game_timer
local time

local initialDelay
local timeText

-- Utils
local function circleSwap( event )
	if (mainGroup[1].isVisible == true) then
		-- Si azul se ve cambio a verde
		mainGroup[1].isVisible = false
		mainGroup[2].isVisible = true
	else
		-- Si verde se ve cambio a azul
		mainGroup[1].isVisible = true
		mainGroup[2].isVisible = false
	end
end

local function launchBall( )
	local rand = math.random( 1, 10 )
	local ball
	-- Si es mayor a 2 genera una blanca
	if (rand > 2 ) then
		ball = display.newImageRect( mainGroup, "/images/meat.png", player_size/2, player_size/2 )
		ball.myName = "white"
	else
		ball = display.newImageRect( mainGroup, "/images/bomb.png", player_size/2, player_size/2 )
		ball.myName = "gold"
	end
	ball.x, ball.y = spawn_x, spawn_y
	-- Añade fisicas a la pelota
	physics.addBody( ball, "dynamic" )
	-- Lanzamiento parabolico --
	rand = math.random( 1, 10 )
	if (rand > 2) then
		-- Define la transición de la pelota al jugador
		-- https://docs.coronalabs.com/api/library/easing/index.html
		transition.to( ball, { 
			time=1000, 
			transition=easing.linear, 
			x=player_x, 
			--y=player_y 
		} )
		-- Define la fuerza del impulso y la aplica
		ball:applyLinearImpulse( 0, -0.02, ball.x, ball.y )
	-- Lanzamiento directo --
	else
		transition.to( ball, { 
			time=1000, 
			transition=easing.inOutExpo, 
			x=player_x,
			y=player_y 
		} )
	end
end

-- Aumenta el contador de puntaje
local function aumentarContador( )
	score = score + 1
    scoreText.text = score
end

-- Colisiones
local function onCollision( self, event )
	-- Caso en la pelota sea verde o azul
	if (self.isVisible == true) then
		if (event.other.myName == "white") then
			aumentarContador( )
			display.remove( event.other )
		else
			display.remove( event.other )
			game_dead( )
		end
	else
		event.other:applyLinearImpulse( 0.05, -0.08, event.other.x, event.other.y )
		local borrarPelota = function() display.remove( event.other ) end
		timer.performWithDelay( 1500, borrarPelota )
	end
end

local function contadorInicial( )
	time = time - 1
	timeText.text = time
	if (time > 0) then
		timeText.isVisible = true
	elseif (time == 0) then
		timeText.text = "START"
	else
		display.remove( timeText )
		game_start( )
	end
end

function game_start( )
	print( "comienza el juego" )
	timer.cancel( initialDelay )
	game_timer = timer.performWithDelay( 800, launchBall , 20 )
end

function game_dead(  )
	timer.cancel( game_timer )
	display.remove( player_comer )
	display.remove( player_no_comer )
	local player_mal_comer = display.newImageRect( mainGroup, "/images/mal_comer.png", player_size, player_size )
	player_mal_comer.x, player_mal_comer.y = player_x, player_y
	timer.performWithDelay( 2000, game_over )
end

function game_over( )
	-- Limpieza de pantalla
	backGroup:removeSelf( )
	mainGroup:removeSelf( )
	uiGroup:removeSelf( )
	backGroup = display.newGroup( )
	mainGroup = display.newGroup( )
	uiGroup = display.newGroup( )
	-- Fondo
	background = display.newRect( backGroup, 0, 0, display_w, display_h )
	background.x = center_x
	background.y = center_y
	background.fill = {
		type = 'gradient',
		color1 = {0.2, 0.45, 0.8},
		color2 = {0.7, 0.8, 1}
	}
	-- Rostro infeliz
	player_gameover = display.newImageRect( mainGroup, "/images/gameover_face.png", player_size+50, player_size+50 )
	player_gameover.x, player_gameover.y = center_x, center_y
	-- Texto de gameover
	gameoverText = display.newText( uiGroup, "Game Over!", center_x, 60, "/fonts/unbutton.ttf", 40 )
	gameoverText:setFillColor( 0, 0, 0 )
end

-- Scene

function scene:create( )
	-- Grupos a mostrar, esto ayuda a organizar los objetos
	backGroup = display.newGroup( )
	mainGroup = display.newGroup( )
	uiGroup = display.newGroup( )
	-- Fisicas de colisión
	physics.start()
	-- Puntaje
	score = 0
	scoreText = display.newText( score, center_x, 60, "fonts/unbutton.ttf", 40)
	scoreText:setFillColor( 0, 0, 0 )
	-- Ubicación de personaje
	player_x = display.actualContentWidth-200
	player_y = display.actualContentHeight-35
	player_size = 80
	-- Punto de Spawn
	spawn_x = 40
	spawn_y = 90
	-- Imagenes para swapear personaje
	player_no_comer = display.newImageRect( mainGroup, "/images/no_comer.png", player_size, player_size )
	player_no_comer.x = player_x
	player_no_comer.y = player_y
	player_comer = display.newImageRect( mainGroup, "/images/comer.png", player_size, player_size )
	player_comer.x = player_x
	player_comer.y = player_y
	player_comer.isVisible = false
	-- Fondo
	background = display.newImageRect( backGroup, "/images/background.png", display.contentWidth, display.contentHeight+120 )
	background.x = center_x
	background.y = center_y
	-- Plataforma inferior
	platform = display.newRect( mainGroup, center_x, center_y, display.actualContentWidth, 80 )
	platform.y = display.actualContentHeight+45
	platform.isVisible = false
	-- Swap
	player_no_comer:addEventListener( "tap", circleSwap )
	player_comer:addEventListener( "tap", circleSwap )
	-- Colisiones
	player_comer.collision = onCollision
	player_comer:addEventListener( "collision" )
	physics.addBody( platform, "static" )
	physics.addBody( player_comer, "static" )
	-- Delay antes de comenzar
	time = 4
	timeText = display.newText( time, center_x, center_y-20, "fonts/unbutton.ttf", 100)
	timeText:setFillColor( 0, 0, 0 )
	initialDelay = timer.performWithDelay( 1000, contadorInicial, 5)
end

function scene:show(event)

end

function scene:eachFrame()

end

function scene:setIsPaused(isPaused)

end

function scene:endLevelCheck()

end

function scene:createTouchRect(params)

end

function scene:gotoPreviousScene()
	native.showAlert('Alerta', 'Realmente desea salir de este nivel?', {'Yes', 'Cancel'}, function(event)
		if event.action == 'clicked' and event.index == 1 then
			composer.gotoScene('scenes.menu', {time = 500, effect = 'slideRight'})
		end
	end)
end

function scene:hide( event )

end

scene:addEventListener( 'create' )
scene:addEventListener( 'show' )
scene:addEventListener( 'hide' )

return scene
