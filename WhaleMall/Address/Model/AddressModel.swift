//
//  AddressModel.swift
//  YQHG
//
//  Created by wyy on 2023/7/20.
//

import Foundation
import HandyJSON

struct AddressModel : HandyJSON {
    init() {
        
    }
    
    var id: Int!
    var uid: Int!
    var uname: String!
    var phone: String!
    var address_area: String!
    var address_detail: String!
    var create_time: String!
    var is_default: Bool!
    
//    enum CodingKeys: String, CodingKey {
//        case id, uid, uname, phone, address_area
//        case address_detail, create_time,is_default
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        id = try container.decodeSafe(Int.self, forKey: .id)
//        uid = try container.decodeSafe(Int.self, forKey: .uid)
//        uname = try container.decodeSafe(String.self, forKey: .uname)
//        phone = try container.decodeSafe(String.self, forKey: .phone)
//        address_area = try container.decodeSafe(String.self, forKey: .address_area)
//        address_detail = try container.decodeSafe(String.self, forKey: .address_detail)
//        create_time = try container.decodeSafe(String.self, forKey: .create_time)
//        is_default = try container.decodeSafe(Bool.self, forKey: .is_default)
//    }
}
