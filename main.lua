require( 'Tools.Tween' )
require( 'Tools.Collider' )
require( 'Tools.Input' )
require( 'Tools.StateMachine' )

require( 'Entities.Entity' )
require( 'Entities.Mobile' )
require( 'Entities.Player' )

local level = {}

function love.load()
    Player:load()
    level[ #level + 1 ] = Entity.new( 400, 550, 800, 300, { 0.3, 0.3, 0.3 } )
    level[ #level + 1 ] = Entity.new( 370, 200, 60, 400, { 0.3, 0.3, 0.3 } )
end

function love.update( dt )
    Player:update( dt )
end

function love.draw()
    for _, e in ipairs( level ) do
        e:draw()
    end

    Player:draw()
end

function love.keypressed( _, code )
    Input.left, Input.right, Input.up = code == "a", code == "d", code == "w"
end

function love.keyreleased( _, code )
    if code == "a" then Input.left  = false end
    if code == "d" then Input.right = false end
    if code == "w" then Input.up    = false end
end
