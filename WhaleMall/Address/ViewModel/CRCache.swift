//
//  YQHGCache.swift
//  TQHG
//
//  Created by wyy on 2022/12/21.
//

import Foundation
//import Cache

/// 本地缓存管理
//public class CRCache: NSObject {
//    private static let diskConfig = DiskConfig(name: "CRCache")
//    private static let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10000, totalCostLimit: 10000)
//    private static let storage = try? Storage<String, Data>.init(diskConfig: CRCache.diskConfig, memoryConfig: CRCache.memoryConfig, transformer: TransformerFactory.forData())
//
//    public static func clearAll() {
//        try? storage?.removeAll()
//    }
//
//    public static func cache(data: Data, key: URL) {
//        try? storage?.setObject(data, forKey: key.absoluteString)
//    }
//
//    public static func cache(data: Data, key: String) {
//        try? storage?.setObject(data, forKey: key)
//    }
//
//    public static func cache<T: Codable>(object: T, key: String) {
//        guard let data = try? JSONEncoder().encode(object) else { return }
//        try? storage?.setObject(data, forKey: key)
//    }
//
//    // MARK: 数据读取
//    public static func fetch(key: String) -> Data? {
//        return try? storage?.object(forKey: key)
//    }
//
//    public static func fetchObject<T: Codable>(key: String, to type: T.Type) -> T? {
//        guard let data = try? storage?.object(forKey: key) else {
//            return nil
//        }
//        let object = try? JSONDecoder().decode(type.self, from: data)
//        return object
//    }
//
//    public static func removeData(for key: String) {
//        try? storage?.removeObject(forKey: key)
//    }
//}

