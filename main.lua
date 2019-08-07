local input = {
    left = false,
    right = false
}

-- ENTITIES
local Entity = {}
Entity.__index = Entity
Entity.all = {}
Entity.new = function( x, y, radius, color )
    local new = {}
    new.x = x or 0
    new.y = y or 0
    new.radius = radius or 25
    new.color = color or { 1, 0, 0 }

    new.speed = 200
    new.xf = 0.95
    new.dx = 0

    setmetatable( new, Entitie )
    table.insert( Entity.all, new );
    return new
end

Entity.draw = function( self )
    love.graphics.setColor( self.color )
    love.graphics.rectangle( 'fill', self.x - self.radius, self.y - self.radius, self.radius * 2, self.radius * 2 )
end

Entity.update = function( self, dt )
    self.x = self.x + self.dx * self.speed * dt
end

-- PLAYER
local Player = Entity.new( 400, 300 )
setmetatable(Player, Entity )
Player.speed = 200

Player.update = function( self, dt )
    local dx = 0;
    if input.left  then dx = dx - 1 end
    if input.right then dx = dx + 1 end

    self.dx = dx * self.xf + self.dx * ( 1 - self.xf )
    Entity.update( self, dt )
end

-- CALLBACKS
function love.draw()
    for _, e in ipairs( Entity.all) do
        e:draw()
    end
end

function love.keypressed( _, code )
    input.left, input.right = code == "a", code == "d"
end

function love.keyreleased( _, code )
    if code == "a" then input.left  = false end
    if code == "d" then input.right = false end
end

function love.update( dt )
    for _, e in ipairs( Entity.all) do
        e:update( dt )
    end
end