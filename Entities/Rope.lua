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

    new.cx = nil
    new.cy = nil

    new.actor = nil

    setmetatable( new, Rope )
    return new
end

Rope.vectorTo = function( self, x, y )
    return Vector.sub( x, y, self.x, self.y )
end

Rope.attach = function( self, actor )
    local rx, ry = self:vectorTo( actor.x, actor.y )
    self.currentLength = Vector.len( rx, ry )
    self.actor = actor
end

Rope.update = function( self, dt )
    -- ROPE ELASTICITY
    if self.currentLength > self.length then
        local t = Tween.cubeOut( math.min( ( self.currentLength - self.length ) /  ( self.lengthLimit - self.length ), 1 ) )
        self.springVelocity = self.springVelocity - self.springAcceleration * t * dt
        self.currentLength = self.currentLength + self.springVelocity * dt
    end

    -- COLLISIONS
    self.cx, self.cy = nil, nil
    for _, s in ipairs( Solid.all ) do
        local x, y, _ = s:lineCollide( self.x, self.y, self.actor.x, self.actor.y )
        if x then
            self.cx, self.cy = x, y
            break
        end
    end
end

Rope.draw = function( self )
    love.graphics.setColor( 0.8, 0, 0 )

    if self.actor then
        love.graphics.line( self.x, self.y, self.actor.x, self.actor.y )
    end

    love.graphics.circle( 'fill', self.x, self.y, 5 )

    if self.cx and self.cy then
        love.graphics.setColor( 0, 0.8, 0 )
        love.graphics.circle( 'fill', self.cx, self.cy, 5 )
    end
end