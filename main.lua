system.activate( 'multitouch' )

-- Variables globales
display_w = display.contentWidth
display_h = display.contentHeight
center_x = display.contentCenterX
center_y = display.contentCenterY

local composer = require('composer')
composer.recycleOnSceneChange = true

composer.gotoScene( 'scenes.menu' )