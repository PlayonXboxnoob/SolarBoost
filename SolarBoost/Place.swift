//
//  Place.swift
//  Solar Boost
//
//  Created by Pallavi Naravane on 10/29/22.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    
    var id = UUID().uuidString
    var place: CLPlacemark
}
