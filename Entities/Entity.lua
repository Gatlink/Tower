Entity = {}
Entity.__index = Entity
Entity.all = {}
Entity.new = function( x, y, w, h, color )
    local new = {}
    new.x = x or 0
    new.y = y or 0
    new.w = w or 50
    new.h = h or 50
    new.color = color or { 1, 0, 0 }

    new.collider = Collider.new( new.x, new.y, new.w, new.h )

    setmetatable( new, Entity )
    new.id = #Entity.all + 1
    Entity.all[ new.id ] = new
    return new
end

Entity.draw = function( self )
    love.graphics.setColor( self.color )
    love.graphics.rectangle( 'fill', self.x - self.w / 2, self.y - self.h / 2, self.w, self.h )
end