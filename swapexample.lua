-- Foo2Much --

-- Grupos a mostrar, estos ayudan a organizar los objetos
local backGroup = display.newGroup( )
local mainGroup = display.newGroup( )
local uiGroup = display.newGroup( )

local personaje

-- Para swapear una imagen crearemos 2 personajes

blue = display.newImageRect( mainGroup, "/images/blue.png", 128, 128 )
blue.x = display.contentCenterX
blue.y = display.contentCenterY

green = display.newImageRect( mainGroup, "images/green.png", 128, 128 )
green.x = display.contentCenterX
green.y = display.contentCenterY

green.isVisible = false

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

blue:addEventListener( "tap", circleSwap )
green:addEventListener( "tap", circleSwap )