//
//  MetalView.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 01/12/2023.
//

import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    let image: UIImage
    
    func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.isOpaque = false
        
        // Set up Metal shader
        let shader = MetalShader()
        shader.applyFilter(to: image) { filteredImage in
            DispatchQueue.main.async {
                metalView.drawableSize = CGSize(width: filteredImage?.size.width ?? 0,
                                                height: filteredImage?.size.height ?? 0)
                metalView.setNeedsDisplay()
            }
        }
        
        metalView.delegate = shader
        
        return metalView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        // Update Metal view if needed
    }
}

#Preview {
    MetalView(image: UIImage(named: "Dog")!)
}
