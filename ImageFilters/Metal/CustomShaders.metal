//
//  CustomShaders.metal
//  ImageFilters
//
//  Created by Ahmed Soultan on 01/12/2023.
//

#include <metal_stdlib>
using namespace metal;


// Grayscale filter shader function
kernel void grayscaleFilter(texture2d<float, access::read> inputTexture [[texture(0)]],
                            texture2d<float, access::write> outputTexture [[texture(1)]],
                            uint2 gid [[thread_position_in_grid]]) {
    float4 color = inputTexture.read(gid);
    float luminance = dot(color.rgb, float3(0.2126, 0.7152, 0.0722));
    outputTexture.write(float4(luminance, luminance, luminance, color.a), gid);
}

// Sepia tone filter shader function
kernel void sepiaToneFilter(texture2d<float, access::read> inputTexture [[texture(0)]],
                            texture2d<float, access::write> outputTexture [[texture(1)]],
                            uint2 gid [[thread_position_in_grid]]) {
    float4 color = inputTexture.read(gid);
    float3 sepiaColor = float3(0.393, 0.769, 0.189);
    float3 sepia = color.rgb * sepiaColor;
    outputTexture.write(float4(sepia, color.a), gid);
}

// Custom filter 1 shader function
kernel void customFilter1(texture2d<float, access::read> inputTexture [[texture(0)]],
                          texture2d<float, access::write> outputTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    float4 color = inputTexture.read(gid);
    float luminance = dot(color.rgb, float3(0.3, 0.1, 0.9));
    outputTexture.write(float4(luminance, luminance, luminance, color.a), gid);
}

// Custom filter 2 shader function
kernel void customFilter2(texture2d<float, access::read> inputTexture [[texture(0)]],
                          texture2d<float, access::write> outputTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    float4 color = inputTexture.read(gid);
    float4 tintedColor = float4(color.r, color.g, color.b + 0.1, color.a);
    outputTexture.write(tintedColor, gid);
}

// Custom filter 3 shader function
kernel void customFilter3(texture2d<float, access::read> inputTexture [[texture(0)]],
                          texture2d<float, access::write> outputTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    float4 color = inputTexture.read(gid);
    float4 tintedColor = float4(color.r + 0.2, color.g + 0.5, color.b + 0.1, color.a);
    outputTexture.write(tintedColor, gid);
}

// Custom filter 4 shader function
kernel void customFilter4(texture2d<float, access::read> inputTexture [[texture(0)]],
                          texture2d<float, access::write> outputTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    float4 color = inputTexture.read(gid);
    float3 sepiaColor = float3(0.6, 0.4, 0.2);
    float3 sepia = color.rgb * sepiaColor;
    outputTexture.write(float4(sepia, color.a), gid);
}

// Custom filter 5 shader function
kernel void customFilter5(texture2d<float, access::read> inputTexture [[texture(0)]],
                          texture2d<float, access::write> outputTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    float4 color = inputTexture.read(gid);
    float2 center = float2(0.5, 0.5);
    float radius = 0.5;
    float vignette = smoothstep(radius, radius - 0.2, distance(center, float2(gid) / float2(inputTexture.get_width(), inputTexture.get_height())));
    outputTexture.write(color * vignette, gid);
}

// Custom filter 6 shader function
kernel void customFilter6(texture2d<float, access::read> inputTexture [[texture(0)]],
                          texture2d<float, access::write> outputTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    float4 color = float4(0.0);
    for (int i = -5; i <= 5; i++) {
        float2 offset = float2(i, 0) / float2(inputTexture.get_width(), inputTexture.get_height());
        color += inputTexture.read(gid + uint2(offset * float2(inputTexture.get_width(), inputTexture.get_height()))).rgba;
    }
    color /= 4.0;
    outputTexture.write(color, gid);
}

// Custom filter 7 shader function
kernel void customFilter7(texture2d<float, access::read> inputTexture [[texture(0)]],
                          texture2d<float, access::write> outputTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    float4 color = float4(0.0);
    for (int i = -5; i <= 5; i++) {
        float2 offset = float2(0, i) / float2(inputTexture.get_width(), inputTexture.get_height());
        color += inputTexture.read(gid + uint2(offset * float2(inputTexture.get_width(), inputTexture.get_height()))).rgba;
    }
    color /= 11.0;
    outputTexture.write(color, gid);
}

// Custom filter 8 shader function
kernel void customFilter8(texture2d<float, access::read> inputTexture [[texture(0)]],
                          texture2d<float, access::write> outputTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    float4 color = inputTexture.read(gid);
    float4 tintedColor = float4(color.r + 0.1, color.g + 0.1, color.b + 0.1, color.a);
    outputTexture.write(tintedColor, gid);
}

// Custom filter 9 shader function
kernel void customFilter9(texture2d<float, access::read> inputTexture [[texture(0)]],
                          texture2d<float, access::write> outputTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]]) {
    float4 color = float4(0.0);
    for (int i = -5; i <= 5; i++) {
        float2 offset = float2(i, 0) / float2(inputTexture.get_width(), inputTexture.get_height());
        color += inputTexture.read(gid + uint2(offset * float2(inputTexture.get_width(), inputTexture.get_height()))).rgba;
    }
    color /= 11.0;
    outputTexture.write(color, gid);
}

// Custom filter 10 shader function
kernel void customFilter10(texture2d<float, access::read> inputTexture [[texture(0)]],
                           texture2d<float, access::write> outputTexture [[texture(1)]],
                           uint2 gid [[thread_position_in_grid]]) {
    float4 color = inputTexture.read(gid);
    float4 tintedColor = float4(color.r, color.g, color.b + 0.5, color.a);
    outputTexture.write(tintedColor, gid);
}

