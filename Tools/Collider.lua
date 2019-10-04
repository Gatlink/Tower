Collider = {}
Collider.__index = Collider
Collider.new = function( x, y, w, h )
    local new = {}
    new.w = math.floor( w ) or 0
    new.h = math.floor( h ) or 0

    setmetatable( new, Collider )
    new:setPosition( x or 0, y or 0 )
    return new
end

Collider.collide = function( self, with )
    local col = { x = 0, y = 0, depth = math.huge }
    local setMin = function( depth, x, y )
        if depth <= 0 then return false end

        if depth < col.depth then
            col.x = x
            col.y = y
            col.depth = depth
        end

        return true
    end

    if not setMin( with.right - self.left,  1,  0 ) then return nil end
    if not setMin( self.right - with.left, -1,  0 ) then return nil end
    if not setMin( with.bottom - self.top,  0,  1 ) then return nil end
    if not setMin( self.bottom - with.top,  0, -1 ) then return nil end

    return col
end

Collider.setPosition = function( self, x, y )
    self:setX( x )
    self:setY( y )
end

Collider.setX = function( self, x )
    self.x = math.floor( x )
    local halfWid = math.floor( self.w / 2 )
    self.left   = x - halfWid
    self.right  = x + halfWid
    self.w = self.right - self.left
end

Collider.setY = function( self, y )
    self.y = math.floor( y )
    local halfHei = math.floor( self.h / 2 )
    self.top    = y - halfHei
    self.bottom = y + halfHei
    self.h = self.bottom - self.top
end