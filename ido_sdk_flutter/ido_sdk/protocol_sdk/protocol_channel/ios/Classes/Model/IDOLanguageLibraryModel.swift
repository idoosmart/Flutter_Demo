//
//  IDOLanguageLibraryModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOLanguageLibraryModel
@objcMembers
public class IDOLanguageLibraryModel: NSObject, IDOBaseModel {
    private var version: Int
    /// Currently used language
    public var useLang: Int
    /// Default language
    public var defaultLang: Int
    /// Number of fixed storage languages
    public var fixedLang: Int
    /// Maximum storage languages
    public var maxStorageLang: Int
    private var itemsLen: Int
    private var userLen: Int
    public var items: [IDOLanguageLibraryItem]?
    public var itemsUser: [IDOLanguageLibraryItem]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case useLang = "use_lang"
        case defaultLang = "default_lang"
        case fixedLang = "fixed_lang"
        case maxStorageLang = "max_storage_lang"
        case itemsLen = "items_len"
        case userLen = "user_len"
        case items = "items"
        case itemsUser = "items_user"
    }
    
    public init(useLang: Int, defaultLang: Int, fixedLang: Int, maxStorageLang: Int, items: [IDOLanguageLibraryItem]?, itemsUser: [IDOLanguageLibraryItem]?) {
        self.version = 0
        self.useLang = useLang
        self.defaultLang = defaultLang
        self.fixedLang = fixedLang
        self.maxStorageLang = maxStorageLang
        self.itemsLen = items?.count ?? 0
        self.userLen = itemsUser?.count ?? 0
        self.items = items
        self.itemsUser = itemsUser
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOLanguageLibraryItem
@objcMembers
public class IDOLanguageLibraryItem: NSObject, Codable {
 
    /// Language type
    public var languageType: IDOLanguageType
    /// Language version number
    public var languageVersion: Int
    
    enum CodingKeys: String, CodingKey {
        case languageType = "language_type"
        case languageVersion = "language_version"
    }
    
    public init(languageType: IDOLanguageType, languageVersion: Int) {
        self.languageType = languageType
        self.languageVersion = languageVersion
    }
}


@objc
public enum IDOLanguageType: Int, Codable {
    case invalid = 0
    case chinese = 1
    case english = 2
    case french = 3
    case german = 4
    case italian = 5
    case spanish = 6
    case japanese = 7
    case polish = 8
    case czech = 9
    case romanian = 10
    case lithuanian = 11
    case dutch = 12
    case slovenian = 13
    case hungarian = 14
    case russian = 15
    case ukrainian = 16
    case slovak = 17
    case danish = 18
    case croatian = 19
    case indonesian = 20
    case korean = 21
    case hindi = 22
    case portuguese = 23
    case turkish = 24
    case thai = 25
    case vietnamese = 26
    case burmese = 27
    case filipino = 28
    case traditionalChinese = 29
    case greek = 30
    case arabic = 31
    case swedish = 32
    case finnish = 33
    case persian = 34
    case norwegian = 35
    case malay = 36
    case brazilianPortuguese = 37
    case bengali = 38
    case khmer = 39
    case serbian = 40
    case bulgaria = 41
    case hebrew = 42
}
