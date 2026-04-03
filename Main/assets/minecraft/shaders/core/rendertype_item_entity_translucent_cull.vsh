#version 150

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec2 texCoord2;

// MCC start - add extra outputs
flat out int hideVertex;
out vec4 lightMapColor;
out vec4 normalLightValue;
// MCC end - add extra outputs

// MCC start - add function to get if GUI
bool isGUI(mat4 ProjMat) {
    return ProjMat[2][3] == 0.0;
}
// MCC end - add function to get if GUI

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
    // MCC - move down
    texCoord0 = UV0;
    texCoord1 = UV1;
    texCoord2 = UV2;
    
    // MCC start - add nearby culling and emissive
    float distToCamera = gl_Position.w;
    if (distToCamera <= 1.4 && !isGUI(ProjMat)) {
        hideVertex = 1;
    } else {
        hideVertex = 0;
    }

    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    vertexColor = Color;
    normalLightValue = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(1.0));
    // MCC end - add nearby culling and emissive
}
