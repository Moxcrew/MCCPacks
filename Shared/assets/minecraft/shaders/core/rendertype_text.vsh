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
	
    // MCC start - add various color-based modifications
    // Remove background from maps
    if (Color == vec4(0/255., 0/255., 0/255., 128/255.)) {
        vertexColor = vec4(0);
        return;
    }

    // Run regular behavior when oustide of a GUI
    if (!isGUI(ProjMat)) {
        vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
        return;
    }

    // Various tweaks to positions and colors for loading screens
    vec4 lightColor = texelFetch(Sampler2, UV2 / 16, 0);

    if (Color == vec4(78/255., 92/255., 37/255., Color.a)) {
		// moments color with shift
        vertexColor = lightColor;
        gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y - 1, Position.z, 1.0);
        return;
    } else if (Color == vec4(78/255., 92/255., 35/255., Color.a)) {
		// loading screen foreground - make GUI scale independent
        vertexColor = vec4(lightColor.xyz, lightColor.w * parseAlpha(Color.a, GameTime));
		int guiScale = guiScale(ProjMat, ScreenSize);
		float screenScalar = max(1920. / ScreenSize.x, 1080. / ScreenSize.y);
        gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y, Position.z + 2000, 1.0);
        gl_Position = vec4(gl_Position.x / guiScale / screenScalar, gl_Position.y / guiScale / screenScalar, gl_Position.z, gl_Position.w);
        return;
    } else if (Color == vec4(78/255., 92/255., 34/255., Color.a)) {
		// loading screen background - scale and animate in background
        vertexColor = vec4(lightColor.xyz, lightColor.w * parseLowAlpha(Color.a, GameTime));
        vec2 vertices[3] = vec2[3](vec2(-1,-1), vec2(3,-1), vec2(-1, 3));
        gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y, Position.z + 2000, 1.0);
        gl_Position = vec4(vertices[gl_VertexID], gl_Position.z, gl_Position.w);
		vec2 texs = gl_Position.xy + vec2(0.5);
		float scaleX = ScreenSize.x / 256;
		float scaleY = ScreenSize.y / 256;
		float mn = min(scaleX, scaleY);
		float scalar = 0.33;
		float xPixel = 1 / ScreenSize.x;
		float yPixel = 1 / ScreenSize.y;
		float xMov = 0; // xPixel * GameTime * 5000;
		float yMov = yPixel * GameTime * 5000;
		texCoord0 = vec2(texs.x / mn / scalar + xMov, -texs.y * (ScreenSize.y / ScreenSize.x) / mn / scalar + yMov);
        return;
    } else if (Color == vec4(78/255., 92/255., 33/255., Color.a)) {
		// loading screen gradient - stretch to screen
        vertexColor = vec4(lightColor.xyz, lightColor.w * parseLowAlpha(Color.a, GameTime));
        vec2 vertices[3] = vec2[3](vec2(-1,-1), vec2(3,-1), vec2(-1, 3));
        gl_Position = vec4(vertices[gl_VertexID], gl_Position.z, gl_Position.w);
		vec2 texs = 0.5 * gl_Position.xy + vec2(0.5);
		texCoord0 = vec2(texs.x, -texs.y);
        return;
    } else if (Color == vec4(78/255., 92/255., 32/255., Color.a)) {
		// loading screen foreground (shifted for image) - make GUI scale independent
        vertexColor = vec4(lightColor.xyz, lightColor.w * parseAlpha(Color.a, GameTime));
		int guiScale = guiScale(ProjMat, ScreenSize);
		float screenScalar = max(1920. / ScreenSize.x, 1080. / ScreenSize.y);
        gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y + 57, Position.z  + 2000, 1.0);
        gl_Position = vec4(gl_Position.x / guiScale / screenScalar, gl_Position.y / guiScale / screenScalar, gl_Position.z, gl_Position.w);
        return;
    } else if (Color.x == 78/255. && Color.y == 91/255.) {
		// loading screen foreground (dynamic Y) - make GUI scale independent
        vertexColor = vec4(lightColor.xyz, lightColor.w * parseAlpha(Color.a, GameTime));
		int guiScale = guiScale(ProjMat, ScreenSize);
		float screenScalar = max(1920. / ScreenSize.x, 1080. / ScreenSize.y);
		int step = 3;
        gl_Position = ProjMat * ModelViewMat * vec4(Position.x, Position.y + (((Color.z * 255) - 64) * step), Position.z + 2000, 1.0);
        gl_Position = vec4(gl_Position.x / guiScale / screenScalar, gl_Position.y / guiScale / screenScalar, gl_Position.z, gl_Position.w);
        return;
    } else if (Color.x == 78/255. && Color.y == 90/255.) {
		// loading screen foreground (dynamic Y & big) - make GUI scale independent
        vertexColor = vec4(lightColor.xyz, lightColor.w * parseAlpha(Color.a, GameTime));
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
    // MCC end - add various color-based modifications
}
