Player = StateMachine.new()

-- NORMAL STATE
local StateNormal = State.new( Player, 'normal' )
StateNormal.update = function( self, dt )
    self = self.sm.mob
    local dx = 0;
    if Input.left  then dx = dx - 1 end
    if Input.right then dx = dx + 1 end

    self.dx = dx * self.xf + self.dx * ( 1 - self.xf )
    Mobile.update( self, dt )

    local windowWidth = love.window.getMode()
    if self.x > windowWidth then
        self:setPosition( 0, self.y )
    elseif self.x < 0 then
        self:setPosition( windowWidth, self.y )
    end
end

StateNormal.draw = function( self )
    self = self.sm.mob
    Mobile.draw( self )

    local windowWidth = love.window.getMode()
    local radius = self.w / 2
    if self.x + radius > windowWidth then
        love.graphics.setColor( self.color )
        love.graphics.rectangle( 'fill', self.x - radius - windowWidth, self.y - radius, self.w, self.h )
    elseif self.x - radius < 0 then
        love.graphics.setColor( self.color )
        love.graphics.rectangle( 'fill', self.x - radius + windowWidth, self.y - radius, self.w, self.h )
    end
end

-- JUMP STATE
local StateJump = State.new( Player, 'jump' )
StateJump.update = function( self, dt )
    self = self.sm.mob
end

-- METHODS
Player.load = function( self )
    self.mob = Mobile.new( 100, 100 )
    self:setState( 'normal' )
end