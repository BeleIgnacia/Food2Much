-- Foo2Much --

-- Grupos a mostrar, esto ayuda a organizar los objetos
local backGroup = display.newGroup( )
local mainGroup = display.newGroup( )
local uiGroup = display.newGroup( )
-- Fisicas de colisión
local physics = require( "physics" )
physics.start()
-- Variables
local center_x = display.contentCenterX
local center_y = display.contentCenterY
-- Puntaje
local score = 0
local scoreText = display.newText( score, center_x, 60, native.systemFont, 40)
-- Ubicación de personaje
local player_x = display.actualContentWidth-200
local player_y = display.actualContentHeight-35
local player_size = 80
-- Punto de spawn
local spawn_x = 40
local spawn_y = 90
-- Imagenes para swapear personaje
local player_no_comer = display.newImageRect( mainGroup, "/images/no_comer.png", player_size, player_size )
player_no_comer.x = player_x
player_no_comer.y = player_y
local player_comer = display.newImageRect( mainGroup, "/images/comer.png", player_size, player_size )
player_comer.x = player_x
player_comer.y = player_y
player_comer.isVisible = false
-- Fondo
local background = display.newImageRect( backGroup, "/images/background.png", display.contentWidth, display.contentHeight+120 )
background.x = center_x
background.y = center_y
-- Plataforma inferior
local platform = display.newRect( mainGroup, center_x, center_y, display.actualContentWidth, 80 )
platform.y = display.actualContentHeight+45
platform.isVisible = false
-- Timer utilizado durante la partida
local game_timer

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

player_no_comer:addEventListener( "tap", circleSwap )
player_comer:addEventListener( "tap", circleSwap )

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

player_comer.collision = onCollision
player_comer:addEventListener( "collision" )

physics.addBody( platform, "static" )
physics.addBody( player_comer, "static" )




local time = 4
local timeText = display.newText( time, center_x, center_y, native.systemFont, 100)
timeText.isVisible = false

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

-- Delay antes de comenzar
local initialDelay = timer.performWithDelay( 1000, contadorInicial, 5)

function game_start( )
	timer.cancel( initialDelay )
	game_timer = timer.performWithDelay( 800, launchBall , 20 )
end

function game_dead(  )
	timer.cancel( game_timer )
	display.remove( player_comer )
	display.remove( player_no_comer )
	local player_mal_comer = display.newImageRect( mainGroup, "/images/mal_comer.png", player_size, player_size )
	player_mal_comer.x, player_mal_comer.y = player_x, player_y
end



--timer.performWithDelay( 500, launchBall, 20)