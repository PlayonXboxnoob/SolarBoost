//
//  splash screen.swift
//  Solar Boost
//
//  Created by Pallavi Naravane on 10/30/22.
//

import SwiftUI



extension UserDefaults {
    
    var welcomeScreenShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "welcomeScreenShown") as? Bool) ?? false
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "welcomeScreenShown")
        }
    }
    
}

struct splash_screen: View {
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    
    var body: some View {
        
        if isActive {
            if UserDefaults.standard.welcomeScreenShown {
                MainView()
            } else {
                splashview2()
            }

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
                        
                        Text("The formula for angle in the northern hemisphere is:")
                            .font(.title3)
                        
                        Text("1.3793 + latitude * (1.2011 + latitude * (-0.014404 + latitude * 0.000080509)). ")
                            .font(.title3)
                            .padding()
                        
                        Text("The formula for the southern hemisphere is: ")
                            .font(.title3)
                        
                        Text("-0.41657 + latitude * (1.4216 + latitude * (0.024051 + latitude * 0.00021828)))")
                            .font(.title3)
                            .padding()
                        
                        
                        
                        NavigationLink(destination: {
                            ContentView()
                            
                        }, label: {
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
                .onAppear(perform: {
                    UserDefaults.standard.welcomeScreenShown = true
                })
        })
        
    }
        
}

struct splash_screen_Previews: PreviewProvider {
    static var previews: some View {
        splash_screen()
    }
}
