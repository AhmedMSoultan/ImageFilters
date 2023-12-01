//
//  FilterButton.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 01/12/2023.
//

import SwiftUI
import MetalPetal

struct FilterButton: View {
    @Binding var targetImage: UIImage
    var sourceImage: UIImage
    var filter: MTIUnaryFilter?
    
    var body: some View {
        Button(action: {
            if let filter = filter {
                targetImage = applyFilter(filter: filter, on: sourceImage)
            } else {
                targetImage = sourceImage
            }
        }, label: {
            if let filter = filter {
                Image(uiImage: applyFilter(filter: filter, on: sourceImage))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(uiImage: sourceImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        })
        .cornerRadius(8)
    }
    
    func applyFilter(filter: MTIUnaryFilter, on image: UIImage) -> UIImage {
        let context = try! MTIContext(device: MTLCreateSystemDefaultDevice()!)
        // Load the input image into a MetalPetal image object
        let input = MTIImage(__cgImage: image.cgImage!, options: [.SRGB: false], isOpaque: true)
        // Create a MetalPetal filter
        filter.inputImage = input
        // Apply the filter
        let output = filter.outputImage!
        // Render the output image to a CGImage
        let cgImage = try! context.makeCGImage(from: output)
        // Convert the CGImage to a UIImage
        let outputImage = UIImage(cgImage: cgImage)
        return outputImage
    }
}

#Preview {
    FilterButton(targetImage: .constant(UIImage(named: "Dog")!), sourceImage: UIImage(named: "Dog")!, filter: MTICLAHEFilter())
}
