Rope = {}
Rope.__index = Rope

Rope.new = function( x, y, length )
    local new = {}

    new.x = x
    new.y = y

    new.length        = length
    new.currentLength = length

    new.springAcceleration = 800
    new.springVelocity     = 0
    new.lengthLimit        = 2 * length

    new.points = {}
    new.actor  = nil

    setmetatable( new, Rope )
    return new
end

Rope.getX = function( self )
    return # self.points > 0 and self.points[ #self.points ].x or self.x
end

Rope.getY = function( self )
    return # self.points > 0 and self.points[ #self.points ].y or self.y
end

Rope.vectorTo = function( self, x, y )
    return Vector.sub( x, y, self:getX(), self:getY() )
end

Rope.attach = function( self, actor )
    local rx, ry = self:vectorTo( actor.x, actor.y )
    self.currentLength = Vector.len( rx, ry )
    self.actor = actor
end

Rope.update = function( self, dt )
    -- COLLISIONS
    repeat until not self:checkCollisions()
    
    -- ROPE ELASTICITY
    if self.currentLength > self.length then
        local t = Tween.cubeOut( math.min( ( self.currentLength - self.length ) /  ( self.lengthLimit - self.length ), 1 ) )
        self.springVelocity = self.springVelocity - self.springAcceleration * t * dt
        self.currentLength = self.currentLength + self.springVelocity * dt
    end
end

Rope.checkCollisions = function( self )
    for _, s in ipairs( Solid.all ) do
        local x, y, _ = s:lineCollide( self:getX(), self:getY(), self.actor.x, self.actor.y )
        if x then
            local prev = #self.points > 0 and self.points[ #self.points ] or { x = x, y = y }
            local px   = x - s.left < s.right - x and s.left or s.right
            local py   = y - s.top < s.bottom - y and s.top or s.bottom
            local len  = Vector.len( px - prev.x, py - prev.y )
            self.points[ #self.points + 1 ] = { x = px, y = py, len = len }
            self.currentLength = self.currentLength - len
            self.length        = self.length - len
            return true
        end
    end

    return false
end

Rope.draw = function( self )
    love.graphics.setColor( 0.8, 0, 0 )

    local prev = { x = self.x, y = self.y }
    for _, point in ipairs( self.points ) do
        love.graphics.line( prev.x, prev.y, point.x, point.y )
        prev.x, prev.y = point.x, point.y
    end

    if self.actor then
        love.graphics.line( prev.x, prev.y, self.actor.x, self.actor.y )
    end

    love.graphics.circle( 'fill', self.x, self.y, 5 )
end