Player = Actor.new( 100, 400, 32, 32 )
setmetatable( Player, Actor )

local xTopSpeed        = 200
local xTimeToTopSpeed  = 0.5

local xTimeToStop      = 0.2
local xTopSpeedReached = 0
local xStopdt          = 0


local ySpeed = 600
local dir    = 1

Player.load = function( self )
    self.spr = Sprite.new( 'character' )
    self.spr:play( 'idle' )
end

Player.update = function( self, dt )
    -- MOVE X
    local xdt = 0;
    local inputLeft  = Input:isHeldDown( Input.keys.LEFT )
    local inputRight = Input:isHeldDown( Input.keys.RIGHT )
    -- Take the most recent input
    if inputLeft and ( not inputRight or inputLeft < inputRight ) then
        xdt = inputLeft
        dir = -1
        xStopdt = 0
    elseif inputRight and ( not inputLeft or inputRight < inputLeft ) then
        xdt = inputRight
        dir = 1
        xStopdt = 0
    else
        xStopdt = math.min( xStopdt + dt, xTimeToStop )
    end

    local xSpeed = 0
    if xdt ~= 0 then
        local accelerationRatio = math.min( 1, Tween.cubeInOut( xdt / xTimeToTopSpeed ) )
        xSpeed = accelerationRatio * xTopSpeed
        xTopSpeedReached = xSpeed
    else
        local tStop = xTimeToStop * xTopSpeedReached / xTopSpeed
        local t     = math.min( xStopdt / tStop, 1 )
        xSpeed      = Tween.lerp( xTopSpeedReached, 0, t, 'CubeInOut' )
    end

    self:moveX( dir * xSpeed * dt )
    self:moveY( ySpeed * dt )

    self.spr.spdRatio = 1
    if xdt ~= 0 then
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

    local windowWidth = love.window.getMode()
    if self.right > windowWidth then
        self.spr:draw( self.x - windowWidth + self.xr, self.y + self.yr )
    elseif self.left < 0 then
        self.spr:draw( windowWidth + self.x + self.xr, self.y + self.yr )
    end
end