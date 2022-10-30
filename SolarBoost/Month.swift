//
//  Month.swift
//  Solar Boost
//
//  Created by Pallavi Naravane on 10/29/22.
//

import SwiftUI

struct Month: View {
    
    @EnvironmentObject var mapData: MapViewModel
    
    @State var showMonth = false
    
    var body: some View{
        
            Form{
                Picker(selection: $mapData.selectedMonth,
                       label: Text("Select month")){
                    ForEach(0 ..< 12){ num in
                        Text(String(num)).tag(num)
                    }
                }
            }
    }
    
    func toggleMonth() {
        showMonth.toggle()
    }
    
}

