//
//  YQHGAddressManager.swift
//  YQHG
//
//  Created by wyy on 2023/7/21.
//

import Foundation

class CRAddressManager {
    
    static let shared = CRAddressManager()
    
    private let keyAddressInfo = "CR_local_addressModel"
    
    var defaultAddressModel: AddressModel? {
        set {
            guard let info = newValue else { return }
            UserDefaults.standard.set(info.toJSON(), forKey: keyAddressInfo)
        }
        get {
            let json = UserDefaults.standard.dictionary(forKey: keyAddressInfo)
            return AddressModel.deserialize(from: json)
            
        }
    }
    
    var hasDefaultAddress: Bool {
        if let _ = defaultAddressModel {
            return true
        }
        return false
    }
}
