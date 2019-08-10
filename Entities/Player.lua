Player = Mobile.new( 100, 100 )

-- NORMAL STATE
local normalUpdate = function( self, dt )
    self = self.sm.parent
    local dx = 0;
    if Input.left  then dx = dx - 1 end
    if Input.right then dx = dx + 1 end

    self.dx = dx * self.xf + self.dx * ( 1 - self.xf )
    Mobile.update( self, dt )

    local windowWidth = love.window.getMode()
    if self.x > windowWidth then
        Player:setPosition( 0, self.y )
    elseif Player.x < 0 then
        Player:setPosition( windowWidth, self.y )
    end
end

local normalDraw = function( self )
    self = self.sm.parent
    Mobile.draw( Player )

    local windowWidth = love.window.getMode()
    local radius = Player.w / 2
    if self.x + radius > windowWidth then
        love.graphics.setColor( self.color )
        love.graphics.rectangle( 'fill', self.x - radius - windowWidth, self.y - radius, self.w, self.h )
    elseif self.x - radius < 0 then
        love.graphics.setColor( self.color )
        love.graphics.rectangle( 'fill', self.x - radius + windowWidth, self.y - radius, self.w, self.h )
    end
end

-- METHODS
Player.load = function( self )
    local sm = StateMachine.new()
    sm.parent = self
    Player.stateMachine = sm

    local normalState = sm:addState( 'normal' )
    normalState.update = normalUpdate
    normalState.draw   = normalDraw

    Player.stateMachine:setState( 'normal' )
end

Player.update = function( Player, dt )
    Player.stateMachine:update( dt )
end

Player.draw = function( Player )
    Player.stateMachine:draw()
end