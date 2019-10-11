Vector = {}

Vector.len = function( x, y )
    return math.sqrt( Vector.sqrLen( x, y ) )
end

Vector.sqrLen = function( x, y )
    return x * x + y * y
end

Vector.add = function( ax, ay, bx, by )
    return ax + bx, ay + by
end

Vector.sub = function( ax, ay, bx, by )
    return ax - bx, ay - by
end

Vector.normalize = function( x, y )
    local len = Vector.len( x, y )
    return x / len, y / len
end