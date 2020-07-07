//
//  Earthquake.swift
//  Deprem+
//
//  Created by Hakan Koşanoğlu on 6.07.2020.
//  Copyright © 2020 com.kai. All rights reserved.
//

import Foundation

struct Earthquake: Decodable {
    let name: String
    let intensity: String
    let latitude: String
    let longitude: String
    var date: String?
}
