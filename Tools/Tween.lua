-- Easing methods taken from Peidro Meideros: https://www.patreon.com/posts/animation-easing-8030922
Tween = {}
Tween.lerp   = function( min, max, t, easing )
    return min + ( max - min ) * math.max( 0, math.min( 1, easing and Tween[ easing ] and Tween[ easing ]( t ) or t ) )
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

Tween.easeCubeOut = function( t )
    t = t - 1
    return 1 + t * t * t
end

Tween.easeBackIn = function( t )
    return t * t * ( 2.70158 * t - 1.70158 )
end

Tween.easeBackOut = function( t )
    t = t - 1
    return ( 1 - t * t * ( -2.70158 * t - 1.70158 ) )
end

Tween.easeBackInOut = function( t )
    t = t * 2

    if t < 1 then
        return t * t * ( 2.70158 * t - 1.70158 ) / 2
    else
        t = t - 2;
        return ( 1 - t * t * ( -2.70158 * t - 1.70158 ) ) / 2 + .5
    end
end

Tween.easeElasticIn = function( t )
    return math.sin( 13 * ( math.pi / 2 ) * t ) * math.pow( 2, 10 * ( t - 1 ) )
end

Tween.easeElasticOut = function( t )
    return math.sin( -13 * ( math.pi / 2 ) * ( t + 1 ) ) * math.pow( 2, -10 * t ) + 1
end

Tween.easeElasticInOut = function( t )
    if t < 0.5 then
        return 0.5 * ( math.sin( 13 * ( math.pi / 2 ) * ( 2 * t ) ) * math.pow( 2, 10 * ( ( 2 * t ) - 1 ) ) )
    else
        return 0.5 * ( math.sin( -13 * ( math.pi / 2 ) * ( ( 2 * t - 1 ) + 1 ) ) * math.pow( 2, -10 * ( 2 * t - 1 ) ) + 2 )
    end
end