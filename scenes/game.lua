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

function scene:create( )
	-- Grupos a mostrar, esto ayuda a organizar los objetos
	backGroup = display.newGroup( )
	mainGroup = display.newGroup( )
	uiGroup = display.newGroup( )
	-- Fisicas de colisión
	physics.start()
	-- Puntaje
	score = 0
	scoreText = display.newText( score, center_x, 60, native.systemFont, 40)
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
