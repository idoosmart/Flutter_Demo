//
//  Transform.h
//  flutter_bluetooth
//
//  Created by lux on 2022/9/1.
//

import Foundation

public protocol SSCoadble: Codable{
    func toDict()->Dictionary<String, Any>?
    func toData()->Data?
    func toString()->String?
}

public extension SSCoadble{
    
    func toData()->Data?{
        return try? JSONEncoder().encode(self)
    }
    
    func toDict()->Dictionary<String, Any>? {
        if let data = toData(){
            do{
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            }catch{
                 debugPrint(error.localizedDescription)
                return nil
            }
        }else{
            debugPrint("model to data error")
            return nil
        }
    }
    
    func toString()->String?{
        if let data = try? JSONEncoder().encode(self),let x = String.init(data: data, encoding: .utf8){
            return x
        }else{
            return nil
        }
    }
}

extension Data {
    /// 转 string
    func toString(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    func toBytes()->[UInt8]{
        return [UInt8](self)
    }
    
    func toDict()->Dictionary<String, Any>? {
        do{
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    /// 从给定的JSON数据返回一个基础对象。
    func toObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    /// 指定Model类型
    func toModel<T>(_ type:T.Type) -> T? where T:Decodable {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch  {
            print("data to model error")
            return nil
        }
    }
}

extension Dictionary {

    /// key是否存在在字典中
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    /// 移除key对应的value
    mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }
    /// 字典转Data
    func toData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    /// 字典转json
    func toJson(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    func toModel<T>(_ type: T.Type) -> T? where T: Decodable {
        return self.toData()?.toModel(T.self)
    }
}

extension Array{
    /// 字典转json
    func toJson(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension String {
    /// 初始化 base64
    func toModel<T>(_ type: T.Type) -> T? where T: Decodable {
        guard let data = data(using: .utf8) else {
            return nil
        }
       return data.toModel(type)
    }
    
    func toDictionary() -> [String:Any]?{
        guard let data = data(using: .utf8) else {
            return Dictionary()
        }
        return data.toDict()
    }
}
