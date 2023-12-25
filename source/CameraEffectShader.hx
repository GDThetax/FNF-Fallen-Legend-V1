package;

import flixel.system.FlxAssets.FlxShader;

class CameraEffectShader extends FlxShader
{
	@:glFragmentSource('
	#pragma header

	vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    uniform float iTime;
    uniform float xPosFormula;
    uniform float yPosFormula;
    uniform float zoom;
    uniform float scaleDown;
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    #define fragColor gl_FragColor
    #define mainImage main

    float map(float value, float low1, float high1, float low2, float high2) {
        return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
    }

    void mainImage()
    {
            float rows = 0.275 * zoom;
            float padding = 0.;
            float aspect = 16./9.;
            vec4 color = vec4(1.);
            
            vec2 uv = ((2 * fragCoord + iResolution.xy) / iResolution.y);
            uv.x += xPosFormula / rows;
            uv.y += yPosFormula / rows;
            uv.y *= aspect; // fix aspect ratio
            
            // calc row index to offset x of every other row
            float rowIndex = floor(uv.y * rows);		
            float oddEven = rowIndex;
            
            // create grid coords & set color
            vec2 uvRepeat = fract(uv * rows);
            //uvRepeat = fract(vec2(0.5, 0.) + uv * rows);
            // add padding and only draw once per cell
            uvRepeat *= 1. + padding * 2.;
            uvRepeat -= padding;
            
            // antialias - probably a very long & stupid way of doing it, but its smooth :)
            float alphaX = 1.0;
            float alphaY = 1.0;
            float center = 0.5;
            float repeatThresh = 0.51;	// push out a little so we dont cut any texture off. also helps blend nicely when no padding
            float aa = repeatThresh - center;
            aa *= 0.5;
            float centerDistX = distance(center, uvRepeat.x);
            float centerDistY = distance(center, uvRepeat.y);
            if(centerDistX > repeatThresh - aa) alphaX = map(centerDistX, repeatThresh - aa, repeatThresh + aa, 1., 0.);
            if(centerDistY > repeatThresh - aa) alphaY = map(centerDistY, repeatThresh - aa, repeatThresh + aa, 1., 0.);
            float alpha = min(alphaX, alphaY);
            color = texture(iChannel0, uvRepeat / scaleDown);
            color = mix(vec4(1.), color, alpha);
    
            // draw repeating texture
            fragColor = color;
        }
	')
	public function new()
	{
		super();
	}
}
