local composer = require('composer')

local scene = composer.newScene( )

function scene:create( )

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
