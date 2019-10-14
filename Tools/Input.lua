Input = {
    keys = {
        LEFT  = 'a',
        RIGHT = 'd',
        UP    = 'w',
    }
}

local held = {}
local released = {}
local cursor = {
    x = 0,
    y = 0,
    leftHeld = nil,
    rightHeld = nil
}

-- LOVE CALLBACKS
love.keypressed = function ( _, code )
    held[ code ] = 0
end

love.keyreleased = function( _, code )
    if held[ code ] then
        held[ code ] = nil
    end
end

love.mousemoved = function( x, y )
    cursor.x = x
    cursor.y = y
end

love.mousepressed = function( x, y, button )
    if button == 2     then cursor.rightHeld = 0
    elseif button == 1 then cursor.leftHeld  = 0
    end
end

love.mousereleased = function( x, y, button )
    if button == 2     then cursor.rightHeld = nil
    elseif button == 1 then cursor.leftHeld  = nil
    end
end

-- STATIC FUNCTIONS
Input.update = function( dt )
    for k, v in pairs( held )     do held[ k ] = v + dt  end
    for k, _ in pairs( released ) do released[ k ] = nil end

    if cursor.leftHeld ~= nil  then cursor.leftHeld  = cursor.leftHeld + dt  end
    if cursor.rightHeld ~= nil then cursor.rightHeld = cursor.rightHeld + dt end
end


Input.isPressed  = function( key ) return held[ key ] == 0 end
Input.isHeldDown = function( key ) return held[ key ]      end
Input.isReleased = function( key ) return released[ key ]  end

Input.getMouseX = function() return cursor.x end
Input.getMouseY = function() return cursor.y end
Input.leftClick  = function() return cursor.leftHeld == 0  end
Input.rightClick = function() return cursor.rightHeld == 0 end
Input.leftLongPress  = function() return cursor.leftHeld  end
Input.rightLongPress = function() return cursor.rightHeld end