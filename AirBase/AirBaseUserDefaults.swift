//
//  AirBaseUserDefaults.swift
//  AirBase
//
//  Created by Sai Prasad on 26/06/24.
//

import Foundation

class AirBaseUserDefaults {
    
    class func set(_ value:Any?,forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    class func value(forKey: String) -> Any? {
        return UserDefaults.standard.value(forKey: forKey)
    }
}
