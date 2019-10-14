Player = Actor.new( 100, 200, 32, 32 )
setmetatable( Player, Actor )

local dir    = 1

-- STATE MACHINE
local sm = StateMachine.new()



-- GROUNDED STATE
-- variables
local normalState = State.new( sm, 'grounded' )
local xTopSpeed        = 200
local xTimeToTopSpeed  = 0.5

local xTimeToStop      = 0.2
local xTopSpeedReached = 0
local xStopdt          = 0

-- callbacks
normalState.enter = function( self, data )
    xStopdt = 0
    xTopSpeedReached = 0
end

normalState.update = function( self, dt )
    -- MOVE X
    local xdt = 0;
    local inputLeft  = Input.isHeldDown( Input.keys.LEFT )
    local inputRight = Input.isHeldDown( Input.keys.RIGHT )
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

    local moved = Player:moveX( dir * xSpeed * dt )
    if Player:moveY( 1 ) then
        sm:setState( 'airborne' )
    end

    Player.spr.spdRatio = 1
    if xdt ~= 0 and moved then
        Player.spr:play( 'walk' )
    else
        Player.spr:play( 'idle' )
    end

    if Input.isPressed( Input.keys.UP ) then
        sm:setState( 'airborne', -400 )
end
end



-- AIRBORNE STATE
local airborneState = State.new( sm, "airborne" )

local vx = 0
local vy = 0
local ay = 600

local rope = nil

airborneState.enter = function( self, ySpd )
    if ySpd then
        vy = ySpd
    end
end

airborneState.update = function( self, dt )
    vy = vy + ay * dt

    local dx, dy = vx * dt, vy * dt
    local oldX, oldY = Player:getRealPos()
    local x, y = oldX + dx, oldY + dy

    if rope ~= nil then
        local rx, ry = rope:vectorTo( x, y )
        local length = rope.currentLength
        local len = Vector.len( rx, ry )
        if len > length then
            rx, ry = rx / len, ry / len
            x, y = rope.x + rx * length, rope.y + ry * length
        end
    end

    dx, dy = x - oldX, y - oldY
    if not Player:moveX( dx ) then vx = 0 end
    if not Player:moveY( dy ) and dy > 0 and rope == nil then
        sm:setState( 'grounded' )
        return
    end

    x, y = Player:getRealPos()
    vx = ( x - oldX ) / dt
    vy = ( y - oldY ) / dt

end

airborneState.exit = function( self )
    vx = 0
    vy = 0
    rope = nil
end

sm:setState( 'airborne' )

-- CALLBACKS
Player.load = function( self )
    self.spr = Sprite.new( 'character' )
    self.spr:play( 'idle' )
end

Player.update = function( self, dt )
    if rope ~= nil then rope:update( dt ) end

    sm:update( dt )

    self.spr:update( dt )

    if Input.leftClick() then
        rope = Rope.new( Input.getMouseX(), Input.getMouseY(), 150 )
        rope:attach( self.x, self.y )
        sm:setState( "airborne" )
    elseif Input.rightClick() then
        rope = nil
    end
end

Player.draw = function( self )
    love.graphics.setColor( 1, 1, 1 )
    self.spr.dir = dir
    self.spr:draw( self.x, self.y )

    if rope then
        love.graphics.setColor( 0.8, 0, 0 )
        love.graphics.line( rope.x, rope.y, self.x, self.y )
        love.graphics.circle( 'fill', rope.x, rope.y, 5 )
    end
end