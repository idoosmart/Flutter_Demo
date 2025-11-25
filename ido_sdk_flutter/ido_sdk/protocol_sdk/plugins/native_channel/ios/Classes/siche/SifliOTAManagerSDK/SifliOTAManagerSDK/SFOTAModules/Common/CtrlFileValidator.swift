//
//  CtrlFileValidator.swift
//  SifliOTAManagerSDK
//
//  Created by Sean on 2024/7/9.
//

import UIKit
import CommonCrypto
import Foundation
//import CryptoSwift

class CtrlFileValidateResult:NSObject{
    public let Success:Bool
    public var Message:String?
    init(Success: Bool, Message: String? = nil) {
        self.Success = Success
        self.Message = Message
    }
}

class CtrlFileValidator: NSObject {
    func validateCtrlFile16(ctrlFileData:Data, imageIds:Array<UInt16>) -> CtrlFileValidateResult{
        let imageIds8 = convertUInt16ArrayToUInt8Array(imageIds)
        let result = self.validateCtrlFile(ctrlFileData: ctrlFileData, imageIds: imageIds8)
        return result;
    }
    
    func validateCtrlFile(ctrlFileData:Data, imageIds:Array<UInt8>) -> CtrlFileValidateResult{
      
        let ignoreResult = CtrlFileValidateResult.init(Success: true,Message: "decode fail, ignore ctrl file check.")
        if let indata = self.copyData(from: ctrlFileData, at: 32, length: ctrlFileData.count - 32 - 256){
            let orgDataStr = indata.hexEncodedString();
            OLog("orgdata:\(orgDataStr)");
            if let decodedData =  self.aesDecrypt(chiperData: indata) {
                if(decodedData.count > 0){
                    let decodeDataStr = decodedData.hexEncodedString()
                    OLog("decode data:\(decodeDataStr)");
                    let result = self.ctrlCheck(decodedData: decodedData, imageIds: imageIds)
                    OLog("validateCtrlFile success=\(result.Success)")
                    return result;
                }else{
                    return ignoreResult
                }
            }else{
                return ignoreResult
            }
//            let msg = "validateCtrlFile decode ctrl file error."
//            OLog(msg)
//            let result = CtrlFileValidateResult.init(Success: false,Message: msg)
//            return result;
        }else{
            let msg = "validateCtrlFile ctrlFileData length error"
            let result = CtrlFileValidateResult.init(Success: false,Message: msg)
            return result;
        }
    }
    
    func copyData(from source: Data, at position: Int, length: Int) -> Data? {
        let end = position + length
        guard position >= 0, length >= 0, end <= source.count else {
            // 如果位置或长度不合理，返回空的Data对象
            return nil
        }
        return source.subdata(in: position..<end)
    }
    
    func convertUInt16ArrayToUInt8Array(_ imageIds: [UInt16]) -> [UInt8] {
        return imageIds.map { UInt8($0) }
    }
    
    func ctrlCheck(decodedData:Data,imageIds:Array<UInt8>) ->CtrlFileValidateResult{
        let imageCount = decodedData[15 + 32 + 2]
        OLog("ctrlCheck count  \(imageCount),imageIds count \(imageIds.count)")
        if(imageIds.count != imageCount){
            let msg = "file count error, expect \(imageCount)  receive \(imageIds.count)"
            OLog(msg)
            let result = CtrlFileValidateResult.init(Success: false,Message: msg)
            return result;
        }
        
        var index:Int = 0;
        index += 1;
        index += 4;
        index += 4;
        index += 4;
        
        index += 32;
        index += 2;
        index += 2;
        
        // get count
        
        index += 1;
       
        for i in 0..<imageCount {
            index += 256;
            index += 4;
            index += 2;
            let currentID = decodedData[index];
            // Log.d(TAG, "checkPacketNumber currentID " + currentID);
            let isExistCurrentID = self.isExistImageId(imageIds: imageIds, imageID: currentID)
            if (!isExistCurrentID) {
                let msg = "ctrlCheck can not find ID \(currentID)";
                OLog(msg);
                let result = CtrlFileValidateResult.init(Success: true,Message: msg)
                return result;
            }
            
            index += 1;
        }
        
        let result = CtrlFileValidateResult.init(Success: true)
        return result;
    }
    
    func copyData(from source: Data, at position: Int, length: Int) -> Data {
        let end = position + length
        guard position >= 0, length >= 0, end <= source.count else {
            // 如果位置或长度不合理，返回空的Data对象
            return Data()
        }
        return source.subdata(in: position..<end)
    }
    
    func isExistImageId(imageIds:Array<UInt8>,imageID:UInt8) -> Bool{
        for itemId in imageIds {
            if itemId == imageID {
                return true
            }
        }
        return false
    }
    
//    @available(iOS 13, *)
    func aesDecrypt(chiperData: Data)  -> Data? {
        let aesKey: [UInt8] = [0xE6, 0x92, 0xDF, 0xB5, 0xE8, 0xFA, 0xC2,
                               0x43, 0x78, 0x13, 0x34, 0x5D, 0x1B, 0x4B, 0xE2, 0xB9,
                               0x50, 0x9D, 0xE5, 0xC2, 0xF4, 0x05, 0x62, 0xE6, 0xC8,
                               0x25, 0x85, 0x81, 0x02, 0x59, 0x17, 0x2B]
        
        let iv: [UInt8] = [0x56, 0xCE, 0x4E, 0xC4, 0xC9, 0xDC, 0xF4, 0x11]
        let aesKeyData = Data.init(aesKey)
        let ivData = Data.init(iv + [0x00, 0x00, 0x00, 0x00,0x00, 0x00, 0x00, 0x00])
        let aeskeyStr = aesKeyData.hexEncodedString();
        let ivStr = ivData.hexEncodedString();
        OLog("aeskey:\(aeskeyStr)")
        OLog("iv:\(ivStr)")
        // 原始的 8 字节 IV
//        let originalIv: [UInt8] = [0x56, 0xCE, 0x4E, 0xC4, 0xC9, 0xDC, 0xF4, 0x11]
//        // 扩展到 12 字节
//        let iv: [UInt8] = originalIv + [0x00, 0x00, 0x00, 0x00] // 添加额外的字节以满足长度要求
//        return try aesDecryptCryptoKit(data: data, aesKey: aesKey, iv: iv)
        return decryptAESCTRMode(ciphertext: chiperData, key: aesKeyData, iv: ivData)
    }
    enum EncryptionError: Error {
        case invalidKey
        case invalidNonce
    }
    
    func decryptAESCTRMode(ciphertext: Data, key:Data, iv:Data) -> Data? {
        var cryptorRef: CCCryptorRef?
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        let keyBytes: [UInt8] = [UInt8](key)
        let ivBytes:[UInt8] = [UInt8](iv);
        // 创建加密器
        status = CCCryptorCreateWithMode(
            CCOperation(kCCDecrypt),          // 解密操作
            CCMode(kCCModeCTR),               // CTR 模式
            CCAlgorithm(kCCAlgorithmAES),     // AES 算法
            CCPadding(ccNoPadding),           // CTR 模式不需要填充
            ivBytes,                              // 初始化向量
            keyBytes,                             // 密钥
            key.count,                        // 密钥长度
            nil,                              // 可选的 tweak 数据，CTR 模式不使用
            0,                                // tweak 长度
            0,                                // 数字 1 的数量，CTR 模式不使用
            0,                                // 选项，CTR 模式不使用
            &cryptorRef                       // 指向加密器引用的指针
        )
        
        guard status == kCCSuccess, let cryptor = cryptorRef else {
            return nil
        }
        
        let bufferSize: size_t = CCCryptorGetOutputLength(cryptor, ciphertext.count, true)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        var numBytesDecrypted: size_t = 0
        
        // 解密数据
        status = CCCryptorUpdate(
            cryptor,
            [UInt8](ciphertext),             // 将 Data 转换为 [UInt8] 数组
            ciphertext.count,
            buffer,
            bufferSize,
            &numBytesDecrypted
        )
        
        guard status == kCCSuccess else {
            buffer.deallocate()
            return nil
        }
        
        // 释放加密器
        CCCryptorRelease(cryptor)
        
        // 创建解密后的数据
        let decryptedData = Data(bytes: buffer, count: numBytesDecrypted)
        buffer.deallocate()
        return decryptedData
    }
//    func decryptAESCTRMode(ciphertext: Data, key: Data, iv: Data) -> Data? {
//        do {
//            let aes = try AES(key: key.bytes, blockMode: CTR(iv: iv.bytes), padding: .noPadding)
//            let decryptedBytes = try aes.decrypt(ciphertext.bytes)
//            return Data(decryptedBytes)
//        } catch {
//            print(error)
//            return nil
//        }
//    }
  
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
