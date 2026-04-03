#version 150

in vec3 Position;
in vec4 Color;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    texCoord0 = UV0;
    // MCC - move down

    // MCC start - change extra colors
    if(distance(Color, vec4(0.0, 0.0, 170.0, 255.0) / 255.0) < 0.05) {
        // dark blue -> magenta
        vertexColor = vec4(0.780, 0.314, 0.741, 1.0);
    } else if(distance(Color, vec4(170.0, 0.0, 0.0, 255.0) / 255.0) < 0.05) {
        // dark_red -> brown
        vertexColor = vec4(0.514, 0.329, 0.196, 1.0);
    } else {
        vertexColor = Color;
    }
    // MCC end - change extra colors
}

// BLACK = [r=0,g=0,b=0]
// DARK_BLUE = [r=0,g=0,b=170]
// DARK_GREEN = [r=0,g=170,b=0]
// DARK_AQUA = [r=0,g=170,b=170]
// DARK_RED = [r=170,g=0,b=0]
// DARK_PURPLE = [r=170,g=0,b=170]
// GOLD = [r=255,g=170,b=0]
// GRAY = [r=170,g=170,b=170]
// DARK_GRAY = [r=85,g=85,b=85]
// BLUE = [r=85,g=85,b=255]
// GREEN = [r=85,g=255,b=85]
// AQUA = [r=85,g=255,b=255]
// RED = [r=255,g=85,b=85]
// LIGHT_PURPLE = [r=255,g=85,b=255]
// YELLOW = [r=255,g=255,b=85]
// WHITE = [r=255,g=255,b=255]