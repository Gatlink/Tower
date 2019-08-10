local input = {
    left  = false,
    right = false,
    up    = false
}

-- Tween
-- Easing methods taken from Peidro Meideros: https://www.patreon.com/posts/animation-easing-8030922
local Tween = {}
Tween.lerp   = function( min, max, t, easing )
    return min + ( max - min ) * math.max( 0, math.min( 1, easing and Tween[ easing ] and Tween[ easing ]( t ) or t ) )
end

Tween.cubeIn = function( t ) return t * t * t end

Tween.cubeInOut = function( t )
    if t <= .5 then
        return t * t * t * 4
    else
        t = t - 1
        return 1 + t * t * t * 4
    end
end

Tween.easeCubeOut = function( t )
    t = t - 1
    return 1 + t * t * t
end

Tween.easeBackIn = function( t )
    return t * t * ( 2.70158 * t - 1.70158 )
end

Tween.easeBackOut = function( t )
    t = t - 1
    return ( 1 - t * t * ( -2.70158 * t - 1.70158 ) )
end

Tween.easeBackInOut = function( t )
    t = t * 2

    if t < 1 then
        return t * t * ( 2.70158 * t - 1.70158 ) / 2
    else
        t = t - 2;
        return ( 1 - t * t * ( -2.70158 * t - 1.70158 ) ) / 2 + .5
    end
end

Tween.easeElasticIn = function( t )
    return math.sin( 13 * ( math.pi / 2 ) * t ) * math.pow( 2, 10 * ( t - 1 ) )
end

Tween.easeElasticOut = function( t )
    return math.sin( -13 * ( math.pi / 2 ) * ( t + 1 ) ) * math.pow( 2, -10 * t ) + 1
end

Tween.easeElasticInOut = function( t )
    if t < 0.5 then
        return 0.5 * ( math.sin( 13 * ( math.pi / 2 ) * ( 2 * t ) ) * math.pow( 2, 10 * ( ( 2 * t ) - 1 ) ) )
    else
        return 0.5 * ( math.sin( -13 * ( math.pi / 2 ) * ( ( 2 * t - 1 ) + 1 ) ) * math.pow( 2, -10 * ( 2 * t - 1 ) ) + 2 )
    end
end

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
    local col = { x = 0, y = 0, depth = math.huge }
    local setMin = function( depth, x, y )
        if depth <= 0 then return false end

        if depth < col.depth then
            col.x = x
            col.y = y
            col.depth = depth
        end
        
        return true
    end

    if not setMin( with.right - self.left,  1,  0 ) then return nil end
    if not setMin( self.right - with.left, -1,  0 ) then return nil end
    if not setMin( with.bottom - self.top,  0,  1 ) then return nil end
    if not setMin( self.bottom - with.top,  0, -1 ) then return nil end

    return col
end

Collider.setPosition = function( self, x, y )
    self.x = x
    self.y = y

    self.left   = x - self.w / 2
    self.right  = x + self.w / 2
    self.top    = y - self.h / 2
    self.bottom = y + self.h / 2
end

-- ENTITY
local Entity = {}
Entity.__index = Entity
Entity.all = {}
Entity.new = function( x, y, w, h, color )
    local new = {}
    new.x = x or 0
    new.y = y or 0
    new.w = w or 50
    new.h = h or 50
    new.color = color or { 1, 0, 0 }

    new.collider = Collider.new( new.x, new.y, new.w, new.h )

    setmetatable( new, Entity )
    new.id = #Entity.all + 1
    Entity.all[ new.id ] = new
    return new
end

Entity.draw = function( self )
    love.graphics.setColor( self.color )
    love.graphics.rectangle( 'fill', self.x - self.w / 2, self.y - self.h / 2, self.w, self.h )
end

-- MOBILE
local Mobile = {}
Mobile.__index = Mobile
setmetatable( Mobile, Entity )
Mobile.all = {}
Mobile.new = function( x, y, w, h, color )
    local new = Entity.new( x, y, w, h, color )

    new.xSpeed = 200
    new.xf = 0.95
    new.dx = 0

    new.gravity = 500
    new.yf = 0.98
    new.dy = 0

    new.collider = Collider.new( new.x, new.y, new.w, new.h )

    setmetatable( new, Mobile )
    Mobile.all[ #Mobile.all + 1 ] = new
    return new
end

Mobile.update = function( self, dt )
    self.dy = self.yf + self.dy * ( 1 - self.yf )
    self:move( self.x + self.dx * self.xSpeed * dt, self.y + self.dy * self.gravity * dt )
end

Mobile.move = function( self, x, y )
    self:setPosition( x, y )

    local hasCollision
    repeat
        hasCollision = false
        for i, e in ipairs( Entity.all ) do
            if i ~= self.id then
                local collision = self.collider:collide( e.collider )
                if collision ~= nil then
                    self:setPosition( self.x + collision.x * collision.depth, self.y + collision.y * collision.depth )
                    hasCollision = true
                end
            end
        end
    until not hasCollision
end

Mobile.setPosition = function( self, x, y )
    self.x = x
    self.y = y
    self.collider:setPosition( x, y )
end

-- PLAYER
local Player = Mobile.new( 100, 100 )
setmetatable( Player, Mobile )

Player.update = function( self, dt )
    local dx = 0;
    if input.left  then dx = dx - 1 end
    if input.right then dx = dx + 1 end

    self.dx = dx * self.xf + self.dx * ( 1 - self.xf )
    Mobile.update( self, dt )

    local windowWidth = love.window.getMode()
    if self.x > windowWidth then
        self:setPosition( 0, self.y )
    elseif self.x < 0 then
        self:setPosition( windowWidth, self.y )
    end
end

Player.draw = function( self )
    Mobile.draw( self )

    local windowWidth = love.window.getMode()
    local radius = self.w / 2
    if self.x + radius > windowWidth then
        love.graphics.setColor( self.color )
        love.graphics.rectangle( 'fill', 0, self.y - radius, self.x + radius - windowWidth, self.h )
    elseif self.x - radius < 0 then
        love.graphics.setColor( self.color )
        love.graphics.rectangle( 'fill', windowWidth + self.x - radius, self.y - radius, radius, self.h )
    end
end

-- CALLBACKS
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
    input.left, input.right, input.up = code == "a", code == "d", code == "w"
end

function love.keyreleased( _, code )
    if code == "a" then input.left  = false end
    if code == "d" then input.right = false end
    if code == "w" then input.up    = false end
end

function love.update( dt )
    for _, e in ipairs( Mobile.all) do
        e:update( dt )
    end
end