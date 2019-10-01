Sprite = {}
Sprite.__index = Sprite

Sprite.cachedImages = {}

Sprite.initCache = function()
    print( 'load sheets' )
    local lfs = love.filesystem
    local dir = 'Resources/SpriteSheets'
    for _, filename in ipairs( lfs.getDirectoryItems( dir ) ) do
        local file = dir .. '/' .. filename
        local ext  = file:sub( file:find( '%.[a-z]+' ) )
        if lfs.getInfo( file ).type == 'file' and ext == '.lua' then
            local noExt = file:sub( 0, file:find( ext ) - 1 )
            local sheet = require( noExt )
            sheet.image = love.graphics.newImage( noExt .. '.png' )
            Sprite.cachedImages[ #Sprite.cachedImages + 1 ] = sheet
        end
    end
end

Sprite.new = function( sprite, file, tileWidth, tileHeight )
    local new = {

    }

    setmetatable()
    return new
end

Sprite.update = function( self, dt )

end