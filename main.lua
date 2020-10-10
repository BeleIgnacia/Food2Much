system.activate( 'multitouch' )

-- Variables globales
_G.display_w = display.contentWidth
_G.display_h = display.contentHeight
_G.center_x = display.contentCenterX
_G.center_y = display.contentCenterY

local composer = require('composer')
composer.recycleOnSceneChange = true

composer.gotoScene( 'scenes.menu' )