require( 'Tools.Tween' )
require( 'Tools.Collider' )
require( 'Tools.Input' )
require( 'Tools.StateMachine' )
require( 'Tools.Sprite' )

require( 'Entities.Entity' )
require( 'Entities.Mobile' )
require( 'Entities.Player' )

local level = {}

function love.load()
    love.graphics.setBackgroundColor( 0.8, 0.8, 0.8 )
    Sprite.init()

    Player:load()
    level[ #level + 1 ] = Entity.new( 400, 550, 800, 300, { 0.3, 0.3, 0.3 } )
    level[ #level + 1 ] = Entity.new( 370, 200, 60, 400, { 0.3, 0.3, 0.3 } )
end

function love.update( dt )
    Player:update( dt )
    Input:update( dt ) -- needs to be last
end

function love.draw()
    for _, e in ipairs( level ) do
        e:draw()
    end

    Player:draw()
end

function love.keypressed( _, code )  Input:keypressed( code ) end
function love.keyreleased( _, code ) Input:keyreleased( code ) end
