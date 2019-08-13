Mobile = {}
Mobile.__index = Mobile
setmetatable( Mobile, Entity )
Mobile.new = function( x, y, w, h, color )
    local new = Entity.new( x, y, w, h, color )

    new.dir = 1

    new.xSpeed = 200
    new.xf = 0.95
    new.dx = 0

    new.gravity = 500
    new.yf = 0.98
    new.dy = 0

    new.collider   = Collider.new( new.x, new.y, new.w, new.h )
    new.collisions = {}

    setmetatable( new, Mobile )
    return new
end

Mobile.update = function( self, dt )
    for i = 0, #self.collisions do self.collisions[ i ] = nil end

    if self.dx ~= 0 then
        self.dir = self.dx > 0 and 1 or -1
    end

    self.dy = self.yf + self.dy * ( 1 - self.yf )
    self:move( self.x + self.dx * self.xSpeed * dt, self.y + self.dy * self.gravity * dt )

end

Mobile.draw = function( self )
    Entity.draw( self )
    love.graphics.setColor( 0, 0, 0 )
    love.graphics.rectangle( 'fill', self.dir == 1 and self.x or self.x - self.w / 2, self.y - 2, self.w / 2, 4 )
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
                    collision.with = e
                    self.collisions[ #self.collisions + 1 ] = collision

                    if collision.x ~= 0 then self.dx = 0 end
                    if collision.y ~= 0 then self.dy = 0 end
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