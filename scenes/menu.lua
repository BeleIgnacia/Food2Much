local composer = require('composer')
local widget = require('widget')

local scene = composer.newScene( )

function scene:create( )
	local group = self.view
	local background = display.newRect( group, 0, 0, _G.display_w, _G.display_h )
	background.x = _G.center_x
	background.y = _G.center_y
	background.fill = {
		type = 'gradient',
		color1 = {0.2, 0.45, 0.8},
		color2 = {0.7, 0.8, 1}
	}
	local logo = display.newImageRect( group, 'images/logo.png', 220, 50 )
	logo.x = 140
	logo.y = 100
	local player = display.newImageRect( group, 'images/mal_comer.png', 80, 80 )
	player.x = 120
	player.y = 200
	local reverse = 0
	local function rotatePlayer( )
		if ( reverse == 0 ) then
        	reverse = 1
        	transition.to( player, { rotation=-30, time=800, transition=easing.inOutCubic } )
	    else
        	reverse = 0
        	transition.to( player, { rotation=30, time=800, transition=easing.inOutCubic } )
    	end
	end
	timer.performWithDelay( 600, rotatePlayer , 0 )
	local btnGroup = display.newGroup( )
	btnGroup.x, btnGroup.y = _G.center_x, _G.center_y
	group:insert( btnGroup )

	self.btnPlay = widget.newButton( {
		defaultFile = 'images/btn_play.png',
		overFile = 'images/btn_play_press.png',
		width = 64,
		height = 64,
		x = 400,
		y = 120,
		onRelease = function( )
			print( "play_btn" )
			composer.gotoScene('scenes.game', {time = 500, effect = 'slideLeft'})
		end
	} )

	self.btnConfig = widget.newButton( {
		defaultFile = 'images/btn_config.png',
		overFile = 'images/btn_config_press.png',
		width = 64,
		height = 64,
		x = 400,
		y = 200,
		onRelease = function( )
			print( "config_btn" )
			-- composer.gotoScene('scenes.config_menu', {time = 500, effect = 'slideLeft'})
		end
	} )

	group:insert( self.btnPlay )
	group:insert( self.btnConfig )
end

-- Presionar atrás en Android
function scene:gotoPreviousScene( )
	native.showAlert( 'Alerta', 'Realmente desea cerrar el juego?' , {'Yes', 'Cancel'}, function( event )
		if event.action == 'clicked' and event.index == 1 then
			native.requestExit( )
		end
	end )
end

function scene:show( event )
	if event.phase == 'did' then
		-- Tell tvOS that the menu button should be handled by the OS and exit the app
		system.activate('controllerUserInteraction')
	end
end

function scene:hide( event )
	if event.phase == 'will' then
		-- Take control over the menu button on tvOS
		system.deactivate('controllerUserInteraction')
	end
end

scene:addEventListener( 'create' )
scene:addEventListener( 'show' )
scene:addEventListener( 'hide' )

return scene
