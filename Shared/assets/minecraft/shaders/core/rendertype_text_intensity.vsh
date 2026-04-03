#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <mcc:utils.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform vec2 ScreenSize;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
    // MCC - moved down
    texCoord0 = UV0;

    // MCC start - add various color-based modifications for loading screens
    vec4 lightColor = texelFetch(Sampler2, UV2 / 16, 0);

    if (Color == vec4(78/255., 92/255., 35/255., Color.a)) {
		// loading screen foreground (text) - make GUI scale independent
        vertexColor = vec4(lightColor.xyz, lightColor.w * parseAlpha(Color.a, GameTime));
		int guiScale = guiScale(ProjMat, ScreenSize);
		float screenScalar = max(1920. / ScreenSize.x, 1080. / ScreenSize.y);
        gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y, Position.z + 2000, 1.0);
        gl_Position = vec4(gl_Position.x / guiScale / screenScalar, gl_Position.y / guiScale / screenScalar, gl_Position.z, gl_Position.w);
        return;
    } else if (Color.x == 78/255. && Color.y == 91/255.) {
        vertexColor = vec4(lightColor.xyz, lightColor.w * parseAlpha(Color.a, GameTime));
		int guiScale = guiScale(ProjMat, ScreenSize);
		float screenScalar = max(1920. / ScreenSize.x, 1080. / ScreenSize.y);
		int step = 3;
        gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y + (((Color.z * 255) - 64) * step), Position.z + 2000, 1.0);
        gl_Position = vec4(gl_Position.x / guiScale / screenScalar, gl_Position.y / guiScale / screenScalar, gl_Position.z, gl_Position.w);
        return;
    } else if (Color.x == 78/255. && Color.y == 90/255.) {
		// loading screen foreground (dynamic Y, yellow & big) - make GUI scale independent
        vertexColor = vec4(254/255., 231/255., 97/255., lightColor.w * parseAlpha(Color.a, GameTime)); // hardcode as yellow
		int guiScale = guiScale(ProjMat, ScreenSize);
		float screenScalar = max(1920. / ScreenSize.x, 1080. / ScreenSize.y);
		int step = 3;
		float scale = 2.0;
        gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y + (((Color.z * 255) - 64) * step), Position.z + 2000, 1.0);
        gl_Position = vec4(gl_Position.x / guiScale / screenScalar * scale, gl_Position.y / guiScale / screenScalar * scale, gl_Position.z, gl_Position.w);
        return;
    }

    // Fall back to default behavior at the end.
    vertexColor = Color * lightColor;
    // MCC end - add various color-based modifications for loading screens
}

