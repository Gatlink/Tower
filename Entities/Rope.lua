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

    setmetatable( new, Rope )
    return new
end

Rope.vectorTo = function( self, x, y )
    return Vector.sub( x, y, self.x, self.y )
end

Rope.attach = function( self, x, y )
    local rx, ry = self:vectorTo( x, y )
    self.currentLength = Vector.len( rx, ry )
end

Rope.update = function( self, dt )
    -- ROPE ELASTICITY
    if self.currentLength > self.length then
        local t = Tween.cubeOut( math.min( ( self.currentLength - self.length ) /  ( self.lengthLimit - self.length ), 1 ) )
        self.springVelocity = self.springVelocity - self.springAcceleration * t * dt
        self.currentLength = self.currentLength + self.springVelocity * dt
    end
end