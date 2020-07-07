//
//  EarthquakeViewModel.swift
//  Deprem+
//
//  Created by Hakan Koşanoğlu on 6.07.2020.
//  Copyright © 2020 com.kai. All rights reserved.
//

import Foundation
import MapKit

struct EarthquakeListViewModel {
    let earthquakes: [Earthquake]
}

extension EarthquakeListViewModel {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.earthquakes.count
    }
    
    func earthquakeAtIndex(_ index: Int) -> EarthquakeViewModel {
        let earthquake = self.earthquakes[index]
        return EarthquakeViewModel(earthquake)
    }
    
    func locationAtIndex(_ index: Int) -> CLLocationCoordinate2D {
        let earthquake = EarthquakeViewModel(self.earthquakes[index])
        return CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
    }
}

struct EarthquakeViewModel {
    private let earthquake: Earthquake
}

extension EarthquakeViewModel {
    init(_ earthquake: Earthquake) {
        self.earthquake = earthquake
    }
}

extension EarthquakeViewModel {
    var name: String {
        return self.earthquake.name
    }
    
    var intensity: String {
        return self.getIntensityFromText(self.earthquake.intensity)
    }
    
    var latitude: Double {
        return Double(self.earthquake.latitude) ?? 0.0
    }
    
    var longitude: Double {
        return Double(self.earthquake.longitude) ?? 0.0
    }
    
    var date: String {
        return self.getDateFromText(self.earthquake.intensity)
    }
    
    var intensityColor: UIColor {
        let intensity = Double(getIntensityFromText(self.earthquake.intensity)) ?? 0
        if intensity > 4.5 {
            return UIColor.red
        } else if intensity > 3.5 {
            return UIColor.orange
        } else if intensity > 2.5 {
            return UIColor.orange
        } else {
            return UIColor.label
        }
    }
    
    func getIntensityFromText(_ text: String) -> String {
        let stringOfWordsArray = text.components(separatedBy: " - ")
        var intensity = stringOfWordsArray[0]
        intensity = String(intensity.prefix(3))
        return intensity
    }
    
    func getDateFromText(_ text: String) -> String {
        let stringOfWordsArray = text.components(separatedBy: " - ")
        let date = stringOfWordsArray[1]
        return date
    }
    
}
