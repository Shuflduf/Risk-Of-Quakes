shader_type canvas_item;

#define USE_TWINKLE

group_uniforms stars;
uniform vec3 star_base_color: source_color = vec3(0.8, 1.0, 0.3);
uniform float star_hue_offset: hint_range(0., 1.) = 0.6;
uniform float star_intensity: hint_range(0., 0.2) = 0.08;

#ifdef USE_TWINKLE
uniform float star_twinkle_speed: hint_range(0.0, 2.0) = 0.8;
uniform float star_twinkle_intensity: hint_range(0.0, 1.0) = 0.2;
#endif

group_uniforms movement;
// Higher values move faster. Positive = Left, Negative = Right.
uniform float horizontal_speed: hint_range(-2.0, 2.0) = 0.1;
// How much slower background layers move compared to foreground layers.
uniform float parallax_factor: hint_range(0.1, 1.0) = 0.5;

group_uniforms layers;
uniform float layer_scale: hint_range(0., 60.) = 20.;
uniform float layer_scale_step: hint_range(0., 40.) = 10.;
uniform int layers_count: hint_range(0, 12) = 3;

// Hue credit: DigvijaysinhGohil
vec3 hue(vec3 input, float offset, int range_index) {
    vec4 k = vec4(0., -1./3., 2./3., -1.);
    vec4 p = mix(vec4(input.bg, k.wz), vec4(input.gb, k.xy), step(input.b, input.g));
    vec4 q = mix(vec4(p.xyw, input.r), vec4(input.r, p.yzx), step(p.x, input.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.e-10;
    vec3 hsv = vec3(abs(q.z + (q.w - q.y) / (6. * d + e)), d / (q.x + e), q.x);

    offset = (range_index == 0) ? offset / 360. : offset;
    float h = hsv.x + offset;
    hsv.x = (h < 0.) ? h + 1. : (h > 1.0 ? h - 1. : h);

    vec4 k2 = vec4(1., 2./3., 1./3., 3.);
    vec3 p2 = abs(fract(hsv.xxx + k2.xyz) * 6. - k2.www);
    return hsv.z * mix(k2.xxx, clamp(p2 - k2.xxx, 0., 1.), hsv.y);
}

// Hash and Voronoi credit: Inigo Quilez
vec3 hash(vec3 x) {
    x = vec3(dot(x, vec3(127.1, 311.7, 74.7)),
             dot(x, vec3(269.5, 183.3, 246.1)),
             dot(x, vec3(113.5, 271.9, 124.6)));
    return fract(sin(x) * 43758.5453123);
}

vec2 voronoi(in vec3 x) {
    vec3 p = floor(x);
    vec3 f = fract(x);
    float res = 100.;
    float id = 0.;

    for (float k = -1.; k <= 1.; k += 1.) {
        for (float j = -1.; j <= 1.; j += 1.) {
            for (float i = -1.; i <= 1.; i += 1.) {
                vec3 b = vec3(i, j, k);
                vec3 r = vec3(b) - f + hash(p + b);
                float d = dot(r, r);
                if (d < res) {
                    res = d;
                    id = dot(p + b, vec3(0., 57., 113.));
                }
            }
        }
    }
    return vec2(sqrt(res), id);
}

void fragment() {
    vec4 final_color = vec4(0.0);
    
    // 1. FIX STRETCHING: Adjust UV by the screen aspect ratio
    // SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x gives the ratio.
    vec2 aspect_uv = UV;
    aspect_uv.x *= (SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x);

    for (int i = 0; i < layers_count; i++) {
        // 2. PARALLAX MATH
        // i=0 is the "closest" layer (larger scale), i=layers_count is "furthest".
        // We multiply speed by a factor that decreases as i increases.
        float layer_depth = float(i + 1);
        float movement_offset = TIME * horizontal_speed * (1.0 / (layer_depth * parallax_factor));
        
        vec2 shifted_uv = aspect_uv;
        shifted_uv.x += movement_offset;

        vec3 pos = vec3(shifted_uv, 0.0) * (layer_scale + float(i) * layer_scale_step);
        vec2 layer = voronoi(pos);
        vec3 rand = hash(vec3(layer.y));

        float star = 0.0;
        #ifdef USE_TWINKLE
            float twinkle = sin(TIME * PI * star_twinkle_speed + rand.x * TAU);
            twinkle *= star_twinkle_intensity;
            star = smoothstep(star_intensity + star_intensity * twinkle, 0., layer.x);
        #else
            star = smoothstep(star_intensity, 0., layer.x);
        #endif

        vec3 star_rgb = star * hue(star_base_color, rand.y * star_hue_offset, 1);
        
        final_color.rgb += star_rgb;
        final_color.a = max(final_color.a, star);
    }

    COLOR = final_color;
}