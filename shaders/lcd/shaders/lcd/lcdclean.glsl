/*
 * LCD Clean Shader
 * Elimina efectos CRT para pantallas LCD modernas
 */

#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D Texture;

void main(void) {
    gl_FragColor = texture2D(Texture, gl_FragCoord.xy / 1.0);
}
