//
//  HomeView.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 01/12/2023.
//

import SwiftUI
import MetalPetal

struct HomeView: View {
    
    @State var inputImage = UIImage(named: "Dog")!
    @State var currentFilter: MTIUnaryFilter = MTIColorInvertFilter()
    @State var filterStrength: Double = 1.0
    let sourceImage = UIImage(named: "Dog")!
    
    var body: some View {
        VStack {
            Image(uiImage: inputImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .cornerRadius(8)
            
            HStack {
                FilterButton(targetImage: $inputImage,
                             sourceImage: sourceImage,
                             filter: nil)
                .frame(width: 70, height: 70)
                
                FilterButton(targetImage: $inputImage,
                             sourceImage: sourceImage,
                             filter: MTIColorInvertFilter())
                .frame(width: 70, height: 70)
                
                FilterButton(targetImage: $inputImage,
                             sourceImage: sourceImage,
                             filter: MTIDotScreenFilter())
                .frame(width: 70, height: 70)
                
                FilterButton(targetImage: $inputImage,
                             sourceImage: sourceImage,
                             filter: MTICLAHEFilter())
                .frame(width: 70, height: 70)
            }
        }
    }
    
    
}

#Preview {
    HomeView()
}
