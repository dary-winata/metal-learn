//
//  ContentView.swift
//  MetalLearn
//
//  Created by dary winata nugraha djati on 15/07/23.
//

import SwiftUI

struct ContentView: View {
    //represents the device (usually the GPU) on which Metal will run.
    let device = MTLCreateSystemDefaultDevice()
    
    var body: some View {
        VStack{
            MetalViewRepresentable().ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
