Collider = {}
Collider.__index = Collider
Collider.new = function( x, y, w, h )
    local new = {}
    new.w = w or 0
    new.h = h or 0

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
    self.x = x
    self.y = y

    self.left   = x - self.w / 2
    self.right  = x + self.w / 2
    self.top    = y - self.h / 2
    self.bottom = y + self.h / 2
end