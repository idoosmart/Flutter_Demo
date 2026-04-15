//
//  IDODownloadLanguageModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/18.
//

import Foundation

@objcMembers
public class IDODownloadLanguageModel: NSObject, IDOBaseModel {
    /// Current used language
    public var useLang: Int
    /// Default language
    public var defaultLang: Int
    /// Number of fixed stored languages
    public var fixedLang: Int
    /// Maximum stored languages
    public var maxStorageLang: Int
    /// List of stored language values
    public var langArray: [IDODownloadLanguageType]

    enum CodingKeys: String, CodingKey {
        case useLang = "use_lang"
        case defaultLang = "default_lang"
        case fixedLang = "fixed_lang"
        case maxStorageLang = "max_storage_lang"
        case langArray = "lang_array"
    }

    public init(useLang: Int, defaultLang: Int, fixedLang: Int, maxStorageLang: Int, langArray: [IDODownloadLanguageType]) {
        self.useLang = useLang
        self.defaultLang = defaultLang
        self.fixedLang = fixedLang
        self.maxStorageLang = maxStorageLang
        self.langArray = langArray
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOLangArray
@objcMembers
public class IDODownloadLanguageType: NSObject, Codable {
    /// Stored language values, ended by 0
    public var type: Int

    enum CodingKeys: String, CodingKey {
        case type = "type"
    }

    public init(type: Int) {
        self.type = type
    }
}
