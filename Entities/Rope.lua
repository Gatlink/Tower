Rope = {}
Rope.__index = Rope

Rope.new = function( x, y, length )
    local new = {}

    new.x = x
    new.y = y

    new.length        = length
    new.currentLength = length

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

Rope.checkLength = function( self, x, y, vx, vy )
    local rx, ry = self:vectorTo( x + vx, y + vy )

    rx, ry = Vector.normalize( rx, ry )
    rx, ry = rx * self.currentLength, ry * self.currentLength
    vx, vy = rx - x, ry - y

    return vx, vy
end

Rope.update = function( self, dt )
    local len = self.currentLength - self.length
    local t   = len / self.length
    self.currentLength = t * self.currentLength + ( 1 - t ) * self.length
end