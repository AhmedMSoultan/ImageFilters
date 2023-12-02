//
//  FiltersView.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 02/12/2023.
//

import SwiftUI
import MetalPetal

struct FiltersView: View {
    
    @State var inputImage = UIImage(named: "Dog")!
    @State var currentFilter: MTIUnaryFilter = MTIColorInvertFilter()
    @State var filterStrength: Double = 1.0
    let sourceImage = UIImage(named: "Dog")!
    let filters: [MTIUnaryFilter] = [
        MTIColorHalftoneFilter(),
        MTIColorInvertFilter(),
        MTIDotScreenFilter(),
        MTICLAHEFilter()
    ]
    
    var body: some View {
        VStack {
            Image(uiImage: inputImage)
                .resizable()
                .cornerRadius(8)
            
            HStack {
                Text("Filters")
                    .font(.caption)
                    .bold()
                Spacer()
            }
            .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    FilterButton(targetImage: $inputImage,
                                 sourceImage: sourceImage,
                                 filter: nil)
                    .frame(width: 70, height: 70)
                    
                    ForEach(filters.indices) { index in
                        FilterButton(targetImage: $inputImage,
                                     sourceImage: sourceImage,
                                     filter: filters[index])
                        .frame(width: 70, height: 70)
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    FiltersView()
}
