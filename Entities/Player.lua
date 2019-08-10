Player = Mobile.new( 100, 100 )
setmetatable( Player, Mobile )

Player.update = function( self, dt )
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