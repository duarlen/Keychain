//
//  KeychainManager.swift
//  Keychain
//
//  Created by duarlen on 2021/12/23.
//

import UIKit

public class KeychainManager {

    // map
    private static func buildQueryMap(identifier:String) -> [CFString : Any] {
        var map: [CFString : Any] = [:]
        map[kSecClass] = kSecClassGenericPassword
        map[kSecAttrService] = identifier
        map[kSecAttrAccount] = identifier
        map[kSecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlock
        return map
    }
    
    // 增
    public static func insert(data:Any, identifier:String) -> Bool {
        var map = buildQueryMap(identifier: identifier)
        SecItemDelete(map as CFDictionary)
        map[kSecValueData] = NSKeyedArchiver.archivedData(withRootObject: data)
        return SecItemAdd(map as CFDictionary, nil) == noErr
    }

    // 删
    public static func delete(identifier:String) -> Bool {
        let map = buildQueryMap(identifier: identifier)
        return SecItemDelete(map as CFDictionary) == noErr
    }
    
    // 改
    public static func update(data:Any, identifier:String) -> Bool {
        let map1 = buildQueryMap(identifier: identifier)
        let map2 = [kSecValueData : NSKeyedArchiver.archivedData(withRootObject: data)]
        return SecItemUpdate(map1 as CFDictionary, map2 as CFDictionary) == noErr
    }
    
    // 查
    public static func query(identifier:String) -> Any? {
        var map = buildQueryMap(identifier: identifier)
        map[kSecReturnData] = kCFBooleanTrue
        map[kSecMatchLimit] = kSecMatchLimitOne
        var result: AnyObject?
        let readStatus = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(map as CFDictionary, UnsafeMutablePointer($0))}
        if readStatus == errSecSuccess, let data = result as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        }
        return nil
    }
}
