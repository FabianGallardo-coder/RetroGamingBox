/*
 * CRT Scanlines Shader Simple
 * Una versión simplificada de scanlines para RetroArch
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 Resolution;
uniform sampler2D Texture;

void main(void) {
    vec2 uv = gl_FragCoord.xy / Resolution.xy;
    vec3 color = texture2D(Texture, uv).rgb;

    // Aplicar efecto de scanlines
    float scanline = sin(uv.y * Resolution.y * 1.5) * 0.04;
    color.rgb -= scanline;

    gl_FragColor = vec4(color, 1.0);
}
