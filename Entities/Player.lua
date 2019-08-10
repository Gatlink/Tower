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

    if Input:isPressed( Input.keys.UP ) then
        self.sm:initJump()
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

    -- collisions
    local collided = false
    for _, col in ipairs( mob.collisions ) do
        if col.x ~= 0 then
            collided = true
            break
        end
    end

    if t >= 1 or collided then
        self.sm:setState( 'normal' )
    end
end

-- METHODS
Player.load = function( self )
    self.mob = Mobile.new( 100, 100 )
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
end

Player.draw = function( self )
    local mob = self.mob
    Mobile.draw( mob )

    local windowWidth = love.window.getMode()
    local radius = mob.w / 2
    if mob.x + radius > windowWidth then
        love.graphics.setColor( mob.color )
        love.graphics.rectangle( 'fill', mob.x - radius - windowWidth, mob.y - radius, mob.w, mob.h )
    elseif mob.x - radius < 0 then
        love.graphics.setColor( mob.color )
        love.graphics.rectangle( 'fill', mob.x - radius + windowWidth, mob.y - radius, mob.w, mob.h )
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