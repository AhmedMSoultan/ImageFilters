//
//  CustomShaderButton.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 02/12/2023.
//

import SwiftUI

struct CustomShaderButton: View {
    @Binding var targetImage: UIImage
    @State var sourceImage: UIImage
    @Binding var selectedFilter: FilterFunction?
    
    var filter: FilterFunction?
    let metalShader = MetalShader()
    
    
    var body: some View {
        Button(action: {
            if let filter = filter {
                selectedFilter = filter
                metalShader.applyFilter(filter: filter, to: sourceImage) { resultImage in
                    if let resultImage = resultImage {
                        targetImage = resultImage
                    }
                }
            } else {
                selectedFilter = nil
                targetImage = sourceImage
            }
        }, label: {
            VStack {
                Image(uiImage: sourceImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .frame(width: 70, height: 70)
                    .onAppear {
                        if let filter = filter {
                            metalShader.applyFilter(filter: filter, to: sourceImage) { resultImage in
                                if let resultImage = resultImage {
                                    self.sourceImage = resultImage
                                }
                            }
                        }
                    }
                
                if let filter = filter {
                    Text("\(filter.rawValue)")
                        .foregroundStyle(.black)
                        .font(.caption2)
                } else {
                    Text("default")
                        .foregroundStyle(.black)
                        .font(.caption2)
                }
            }
        })
    }
}

#Preview {
    CustomShaderButton(targetImage: .constant(UIImage(named: "Dog")!),
                       sourceImage: UIImage(named: "Dog")!,
                       selectedFilter: .constant(.customFilter1))
}
