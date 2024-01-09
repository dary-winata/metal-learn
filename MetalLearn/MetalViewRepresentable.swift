//
//  MetalViewRepresentable.swift
//  MetalLearn
//
//  Created by dary winata nugraha djati on 16/07/23.
//

import SwiftUI
import MetalKit

struct MetalViewRepresentable : UIViewRepresentable {
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        }
        
        func draw(in view: MTKView) {
            let renderPassDetector = view.currentRenderPassDescriptor
            renderPassDetector?.colorAttachments[0].clearColor = MTLClearColorMake(0, 0.5, 0.5, 1.0)
            renderPassDetector?.colorAttachments[0].loadAction = .clear
            renderPassDetector?.colorAttachments[0].storeAction = .store
            
            let commandQueue = view.device?.makeCommandQueue()
            let commandBuffer = commandQueue?.makeCommandBuffer()
            let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDetector!)
            
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            let library = view.device?.makeDefaultLibrary()
            pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
            pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
            var pipelineState : MTLRenderPipelineState? = nil
            
            do {
                pipelineState = try view.device?.makeRenderPipelineState(descriptor: pipelineDescriptor)
            } catch {
                fatalError()
            }
            
            let vertexData = [
                Vertex(position: [-1, -1], color: [1, 0, 0, 1]),
                Vertex(position: [1, -1], color: [0, 1, 0, 1]),
                Vertex(position: [0, 1], color: [0, 0, 1, 1]),
                Vertex(position: [0, 0], color: [1, 0, 0, 1])
            ]
            let vertexBuffer = view.device?.makeBuffer(bytes: vertexData, length: vertexData.count * MemoryLayout<Vertex>.stride, options: [])
            
            renderEncoder?.setRenderPipelineState(pipelineState!)
            renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 4)
            
            renderEncoder?.endEncoding()
            
            commandBuffer?.present(view.currentDrawable!)
            commandBuffer?.commit()
        }
    }
}
