Sprite = {}
Sprite.__index = Sprite

Sprite.sheets = {}

Sprite.init = function()
    local lfs = love.filesystem
    local dir = 'Resources/SpriteSheets'
    for _, filename in ipairs( lfs.getDirectoryItems( dir ) ) do
        local ext  = filename:sub( filename:find( '%.[a-z]+' ) )
        if lfs.getInfo( dir .. '/' .. filename ).type == 'file' and ext == '.lua' then
            local noExt = filename:sub( 0, filename:find( ext ) - 1 )
            local sheet = require( dir .. '/' .. noExt )
            sheet.image = love.graphics.newImage( dir .. '/' .. noExt .. '.png' )
            sheet.quad  = love.graphics.newQuad( 0, 0, sheet.tileSize, sheet.tileSize, sheet.image:getDimensions() )
            Sprite.sheets[ noExt ] = sheet
        end
    end
end

Sprite.new = function( sheet )
    local new = {}
    new.sheet = Sprite.sheets[ sheet ]
    new.frame = 0
    new.dt    = 0
    new.px    = 0.5
    new.py    = 0.5
    new.dir   = 1

    for _, v in pairs( new.sheet.anims ) do
        new.anim = v
        break
    end

    setmetatable( new, Sprite )
    return new
end

Sprite.update = function( self, dt )
    if self.anim.speed == 0 or self.anim.count == 1 then
        return
    end

    self.dt = self.dt + dt
    if self.dt >= self.anim.speed then
        self.dt = self.dt - self.anim.speed
        self.frame = ( self.frame + 1 ) % self.anim.count
    end
end

Sprite.draw = function( self, x, y )
    local size = self.sheet.tileSize
    local qx, qy, w, h, sw, sh = self.sheet.quad:getViewport()
    qx = self.frame * size
    qy = self.anim.offset * size
    self.sheet.quad:setViewport( qx, qy, w, h, sw, sh );
    love.graphics.draw( self.sheet.image, self.sheet.quad, x, y, 0, self.dir, 1, size * self.px, size * self.py )
end

Sprite.play = function( self, name )
    if self.sheet.anims[ name ] == nil or self.sheet.anims[ name ] == self.anim then return end

    self.anim  = self.sheet.anims[ name ]
    self.frame = 0
    self.dt    = 0
end