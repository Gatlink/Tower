Mobile = {}
Mobile.__index = Mobile
setmetatable( Mobile, Entity )
Mobile.new = function( x, y, w, h, color )
    local new = Entity.new( x, y, w, h, color )

    new.xSpeed = 200
    new.xf = 0.95
    new.dx = 0

    new.gravity = 500
    new.yf = 0.98
    new.dy = 0

    new.collider = Collider.new( new.x, new.y, new.w, new.h )

    setmetatable( new, Mobile )
    return new
end

Mobile.update = function( self, dt )
    self.dy = self.yf + self.dy * ( 1 - self.yf )
    self:move( self.x + self.dx * self.xSpeed * dt, self.y + self.dy * self.gravity * dt )
end

Mobile.move = function( self, x, y )
    self:setPosition( x, y )

    local hasCollision
    repeat
        hasCollision = false
        for i, e in ipairs( Entity.all ) do
            if i ~= self.id then
                local collision = self.collider:collide( e.collider )
                if collision ~= nil then
                    self:setPosition( self.x + collision.x * collision.depth, self.y + collision.y * collision.depth )
                    hasCollision = true
                end
            end
        end
    until not hasCollision
end

Mobile.setPosition = function( self, x, y )
    self.x = x
    self.y = y
    self.collider:setPosition( x, y )
end