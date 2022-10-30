//
//  splashview2.swift
//  Solar Boost
//
//  Created by Pallavi Naravane on 10/30/22.
//



import SwiftUI
import UIKit
import CoreVideo


struct splashview2: View {
    var body: some View {
        
        
        NavigationView(content: {
                VStack  {
                    Text("Solar Panel Tilt Calculator")
                        .font(.title)
                        .padding()
                    
                    Image("25")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        
                    ScrollView {
                        Text("To calculate the tilt, we need to know the latitude of a place. Latitude is a coordinate that specifies the north–south position of a point on the surface of the Earth. 69 miles is one degree of latitude.")
                            .font(.title3)
                            .padding()
                        
                        
                        Text("In this app, the user can select their town, and that pulls up the latitude of the place and it calculates the tilt of the solar panels for that month. It also shows the energy output if you choose to use only one tilt setting for all of winter, summer, spring and fall.")
                            .font(.title3)
                            .padding()
                        
                        
                        Text("Changing the tilt of the solar panels can increase your energy production by upto 40%.")
                            .font(.title3)
                            .padding()
                        
                        NavigationLink(destination: ContentView(), label: {
                            Text("Get Started")
                        })
                        .foregroundColor(Color.white)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(35)
                        
                    }
                    .padding(.top)
                    
                }
                .padding(.top)
        })
        
    }
        
}

struct splashview2_Previews: PreviewProvider {
    static var previews: some View {
        splash_screen()
    }
}
