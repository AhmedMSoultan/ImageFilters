//
//  ContentView.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 30/11/2023.
//

import SwiftUI
import Metal
import MetalKit
import CoreImage

struct ContentView: View {
    let startDate = Date()
    @State private var strength = 3.0
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Image with Filter")
                
                Image(systemName: "figure.run.circle.fill")
                    .font(.system(size: 300))
                    .colorEffect(ShaderLibrary.checkerboard(.float(5), .color(.red)))
                
                TimelineView(.animation) { context in
                    Image(systemName: "figure.run.circle.fill")
                        .font(.system(size: 300))
                        .colorEffect(ShaderLibrary.noise(.float(startDate.timeIntervalSinceNow)))
                }
                
                Image("Dog")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .layerEffect(ShaderLibrary.pixellate(.float(10)), maxSampleOffset: .zero)
                
                TimelineView(.animation) { context in
                    Image("Dog")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .distortionEffect(ShaderLibrary.simpleWave(.float(startDate.timeIntervalSinceNow)), maxSampleOffset: .zero)
                }
                
                TimelineView(.animation) { context in
                    Image("Dog")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .visualEffect { content, proxy in
                            content
                                .distortionEffect(ShaderLibrary.complexWave(
                                    .float(startDate.timeIntervalSinceNow),
                                    .float2(proxy.size),
                                    .float(0.5),
                                    .float(8),
                                    .float(10)
                                ), maxSampleOffset: .zero)
                        }
                }
                
                VStack {
                    Image("Dog")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .foregroundStyle(.linearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom))
                        .layerEffect(ShaderLibrary.emboss(.float(strength)), maxSampleOffset: .zero)
                    
                    Slider(value: $strength, in: 0...20)
                }
                .padding()
                
//                MetalView(image: (UIImage(named: "Dog") ?? UIImage(systemName: "photo"))!)
//                    .frame(width: 300, height: 300)
            }
        }
    }
}

#Preview {
    ContentView()
}
