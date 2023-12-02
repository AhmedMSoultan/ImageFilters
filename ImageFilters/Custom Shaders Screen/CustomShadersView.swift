//
//  CustomShadersView.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 01/12/2023.
//

import SwiftUI

struct CustomShadersView: View {
    @State var filteredImage = UIImage(named: "Dog")!
    var sourceImage = UIImage(named: "Dog")!
    @State var selectedFilter: FilterFunction?
    let metalShader = MetalShader()
    
    var body: some View {
        VStack {
            Image(uiImage: filteredImage)
                .resizable()
                .onAppear() {
                    if let selectedFilter = selectedFilter {
                        metalShader.applyFilter(filter: selectedFilter ,to: filteredImage) { resultImage in
                            if let resultImage = resultImage {
                                filteredImage = resultImage
                            }
                        }
                    } else {
                        filteredImage = sourceImage
                    }
                }
                .cornerRadius(8)
            
            HStack {
                Text("Shaders")
                    .font(.caption)
                    .bold()
                Spacer()
            }
            .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    CustomShaderButton(targetImage: $filteredImage,
                                       sourceImage: sourceImage,
                                       selectedFilter: $selectedFilter,
                                       filter: nil)
                    
                    ForEach(FilterFunction.allCases, id: \.rawValue) { filter in
                        CustomShaderButton(targetImage: $filteredImage,
                                           sourceImage: sourceImage,
                                           selectedFilter: $selectedFilter,
                                           filter: filter)
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    CustomShadersView()
}
