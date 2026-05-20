/*
 * CRT Royale Shader (Versión Simple)
 * Efecto CRT para pantallas de TV
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 OutputSize;
uniform vec2 TextureSize;
uniform sampler2D Texture;

void main(void) {
    vec2 uv = gl_FragCoord.xy / OutputSize.xy;
    vec2 texUV = uv * (OutputSize.xy / TextureSize.xy);

    vec3 color = texture2D(Texture, texUV).rgb;

    // Simular scanlines
    float scanline = sin(uv.y * OutputSize.y * 0.5) * 0.04;
    color.rgb -= scanline;

    // Simular curvatura CRT básica
    vec2 center = uv - 0.5;
    float dist = length(center);
    color.rgb *= 1.0 - dist * 0.2;

    gl_FragColor = vec4(color, 1.0);
}
