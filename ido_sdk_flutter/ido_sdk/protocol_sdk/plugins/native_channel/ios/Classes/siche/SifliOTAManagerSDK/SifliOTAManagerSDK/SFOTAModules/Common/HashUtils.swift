import UIKit
import CommonCrypto

class HashUtils: NSObject {
    
    static func CalculateMD5(data: Data) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { bytes in
            _ = CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        var md5String = ""
        for byte in digest {
            md5String += String(format: "%02x", byte)
        }
        return md5String
    }
}
