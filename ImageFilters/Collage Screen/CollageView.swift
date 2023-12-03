//
//  CollageView.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 02/12/2023.
//

import SwiftUI

struct CollageView: View {
    @State private var image1: UIImage?
    @State private var image2: UIImage?
    @State private var image3: UIImage?
    @State private var imageNumber = 1
    @State private var isImagePickerPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            
            let path1 = createBezierPath1(width: geometry.size.width, height: geometry.size.height)
            let path2 = createBezierPath2(width: geometry.size.width, height: geometry.size.height)
            let path3 = createBezierPath3(width: geometry.size.width, height: geometry.size.height)
            
            ZStack {
                if let image1 = image1 {
                    BezierPathImageView(image: Image(uiImage: image1), path: path1)
                        .onTapGesture {
                            imageNumber = 1
                            isImagePickerPresented = true
                        }
                } else {
                    path1
                        .fill(.blue)
                        .onTapGesture {
                            imageNumber = 1
                            isImagePickerPresented = true
                        }
                }
                
                if let image2 = image2 {
                    BezierPathImageView(image: Image(uiImage: image2), path: path2)
                        .onTapGesture {
                            imageNumber = 2
                            isImagePickerPresented = true
                        }
                } else {
                    path2
                        .fill(.red)
                        .onTapGesture {
                            imageNumber = 2
                            isImagePickerPresented = true
                        }
                }
                
                if let image3 = image3 {
                    BezierPathImageView(image: Image(uiImage: image3), path: path3)
                        .onTapGesture {
                            imageNumber = 3
                            isImagePickerPresented = true
                        }
                } else {
                    path3
                        .fill(.yellow)
                        .onTapGesture {
                            imageNumber = 3
                            isImagePickerPresented = true
                        }
                }
                
                BezierView { path in
                    // Create combined path for the collage
                    let newPath = createCombinedBezierPath(width: geometry.size.width, height: geometry.size.height)
                    path = newPath
                }
            }
        }
        .frame(width: 300, height: 300, alignment: .center)
        
        .sheet(isPresented: $isImagePickerPresented) {
            switch imageNumber {
            case 1:
                ImagePicker(selectedImage: $image1)
            case 2:
                ImagePicker(selectedImage: $image2)
            default:
                ImagePicker(selectedImage: $image3)
            }
        }
    }
    
    private func createCombinedBezierPath(width: CGFloat, height: CGFloat) -> Path {
        var combinedPath = Path()
        
        // Combine the individual bezier paths
        let path1 = createBezierPath1(width: width, height: height)
        let path2 = createBezierPath2(width: width, height: height)
        let path3 = createBezierPath3(width: width, height: height)
        
        combinedPath.addPath(path1)
        combinedPath.addPath(path2)
        combinedPath.addPath(path3)
        
        return combinedPath
    }
    
    private func createBezierPath1(width: Double, height: Double) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0 , y: 0))
        path.addLine(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
    
    private func createBezierPath2(width: Double, height: Double) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height - 120))
        path.addLine(to: CGPoint(x: width / 2, y: height - 160))
        path.addLine(to: CGPoint(x: width / 2, y: 0))
        path.closeSubpath()
        return path
    }
    
    private func createBezierPath3(width: Double, height: Double) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: width / 2, y: height - 160))
        path.addLine(to: CGPoint(x: width / 2, y: height - 160))
        path.addLine(to: CGPoint(x: width, y: height - 120))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: width / 2, y: height - 160))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CollageView()
}

// MARK: Custom Views

struct BezierView: View {
    let pathProvider: (inout Path) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let path = Path { path in
                pathProvider(&path)
            }
                .stroke(Color.black, lineWidth: 2)
                .frame(width: geometry.size.width, height: geometry.size.height)
            
            path
        }
    }
}

struct BezierPathImageView: View {
    var image: Image
    var path: Path
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(path)
            }
            .contentShape(path)
        }
    }
}

struct PathView: View {
    let path: Path
    let color: Color
    
    var body: some View {
        // Render the path
        path.stroke(.black, lineWidth: 2)
        path.fill(color)
    }
}
