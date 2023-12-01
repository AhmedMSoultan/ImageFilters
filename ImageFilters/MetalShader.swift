//
//  MetalShader.swift
//  ImageFilters
//
//  Created by Ahmed Soultan on 01/12/2023.
//

import MetalKit

class MetalShader: NSObject, MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        
    }
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLComputePipelineState
    
    var inputTexture: MTLTexture?
    var outputTexture: MTLTexture?
    
    override init() {
        device = MTLCreateSystemDefaultDevice()!
        commandQueue = device.makeCommandQueue()!
        
        let shaderLibrary = device.makeDefaultLibrary()!
        let kernelFunction = shaderLibrary.makeFunction(name: "grayscaleFilter")!
        pipelineState = try! device.makeComputePipelineState(function: kernelFunction)
    }
    
    func applyFilter(to image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let inputCGImage = image.cgImage else {
            completion(nil)
            return
        }
        let inputSize = CGSize(width: inputCGImage.width, height: inputCGImage.height)
        
        // Create Metal textures from input and output images
        inputTexture = try? makeTexture(from: inputCGImage)
        outputTexture = try? makeOutputTexture(size: inputSize)
        
        guard let inputTexture = inputTexture,
              let outputTexture = outputTexture,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let commandEncoder = commandBuffer.makeComputeCommandEncoder() else {
            completion(nil)
            return
        }
        
        commandEncoder.setComputePipelineState(pipelineState)
        commandEncoder.setTexture(inputTexture, index: 0)
        commandEncoder.setTexture(outputTexture, index: 1)
        
        let threadGroupSize = MTLSizeMake(16, 16, 1)
        let threadGroups = MTLSizeMake(inputTexture.width / threadGroupSize.width,
                                       inputTexture.height / threadGroupSize.height,
                                       1)
        commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
        commandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        guard let outputTextureData = outputTexture.toPixelBuffer(),
              let outputImage = UIImage(pixelBuffer: outputTextureData) else {
            completion(nil)
            return
        }
        
        completion(outputImage)
    }
    
    private func makeTexture(from cgImage: CGImage) throws -> MTLTexture {
        let textureLoader = MTKTextureLoader(device: device)
        let textureOptions: [MTKTextureLoader.Option: Any] = [
            .origin: MTKTextureLoader.Origin.bottomLeft,
            .SRGB: false
        ]
        
        return try textureLoader.newTexture(cgImage: cgImage, options: textureOptions)
    }
    
    private func makeOutputTexture(size: CGSize) throws -> MTLTexture {
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
                                                                        width: Int(size.width),
                                                                        height: Int(size.height),
                                                                        mipmapped: false)
        textureDescriptor.usage = [.shaderWrite, .shaderRead]
        
        guard let texture = device.makeTexture(descriptor: textureDescriptor) else {
            throw NSError(domain: "MetalShader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create output texture"])
        }
        
        return texture
    }
}

extension UIImage {
    convenience init?(pixelBuffer: CVPixelBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        self.init(cgImage: cgImage)
    }
}

extension MTLTexture {
    func toPixelBuffer() -> CVPixelBuffer? {
        let width = self.width
        let height = self.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let dataSize = bytesPerRow * height
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddress = CVPixelBufferGetBaseAddress(buffer)
        let textureData = self.buffer?.contents()
        
        memcpy(baseAddress, textureData, dataSize)
        
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
