Player = StateMachine.new()

-- NORMAL STATE
local StateNormal = State.new( Player, 'normal' )
StateNormal.update = function( self, dt )
    local mob = self.sm.mob
    local dx = 0;
    if Input:isHeldDown( Input.keys.LEFT )  then dx = dx - 1 end
    if Input:isHeldDown( Input.keys.RIGHT ) then dx = dx + 1 end

    mob.dx = dx * mob.xf + mob.dx * ( 1 - mob.xf )
    Mobile.update( mob, dt )

    local wall = self.sm:collideWithWall()
    if Input:isPressed( Input.keys.UP ) and wall then
        print( 'start climbing')
        self.sm:setState( "climb", wall.h - mob.h / 2 )
    end
end

-- JUMP STATE
local StateJump       = State.new( Player, 'jump' )
StateJump.from        = { x = 0, y = 0 }
StateJump.to          = { x = 0, y = 0 }
StateJump.duration    = 0
StateJump.elapsedTime = 0
StateJump.height      = 0

-- data = { x, y, speed, height }
StateJump.enter = function( self, data )
    self.from.x, self.from.y = self.sm.mob.x, self.sm.mob.y
    self.to.x, self.to.y     = data.x, data.y

    local distance = math.abs( self.to.x - self.from.x )

    self.duration    = distance / data.speed
    self.elapsedTime = 0
    self.height      = data.height

    self.sm.mob.dir = distance == ( self.to.x - self.from.x ) and 1 or -1
end

StateJump.update = function( self, dt )
    self.elapsedTime = self.elapsedTime + dt
    local mob = self.sm.mob

    local t = self.elapsedTime / self.duration
    local x = Tween.lerp( self.from.x, self.to.x, t, 'cubeOut' )
    local y = Tween.lerp( self.from.y, self.to.y, t, 'cubeOut' )
    y = y - Tween.lerp( 0, self.height, t <= 0.5 and t * 2 or 2 * ( 1 - t ), t <= 0.5 and 'cubeOut' or 'cubeIn' )


    mob:move( x, y )

    if t >= 1 or self.sm:collideWithWall() then
        self.sm:setState( 'normal' )
    end
end

-- CLIMB STATE
local StateClimb = State.new( Player, "climb" )
StateClimb.speed       = 100
StateClimb.bitLength   = 0
StateClimb.from        = 0
StateClimb.elapsedTime = 0
StateClimb.duration    = 0
StateClimb.stop        = 0

StateClimb.enter = function( self, height )
    self.bitLength   = height / 4
    self.from        = self.sm.mob.y
    self.elapsedTime = 0
    self.duration    = self.bitLength / self.speed
    self.stop        = self.from - self.height
    print( 'climb enter' )
end

StateClimb.update = function( self, dt )
    self.elapsedTime = self.elapsedTime + dt

    local t = self.elapsedTime / self.duration
    local y = Tween.lerp( self.from, self.from - self.bitLength, t, "cubeOut" )

    local mob = self.sm.mob
    mob:move( mob.x, y )

    if t == 1 then
        if y == self.stop then
            self.sm:setState( 'normal' )
            print( 'climb leave' )
        else
            self.elapsedTime = 0
            self.from = y
        end
    end
end

-- METHODS
Player.load = function( self )
    self.spr = Sprite.new( 'character' )
    self.spr:play( 'idle' )

    self.mob = Mobile.new( 100, 100, 32, 32 )
    self:setState( 'normal' )
end

Player.update = function( self, dt )
    StateMachine.update( self, dt )

    local mob = self.mob
    local windowWidth = love.window.getMode()
    if mob.x > windowWidth then
        mob:setPosition( mob.x - windowWidth, mob.y )
    elseif mob.x < 0 then
        mob:setPosition( windowWidth + mob.x, mob.y )
    end

    self.spr:update( dt )
end

Player.draw = function( self )
    local mob = self.mob
    -- Mobile.draw( mob )
    love.graphics.setColor( 1, 1, 1 )
    self.spr.dir = mob.dir
    if mob.dx ~= 0 then
        self.spr:play( 'walk' )
    else
        self.spr:play( 'idle' )
    end
    self.spr:draw( mob.x, mob.y )

    local windowWidth = love.window.getMode()
    local radius = mob.w / 2
    if mob.x + radius > windowWidth then
        love.graphics.setColor( mob.color )
        love.graphics.rectangle( 'fill', mob.x - radius - windowWidth, mob.y - radius, mob.w, mob.h )
        love.graphics.setColor( 0, 0, 0 )
        love.graphics.rectangle( 'fill', ( mob.dir == 1 and mob.x or mob.x - mob.w / 2 ) - windowWidth, mob.y - 2, mob.w / 2, 4 )
    elseif mob.x - radius < 0 then
        love.graphics.setColor( mob.color )
        love.graphics.rectangle( 'fill', mob.x - radius + windowWidth, mob.y - radius, mob.w, mob.h )
        love.graphics.setColor( 0, 0, 0 )
        love.graphics.rectangle( 'fill', ( mob.dir == 1 and mob.x or mob.x - mob.w / 2 ) + windowWidth, mob.y - 2, mob.w / 2, 4 )
    end
end

Player.initJump = function( self )
    local data = {
        x      = self.mob.x + self.mob.dir * 150,
        y      = self.mob.y,
        speed  = 300,
        height = 100
    }
    self:setState( 'jump', data )
end

Player.collideWithWall = function( self )
    for _, col in ipairs( self.mob.collisions ) do
        if col.x ~= 0 then
            return col.e
        end
    end

    return nil
end