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

Collider.lineCollide = function( self, x1, y1, x2, y2 )
    local lineline = function( px1, py1, px2, py2, qx1, qy1, qx2, qy2 )
        local uA = ( ( qx2 - qx1 ) * ( py1 - qy1 ) - ( qy2 - qy1 ) * ( px1 - qx1 ) ) / ( ( qy2 - qy1 ) * ( px2 - px1 ) - ( qx2 - qx1 ) * ( py2 - py1 ) );
        local uB = ( ( px2 - px1 ) * ( py1 - qy1 ) - ( py2 - py1 ) * ( px1 - qx1 ) ) / ( ( qy2 - qy1 ) * ( px2 - px1 ) - ( qx2 - qx1 ) * ( py2 - py1 ) );
        -- ignore extrimities shared by the lines
        if uA > 0 and uA < 1 and uB > 0 and uB < 1 then
            return px1 + uA * ( px2 - px1 ), py1 + uA * ( py2 - py1 )
        end

        return nil
    end

    local lx, ly = lineline( x1, y1, x2, y2, self.left, self.top, self.left, self.bottom )
    local rx, ry = lineline( x1, y1, x2, y2, self.right, self.top, self.right, self.bottom )
    local tx, ty = lineline( x1, y1, x2, y2, self.left, self.top, self.right, self.top )
    local bx, by = lineline( x1, y1, x2, y2, self.left, self.bottom, self.right, self.bottom )

    local points = {}
    if lx then points[ # points + 1 ] = { x = lx, y = ly, dist = Vector.sqrLen( lx - x1, ly - y1 ) } end
    if rx then points[ # points + 1 ] = { x = rx, y = ry, dist = Vector.sqrLen( rx - x1, ry - y1 ) } end
    if tx then points[ # points + 1 ] = { x = tx, y = ty, dist = Vector.sqrLen( tx - x1, ty - y1 ) } end
    if bx then points[ # points + 1 ] = { x = bx, y = by, dist = Vector.sqrLen( bx - x1, by - y1 ) } end

    local closest = nil
    for _, p in ipairs( points ) do
        if not closest or p.dist < closest.dist then
            closest = p
        end
    end

    if closest then
        return closest.x, closest.y, math.sqrt( closest.dist )
    else
        return nil
    end
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