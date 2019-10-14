require( 'Tools.Tween' )
require( 'Tools.Collider' )
require( 'Tools.Input' )
require( 'Tools.StateMachine' )
require( 'Tools.Sprite' )
require( 'Tools.Vector' )

require( 'Entities.Rope' )
require( 'Entities.Solid' )
require( 'Entities.Actor' )
require( 'Entities.Player' )

local level = {}

function love.load()
    love.graphics.setBackgroundColor( 0.8, 0.8, 0.8 )
    Sprite.init()

    Player:load()
    level[ #level + 1 ] = Solid.new( 400, 600, 800, 100 )
    level[ #level + 1 ] = Solid.new( 785, 300, 30, 600 )
    level[ #level + 1 ] = Solid.new(  15, 300, 30, 600 )
    level[ #level + 1 ] = Solid.new( 128, 300, 256, 32 )
end

function love.update( dt )
    Player:update( dt )
    Input.update( dt ) -- needs to be last
end

function love.draw()
    for _, e in ipairs( level ) do
        e:draw()
    end

    Player:draw()
end
