//
//  AppDelegateGAD.swift
//  Deprem+
//
//  Created by Hakan Koşanoğlu on 7.07.2020.
//  Copyright © 2020 com.kai. All rights reserved.
//

import Foundation
import GoogleMobileAds

protocol DelegateConfigProtocol {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
}

class AppDelegateGAD: DelegateConfigProtocol {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        

        return true
    }
}

