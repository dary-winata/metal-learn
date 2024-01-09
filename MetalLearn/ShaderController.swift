//
//  ShaderController.swift
//  MetalLearn
//
//  Created by dary winata nugraha djati on 15/07/23.
//

import Metal

class ShaderController {
    let device = MTLCreateSystemDefaultDevice() //setup metal device
    var metalLibrary : MTLLibrary? //create metal library
    var vertexFunction : MTLFunction? //load vertex from library
    var fragmentFunction : MTLFunction?
    
    
    init() {
        metalLibrary = device?.makeDefaultLibrary()
        vertexFunction = metalLibrary?.makeFunction(name: "vertexShader")
        fragmentFunction = metalLibrary?.makeFunction(name: "fragmentShader")
    }
}
