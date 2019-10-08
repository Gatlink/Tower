Player = Actor.new( 100, 400, 32, 32 )
setmetatable( Player, Actor )

local xTopSpeed            = 100
local xTimeToTopSpeed      = 0.5
local xTimeToStop          = 1
local xElapsedAcceleration = 0

local ySpeed = 600
local dir    = 1

Player.load = function( self )
    self.spr = Sprite.new( 'character' )
    self.spr:play( 'idle' )
end

Player.update = function( self, dt )
    -- MOVE X
    local dx = 0;
    local inputLeft  = Input:isHeldDown( Input.keys.LEFT )
    local inputRight = Input:isHeldDown( Input.keys.RIGHT )
    -- Take the most recent input
    if inputLeft and inputRight then
        dx = inputRight > inputLeft and -1 or 1
    elseif inputLeft then  dx = -1
    elseif inputRight then dx = 1
    end

    dir = dx ~= 0 and dx or dir
    
    local xSpeed = 0
    if dx ~= 0 then
        xElapsedAcceleration = xElapsedAcceleration + dt
        local accelerationRatio = math.min( 1, Tween.cubeIn( xElapsedAcceleration / xTimeToTopSpeed ) )
        xSpeed = accelerationRatio * xTopSpeed
    else
        xElapsedAcceleration = 0
    end

    self:moveX( dx * xSpeed * dt )
    self:moveY( ySpeed * dt )

    self.spr.spdRatio = 1
    if dx ~= 0 then
        self.spr:play( 'walk' )
    else
        self.spr:play( 'idle' )
    end

    local windowWidth = love.window.getMode()
    if self.x > windowWidth then
        self:setPosition( self.x - windowWidth, self.y )
    elseif self.x < 0 then
        self:setPosition( windowWidth + self.x, self.y )
    end

    self.spr:update( dt )
end

Player.draw = function( self )
    love.graphics.setColor( 1, 1, 1 )
    self.spr.dir = dir
    self.spr:draw( self.x + self.xr, self.y + self.yr )

    -- local windowWidth = love.window.getMode()
end