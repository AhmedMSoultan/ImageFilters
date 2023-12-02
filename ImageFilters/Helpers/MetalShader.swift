//
//  MetalShader.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 01/12/2023.
//

import MetalKit

class MetalShader: NSObject {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private var pipelineState: MTLComputePipelineState!
    
    override init() {
        device = MTLCreateSystemDefaultDevice()!
        commandQueue = device.makeCommandQueue()!
    }
    
    
    func applyFilter(filter: FilterFunction, to inputImage: UIImage, completion: @escaping (UIImage?) -> Void) {
        let shaderLibrary = device.makeDefaultLibrary()!
        let kernelFunction = shaderLibrary.makeFunction(name: filter.rawValue)!
        pipelineState = try! device.makeComputePipelineState(function: kernelFunction)
        let textureLoader = MTKTextureLoader(device: device)
        let imageTexture = try! textureLoader.newTexture(cgImage: (inputImage.cgImage!))
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: imageTexture.pixelFormat,
                                                                         width: imageTexture.width,
                                                                         height: imageTexture.height,
                                                                         mipmapped: false)
        let outputTexture = device.makeTexture(descriptor: textureDescriptor)!
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()!
        
        commandEncoder.setComputePipelineState(pipelineState)
        commandEncoder.setTexture(imageTexture, index: 0)
        commandEncoder.setTexture(outputTexture, index: 1)
        
        let threadGroupSize = MTLSizeMake(16, 16, 1)
        let threadGroups = MTLSizeMake(imageTexture.width / threadGroupSize.width,
                                       imageTexture.height / threadGroupSize.height,
                                       1)
        commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
        
        commandEncoder.endEncoding()
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        let outputImage = outputTexture.toUIImage()
        completion(outputImage)
    }
}

extension MTLTexture {
    func toUIImage() -> UIImage? {
        let width = self.width
        let height = self.height
        let rowBytes = width * 4
        
        let bytesPerRow = rowBytes
        let byteCount = rowBytes * height
        var pixelData = [UInt8](repeating: 0, count: byteCount)
        
        let region = MTLRegionMake2D(0, 0, width, height)
        self.getBytes(&pixelData, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        let providerRef = CGDataProvider(data: NSData(bytes: &pixelData, length: byteCount))
        
        if let cgImage = CGImage(width: width,
                                 height: height,
                                 bitsPerComponent: 8,
                                 bitsPerPixel: 32,
                                 bytesPerRow: bytesPerRow,
                                 space: colorSpace,
                                 bitmapInfo: CGBitmapInfo(rawValue: bitmapInfo),
                                 provider: providerRef!,
                                 decode: nil,
                                 shouldInterpolate: true,
                                 intent: .defaultIntent) {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
}
