local input = {
    left = false,
    right = false
}

-- AABB
local Collider = {}
Collider.__index = Collider
Collider.new = function( x, y, w, h )
    local new = {}
    new.w = w or 0
    new.h = h or 0
    
    setmetatable( new, Collider )
    new:setPosition( x or 0, y or 0 )
    return new
end

Collider.collide = function( self, with )
    local col = { x = 0, y = 0, value = math.huge }
    local wasFound = false

    local setMin = function( min, x, y )
        if min > 0 and min < col.value then
            col.x = x
            col.y = y
            col.value = min
            return true
        end

        return false
    end

    wasFound = setMin( with.right - self.left, 1, 0 )  or wasFound
    wasFound = setMin( self.right - with.left, -1, 0 ) or wasFound
    wasFound = setMin( with.bottom - self.top, 0, 1 )  or wasFound
    wasFound = setMin( self.bottom - with.top, 0, -1 ) or wasFound

    return wasFound and col or nil
end

Collider.setPosition = function( self, x, y )
    self.x = x
    self.y = y

    self.left   = x - self.w / 2
    self.right  = x + self.w / 2
    self.top    = y - self.h / 2
    self.bottom = y + self.h / 2
end

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
    new.dy = 0

    new.collider = Collider.new( new.x, new.y, new.radius * 2, new.radius * 2 )

    setmetatable( new, Entity )
    new.id = #Entity.all + 1
    Entity.all[ new.id ] = new
    return new
end

Entity.draw = function( self )
    love.graphics.setColor( self.color )
    love.graphics.rectangle( 'fill', self.x - self.radius, self.y - self.radius, self.radius * 2, self.radius * 2 )
end

Entity.update = function( self, dt )
    self:move( self.x + self.dx * self.speed * dt, self.y )
end

Entity.move = function( self, x, y )
    self:setPosition( x, y )

    for i, e in ipairs( Entity.all ) do
        if i ~= self.id then
            local collision = self.collider:collide( e.collider )
            if collision ~= nil then
                self:setPosition( x + collision.x * collision.value, y + collision.y * collision.value )
            end
        end
    end
end

Entity.setPosition = function( self, x, y )
    self.x = x
    self.y = y
    self.collider:setPosition( x, y )
end

-- PLAYER
local Player = Entity.new( 400, 300 )
setmetatable(Player, Entity )

Player.update = function( self, dt )
    local dx = 0;
    if input.left  then dx = dx - 1 end
    if input.right then dx = dx + 1 end

    self.dx = dx * self.xf + self.dx * ( 1 - self.xf )
    Entity.update( self, dt )
end

-- CALLBACKS
function love.load()
    Entity.new( 500, 295, 30, { 0, 1, 0 } )
end

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