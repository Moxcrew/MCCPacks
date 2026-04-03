#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    
    vertexDistance = fog_distance(Position, FogShape);
    // MCC - moved down
    texCoord0 = UV0;
	
    // MCC start - allow removing shadow
	if (Color == vec4(78/255., 92/255., 36/255., Color.a)) {
        // remove color part
        vertexColor = texelFetch(Sampler2, UV2 / 16, 0);
    } else if (Color == vec4(19/255., 23/255., 9/255., Color.a)) {
        // remove vertex entirely
        vertexColor = vec4(0);
    } else {
        vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    }
    // MCC end - allow removing shadow
}

