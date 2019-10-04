Actor = {}
Actor.__index = Actor
Actor.setmetatable( Actor, Collider )

Actor.new = function( x, y, w, h, color )
    local new = Collider.new( x, y, w, h )

    new.color = color

    new.xr = 0
    new.yr = 0

    setmetatable( new, Actor )
    return new
end

Actor.draw = function( self )
    love.graphics.setColor( self.color )
    love.graphics.rectangle( 'fill', self.left, self.top, self.w, self.h )
    love.graphics.setColor( 0, 0, 0 )
    love.graphics.rectangle( 'fill', self.dir == 1 and self.x or self.left, self.y - 2, self.w / 2, 4 )
end

Actor.moveX = function( self, dx )
    self.xr = self.xr + dx
    dx = math.floor( dx )

    if move == 0 then return end

    self.xr = self.xr - dx
    local dir = dx > 0 and 1 or -1

    while dx > 0 do
        self.setX( self.x + dir )

        local correction = 0
        for _, s in ipairs( Solid.all ) do
            local col = self:collideWith( s )
            if col ~= nil then
                correction = col.x * col.depth
            end
        end

        if correction ~= 0 then
            self:setX( self.x + correction )
            break
        else
            dx = dx - dir
        end
    end
end

Actor.moveY = function( self, dy )
    self.yr = self.yr + dy
    dy = math.floor( dy )

    if move == 0 then return end

    self.yr = self.yr - dy
    local dir = dy > 0 and 1 or -1

    while dy > 0 do
        self.setX( self.y + dir )

        local correction = 0
        for _, s in ipairs( Solid.all ) do
            local col = self:collideWith( s )
            if col ~= nil then
                correction = col.y * col.depth
            end
        end

        if correction ~= 0 then
            self:setX( self.y + correction )
            break
        else
            dy = dy - dir
        end
    end
end