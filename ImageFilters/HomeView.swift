//
//  HomeView.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 01/12/2023.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        List {
            NavigationLink(destination: CustomShadersView()) {
                Text("Custom Shaders")
            }
            
            NavigationLink(destination: FiltersView()) {
                Text("Custom filters")
            }
            
            NavigationLink(destination: CollageView()) {
                Text("Make Collage")
            }
        }
        .navigationTitle("Photo Editor")
    }
}

#Preview {
    HomeView()
}
