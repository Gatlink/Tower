-- Easing methods taken from Peidro Meideros: https://www.patreon.com/posts/animation-easing-8030922
Tween = {}
Tween.lerp   = function( from, to, t, easing )
    return from + ( to - from ) * math.max( 0, math.min( 1, easing and Tween[ easing ] and Tween[ easing ]( t ) or t ) )
end

Tween.cubeIn = function( t ) return t * t * t end

Tween.cubeInOut = function( t )
    if t <= .5 then
        return t * t * t * 4
    else
        t = t - 1
        return 1 + t * t * t * 4
    end
end

Tween.cubeOut = function( t )
    t = t - 1
    return 1 + t * t * t
end

Tween.backIn = function( t )
    return t * t * ( 2.70158 * t - 1.70158 )
end

Tween.backOut = function( t )
    t = t - 1
    return ( 1 - t * t * ( -2.70158 * t - 1.70158 ) )
end

Tween.backInOut = function( t )
    t = t * 2

    if t < 1 then
        return t * t * ( 2.70158 * t - 1.70158 ) / 2
    else
        t = t - 2;
        return ( 1 - t * t * ( -2.70158 * t - 1.70158 ) ) / 2 + .5
    end
end

Tween.elasticIn = function( t )
    return math.sin( 13 * ( math.pi / 2 ) * t ) * math.pow( 2, 10 * ( t - 1 ) )
end

Tween.elasticOut = function( t )
    return math.sin( -13 * ( math.pi / 2 ) * ( t + 1 ) ) * math.pow( 2, -10 * t ) + 1
end

Tween.elasticInOut = function( t )
    if t < 0.5 then
        return 0.5 * ( math.sin( 13 * ( math.pi / 2 ) * ( 2 * t ) ) * math.pow( 2, 10 * ( ( 2 * t ) - 1 ) ) )
    else
        return 0.5 * ( math.sin( -13 * ( math.pi / 2 ) * ( ( 2 * t - 1 ) + 1 ) ) * math.pow( 2, -10 * ( 2 * t - 1 ) ) + 2 )
    end
end