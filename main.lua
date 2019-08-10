require( 'Tools.Tween' )
require( 'Tools.Collider' )
require( 'Tools.Input' )
require( 'Tools.StateMachine' )

require( 'Entities.Entity' )
require( 'Entities.Mobile' )
require( 'Entities.Player' )

function love.load()
    Entity.new( 400, 550, 800, 300, { 0.3, 0.3, 0.3 } )
    Entity.new( 370, 200, 60, 400, { 0.3, 0.3, 0.3 } )
    print( Tween.lerp( 0, 1, 0.3, "cubeInOut" ) )
end

function love.draw()
    for _, e in ipairs( Entity.all) do
        e:draw()
    end
end

function love.keypressed( _, code )
    Input.left, Input.right, Input.up = code == "a", code == "d", code == "w"
end

function love.keyreleased( _, code )
    if code == "a" then Input.left  = false end
    if code == "d" then Input.right = false end
    if code == "w" then Input.up    = false end
end

function love.update( dt )
    for _, e in ipairs( Mobile.all) do
        e:update( dt )
    end
end