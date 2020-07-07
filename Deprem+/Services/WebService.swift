//
//  WebService.swift
//  Deprem+
//
//  Created by Hakan Koşanoğlu on 6.07.2020.
//  Copyright © 2020 com.kai. All rights reserved.
//

import Foundation

class WebService {
    
    private var url: URL = URL(string: "https://api.hakankosanoglu.com/earthquake")!
    
    func getData(completion: @escaping ([Earthquake]?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let earthquakes = try? JSONDecoder().decode([Earthquake].self, from: data)
                if let earthquakes = earthquakes {
                    completion(earthquakes)
                }
            }
        }.resume()
    }
}
