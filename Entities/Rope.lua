Rope = {}
Rope.__index = Rope

Rope.new = function( x, y, length )
    local new = {}

    new.x = x
    new.y = y

    new.length        = length
    new.currentLength = length
    new.retractSpd    = 50

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

    if Vector.sqrLen( rx, ry ) > self.currentLength * self.currentLength then
        rx, ry = Vector.normalize( rx, ry )
        rx, ry = rx * self.currentLength, ry * self.currentLength
        rx, ry = Vector.add( self.x, self.y, rx, ry )
        vx, vy = Vector.sub( rx, ry, x, y )
    end

    return vx, vy
end

Rope.update = function( self, dt )
    if self.currentLength > self.length then
        local dl = dt * self.retractSpd
        self.currentLength = math.max( self.currentLength - dl, self.length )
    end
end