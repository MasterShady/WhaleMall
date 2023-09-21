////
////  AddressViewModel.swift
////  YQHG
////
////  Created by wyy on 2023/7/20.
////
//
//import Foundation
//
//struct YQHGAddressListRequest: BaseRequest {
//
//    var routerURL: String {
//        return "/zyq/addressList"
//    }
//
//    var method: YQHGAFHTTPMethod {
//        return .post
//    }
//
//    var optionalParameter: [String : Any]? {
//        var params: [String: Any] = [
//                                     "page": 1,
//                                     "pageSize": 20]
//        return params
//    }
//}
//
//struct YQHGAddAddressRequest: BaseRequest {
//    let uname: String
//    let phone: String
//    let address_area: String
//    let address_detail: String
//    let is_default: Int
//
//    var routerURL: String {
//        return "/zyq/addAddress"
//    }
//
//    var method: YQHGAFHTTPMethod {
//        return .post
//    }
//
//    var optionalParameter: [String : Any]? {
//        let params: [String: Any] = [
//                                     "uname": uname,
//                                     "phone": phone,
//                                     "address_area": address_area,
//                                     "address_detail": address_detail,
//                                     "is_default": is_default,
//        ]
//        return params
//    }
//}
//
//struct YQHGUpdateAddressRequest: BaseRequest {
//    let uname: String
//    let phone: String
//    let address_area: String
//    let address_detail: String
//    let is_default: Int
//    let address_id: Int
//
//    var routerURL: String {
//        return "/zyq/updateAddress"
//    }
//
//    var method: YQHGAFHTTPMethod {
//        return .post
//    }
//
//    var optionalParameter: [String : Any]? {
//        let params: [String: Any] = [
//                                     "uname": uname,
//                                     "phone": phone,
//                                     "address_area": address_area,
//                                     "address_detail": address_detail,
//                                     "is_default": is_default,
//                                     "address_id": address_id,]
//        return params
//    }
//}
//
//struct YQHGDelAddressRequest: BaseRequest {
//    let address_id: Int
//
//    var routerURL: String {
//        return "/zyq/delAddress"
//    }
//
//    var method: YQHGAFHTTPMethod {
//        return .post
//    }
//
//    var optionalParameter: [String : Any]? {
//        let params: [String: Any] = ["address_id": address_id]
//        return params
//    }
//}
//
//class YQHGAddressViewModel: NSObject {
//
//    // 获取地址列表
//    class func loadAddressList(complete: @escaping([AddressListModel]) -> Void) {
//        let request = YQHGAddressListRequest()
//        YQHGNetwork.request(request).responseDecodable { (response: YQHGAFDataResponse<[AddressListModel]>) in
//            switch response.result {
//            case .success(let list):
//                complete(list)
//            case .failure(let error):
//                UMToast.show(error.localizedDescription)
//                complete([])
//            }
//        }
//    }
//
//    // 新增地址
//    class func loadAddAddress( uname: String, phone: String, address_area: String, address_detail: String, is_default: Int , complete: @escaping(Bool) -> Void) {
//
//        let request = YQHGAddAddressRequest(uname: uname, phone: phone, address_area: address_area, address_detail: address_detail, is_default: is_default)
//        YQHGNetwork.request(request).responseServiceObject { obj in
//            if obj.state == .Response_Succ {
//                complete(true)
//            } else {
//                UMToast.show(obj.msg)
//            }
//        }
//    }
//
//    // 更新地址
//    class func loadUpdateAddress( uname: String, phone: String, address_area: String, address_detail: String, is_default: Int , address_id: Int , complete: @escaping(Bool) -> Void) {
//
//        let request = YQHGUpdateAddressRequest(uname: uname, phone: phone, address_area: address_area, address_detail: address_detail, is_default: is_default, address_id: address_id)
//        YQHGNetwork.request(request).responseServiceObject { obj in
//            if obj.state == .Response_Succ {
//                complete(true)
//            } else {
//                UMToast.show(obj.msg)
//            }
//        }
//    }
//
//    // 删除地址
//    class func loadDelAddress(address_id: Int, complete: @escaping(Bool) -> Void) {
//
//        let request = YQHGDelAddressRequest(address_id: address_id)
//        YQHGNetwork.request(request).responseServiceObject { obj in
//            if obj.state == .Response_Succ {
//                complete(true)
//            } else {
//                UMToast.show(obj.msg)
//            }
//        }
//    }
//
//}
