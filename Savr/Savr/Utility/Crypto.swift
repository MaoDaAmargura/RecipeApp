//
//  Crypto.swift
//  Savr
//
//  Created by Austin Kelley on 3/10/25.
//

import Foundation
import CommonCrypto

struct Crypto {
    
    static func SHA256(data:Data) -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = data.withUnsafeBytes { bytes in
            CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
    static func hexString(from data:Data) -> String {
        var bytes = [UInt8](repeating: 0, count: data.count)
        (data as NSData).getBytes(&bytes, length: data.count)
        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }
        return hexString
    }
}
