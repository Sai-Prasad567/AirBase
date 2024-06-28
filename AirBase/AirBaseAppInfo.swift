//
//  AirBaseAppInfo.swift
//  AirBase
//
//  Created by Sai Prasad on 24/06/24.
//

import Foundation
import UIKit

class AirBaseAppInfo: NSObject {
    
    static let shared = AirBaseAppInfo()
    
    func appBundleIdentifier() -> String
    {
        #if os(iOS)
        return Bundle.main.bundleIdentifier ?? ""
        #else
        return ""
        #endif
    }
    func appName() -> String
    {
        #if os(iOS)
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        #else
        return ""
        #endif
    }
    
    
    func appVersion() -> String
    {
        #if os(iOS)
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        #else
        return ""
        #endif
    }
    
    func DeviceModel() -> String
    {
        #if os(iOS)
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
        #else
        return ""
        #endif
    }
}
