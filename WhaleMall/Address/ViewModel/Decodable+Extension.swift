//
//  Decodable+Extension.swift
//  TQHG
//
//  Created by wyy on 2022/12/21.
//

import Foundation

enum CodableError: Error {
    case mismatch
}

struct JSONCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer {
     public func decodeSafe(_ type: String.Type, forKey key: K, defaultValue: String = "") throws -> String {
         if let value = try? decode(type, forKey: key) {
             if value.isEmpty {
                 return defaultValue
             } else {
                 return value
             }
         }
         if let value = try? decode(Int.self, forKey: key) {
             return String(value)
         }
         if let value = try? decode(Double.self, forKey: key) {
             return String(value)
         }
         return defaultValue
     }

     public func decodeSafe(_ type: Int.Type, forKey key: K, defaultValue: Int = 0) throws -> Int {
         if let value = try? decode(type, forKey: key) {
             return value
         }
         if let value = try? decode(String.self, forKey: key) {
             return Int(value) ?? defaultValue
         }
         return defaultValue
     }

     public func decodeSafe(_ type: Float.Type, forKey key: K, defaultValue: Float = 0) throws -> Float {
         if let value = try? decode(type, forKey: key) {
             return value
         }
         if let value = try? decode(String.self, forKey: key) {
             return Float(value) ?? defaultValue
         }
         return defaultValue
     }

     public func decodeSafe(_ type: Bool.Type, forKey key: K, defaultValue: Bool = false) throws -> Bool {
         if let value = try? decode(type, forKey: key) {
             return value
         }
         if let value = try? decode(String.self, forKey: key) {
             if let valueInt = Int(value) {
                 return Bool(valueInt != 0)
             }
             return defaultValue
         }
         if let value = try? decode(Int.self, forKey: key) {
             return Bool(value != 0)
         }
         return defaultValue
     }

     public func decodeSafe(_ type: Double.Type, forKey key: K, defaultValue: Double = 0) throws -> Double {
         if let value = try? decode(type, forKey: key) {
             return value
         }
         if let value = try? decode(String.self, forKey: key) {
             return Double(value) ?? defaultValue
         }
         return defaultValue
     }

     public func decodeSafe(_ type: [Int].Type, forKey key: K, defaultValue: [Int] = []) throws -> [Int] {
         if let value = try? decode(type, forKey: key) {
             return value
         }
         if let value = try? decode([String].self, forKey: key) {
             return value.map { Int($0) ?? 0 }
         }
         return defaultValue
     }

     public func decodeSafe(_ type: [Double].Type, forKey key: K, defaultValue: [Double] = []) throws -> [Double] {
         if let value = try? decode(type, forKey: key) {
             return value
         }
         if let value = try? decode([String].self, forKey: key) {
             return value.map { Double($0) ?? 0.0 }
         }
         return defaultValue
     }

     public func decodeSafe(_ type: [String].Type, forKey key: K, defaultValue: [String] = []) throws -> [String] {
         if let value = try? decode(type, forKey: key) {
             return value
         }
         if let value = try? decode([Int].self, forKey: key) {
             return value.map { String($0) }
         }
         if let value = try? decode([Double].self, forKey: key) {
             return value.map { String($0) }
         }
         return defaultValue
     }

     public func decodeSafe<T>(_ type: [T].Type, forKey key: K, defaultValue: [T] = []) throws -> [T] where T: Decodable {
         if let value = try? decode([T].self, forKey: key) {
             return value
         } else {
             return []
         }
     }
    
    public func decodeSafe(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decodeSafe(type)
    }

    public func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decodeSafe(type, forKey: key)
    }

    public func decodeSafe(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    public func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decodeSafe(type, forKey: key)
    }

    public func decodeSafe(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decodeSafe(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decodeSafe(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension KeyedDecodingContainer {
    public func decodeSafeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T: Decodable {
        return try? decode(type, forKey: key)
    }
}

// MARK: - Data 解码扩展
extension Data {
    func decoded<T: Decodable>(using decoder: JSONDecoder = JSONDecoder(), userInfo: [CodingUserInfoKey: Any]? = nil) throws -> T {
        if let infor = userInfo {
            decoder.userInfo = infor
        }
        return try decoder.decode(T.self, from: self)
    }
}

// MARK: - Encodable 编码扩展
extension Encodable {
    func encoded(using encoder: JSONEncoder = JSONEncoder(), userInfo: [CodingUserInfoKey: Any]? = nil) throws -> Data {
        if let infor = userInfo {
            encoder.userInfo = infor
        }
        return try encoder.encode(self)
    }
}





extension UnkeyedDecodingContainer {

    public mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    public mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {

        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decodeSafe(type)
    }
}

