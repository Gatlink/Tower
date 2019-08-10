Input = {
    keys = {
        LEFT  = 'a',
        RIGHT = 'd',
        UP    = 'w',
    },

    held     = {},
    released = {}
}

Input.update = function( self, dt )
    for k, v in pairs( self.held )     do self.held[ k ] = v + dt end
    for k, _ in pairs( self.released ) do self.released[ k ] = nil end
end

Input.keypressed = function ( self, code )
    self.held[ code ] = 0
end

Input.keyreleased = function( self, code )
    if self.held[ code ] then
        self.held[ code ] = nil
    end
end

Input.isPressed  = function( self, key ) return self.held[ key ] == 0 end
Input.isHeldDown = function( self, key ) return self.held[ key ] end
Input.isReleased = function( self, key ) return self.released[ key ] end