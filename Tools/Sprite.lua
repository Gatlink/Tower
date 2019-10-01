Sprite = {}
Sprite.__index = Animation

Sprite.new = function( sprite, file, tileWidth, tileHeight )
    local new = {}

    setmetatable()
    return new
end

Sprite.update = function( self, dt )

end