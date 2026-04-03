#version 150

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat4 TextureMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normalLightValue; // MCC - add output
flat out int isEmissive; // MCC - add output

void main() {
// MCC start - determine if emissive
#ifdef NO_OVERLAY
    isEmissive = 0;
#else
    isEmissive = 1;
#endif
// MCC end - determine if emissive
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
#ifdef NO_CARDINAL_LIGHTING
    vertexColor = Color;
#else
    if (isEmissive == 1) {
        vertexColor = Color;
    } else {
        vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    }
#endif
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    overlayColor = texelFetch(Sampler1, UV1, 0);

    texCoord0 = UV0;
#ifdef APPLY_TEXTURE_MATRIX
    texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
#endif
    // MCC start - pass normal light value
    if (isEmissive == 1) {
        normalLightValue = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(1.0));
    } else {
        normalLightValue = vec4(0, 0, 0, 0);
    }
    // MCC end - pass normal light value
}
