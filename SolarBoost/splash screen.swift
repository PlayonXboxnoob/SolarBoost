//
//  splash screen.swift
//  Solar Boost
//
//  Created by Pallavi Naravane on 10/30/22.
//

import SwiftUI

struct splash_screen: View {
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
        if isActive {
            splashview2()
        } else {
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                ZStack {
                    
                    Image("Solar Boost Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea()
                    //
                        
                    
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                    
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration:0.8)) {
                        self.isActive = true
                    }

                }
            }
        }
        
        
        
    }
}

struct splash_screen_Previews: PreviewProvider {
    static var previews: some View {
        splash_screen()
    }
}
