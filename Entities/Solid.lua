Solid = {}
Solid.__index = Solid
setmetatable( Solid, Collider )

Solid.all = {}

Solid.new = function( x, y, w, h )
    local new = Collider.new( x, y, w, h )

    Solid.all[ #Solid.all + 1 ] = new

    setmetatable( new, Solid )
    return new
end

Solid.draw = function( self )
    love.graphics.setColor( 0.3, 0.3, 0.3 )
    love.graphics.rectangle( 'fill', self.left, self.top, self.w, self.h )
end