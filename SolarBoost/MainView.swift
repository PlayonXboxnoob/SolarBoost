//
//  MainView.swift
//  Solar Boost
//
//  Created by Pallavi Naravane on 10/29/22.
//

import SwiftUI
import CoreLocation

func getMonth() -> Int {
    return Calendar.current.dateComponents([.month], from: Date()).month! - 1
}

struct MainView: View{
    
    @StateObject var mapData = MapViewModel()
    
    //Location manager
    @State var locationManager = CLLocationManager()
    
    @State private var showInformation = false
    
    let months: [String] = ["January", "February", "March", "April",
                              "May", "June", "July", "August", "September",
                              "October", "November", "December"]
        
    let monthsAdd: [Double] = [10.0, 5.0, 0.0, -5.0, -10.0, -15.0, -10.0, -5.0, 0.0, 5.0, 10.0, 15.0]
    
    var body: some View{
        
        ZStack{
            
            //MapView
            MapView()
            //using mapData as environment object so that it can be used in its sub-views...
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            
            VStack{
                
                VStack(spacing: 0){
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $mapData.searchText)
                            .colorScheme(.light)
                        
                        Button(action:{
                            
                            showInformation.toggle()
                            
                        }) {
                            Image(systemName: "info.circle")
                                .renderingMode(.original)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .padding()
                    
                    //Displaying information
                    if showInformation {
                        
                        ScrollView{
                            VStack{
                                Text("Solar Panel Tilt Calculator")
                                    .font(.title)
                                    .padding()
                                    
                                
                                Text("To calculate the tilt, we need to know the latitude of a place. Latitude is a coordinate that specifies the north–south position of a point on the surface of the Earth. 69 miles is one degree of latitude.")
                                    .font(.title3)
                                    .padding()
                            
                                     
                                Text("In this app, the user can select their town, and that pulls up the latitude of the place and it calculates the tilt of the solar panels for that month. It also shows the energy output if you choose to use only one tilt setting for all of winter, summer,spring and fall.")
                                    .font(.title3)
                                    .padding()
                                
                                Text("Changing the tilt of the solar panels can increase your energy production by upto 40%.")
                                    .font(.title3)
                                    .padding()
                            }
                        }
                        .background(Color.white)
                        .padding(.top)
                        
                    } else {
                        
                        //Displaying search results ...
                        if !mapData.searchedPlaces.isEmpty && mapData.searchText != "" {
                            
                            ScrollView{
                                
                                VStack (spacing: 15){
                                    
                                    ForEach(mapData.searchedPlaces){ place in
                                        
                                        Text(place.place.name ?? "")
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading)
                                            .onTapGesture {
                                                mapData.selectPlace(place: place)
                                            }
                                        
                                        Divider()
                                        
                                    }
                                    
                                }
                                .padding(.top)
                                
                            }
                            .background(Color.white)
                            //.padding()
                        }
                        
                        
                        
                        Spacer()
                        
                        
                        VStack{
                            
                            HStack{
                                Button(action: mapData.focusLocation, label: {
                                    Image(systemName: "location.fill")
                                        .font(.title2)
                                        .padding(10)
                                        .background(Color.primary)
                                        .clipShape(Circle())
                                })
                                
                                Button(action: mapData.updateMapType, label: {
                                    Image(systemName: mapData.mapType == .standard ? "network" : "map")
                                        .font(.title2)
                                        .padding(10)
                                        .background(Color.primary)
                                        .clipShape(Circle())
                                })
                            }
                            //.frame(width: .infinity, alignment: .trailing)
                            
                            Text("Year-round optimal angle: " + mapData.getYearRoundAngle())
                                .font(.title2)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                //.frame(width: .infinity, alignment: .trailing)
                            
                            Text("Optimal angle for month " + months[mapData.selectedMonth] + ": " + mapData.getMonthAngle(monthAdd: monthsAdd[mapData.selectedMonth]))
                                .font(.title3)
                                .foregroundColor(Color.primary)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .onTapGesture(perform: {
                                    mapData.toggleMonth()
                                })
                                //.frame(width: .infinity, alignment: .trailing)
                            
                            
                            if mapData.showMonth {
                                Picker(selection: $mapData.selectedMonth,
                                       label: Text("Select month")) {
                                    ForEach(0 ..< months.count){
                                        Text(months[$0]).tag($0)
                                    }
                                }
                                       .pickerStyle(WheelPickerStyle())
                                       .padding(10)
                                       .background(Color.white)
                                       .onChange(of: mapData.selectedMonth) { _ in
                                           mapData.toggleMonth()
                                       }
                            }
                            
                        }
                    }
                }
            }
            
        }
        .onAppear(perform: {
            
            //Setting delegation...
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
            
            mapData.selectedMonth = getMonth()
            
        })
        //Permission denied alter for user...
        .alert(isPresented: $mapData.permissionDenied, content: {
            
            Alert(title: Text("Permission Denied"), message: Text("Please enable location in app settings"),
                  dismissButton: .default(Text("Goto Settings..."), action: {
                
                //Redirecting user to the app settings
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                
            }))
            
        })
        .onChange(of: mapData.searchText, perform: { value in
            
            // searching places...
            
            
            // delay time for search string, or else it will keep searching continuously
            let delay = 0.3
            
            //asynchronous worker thread call
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                
                //check if value is stored
                if value == mapData.searchText{
                    
                    //search this location...
                    self.mapData.searchPlacesQuery()
                    
                }
                
            })
            
        })
    }
}

struct MainView_Previews: PreviewProvider{
    static var previews: some View{
        MainView()
    }
}
