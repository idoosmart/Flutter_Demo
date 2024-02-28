//
//  GetAppInfoImpl.swift
//  app_info
//
//  Created by hedongyang on 2023/9/8.
//

import Foundation

class GetAppInfoImpl: ApiGetAppInfo {
    
    func appInfoList() -> [[String: Any]] {
        return  [
            [
                        "type": 1,
                        "pkgName": "com.apple.MobileSMS",
                        "appName": "SMS",
                        "iconFilePath": ""
                     ], [
                        "type": 2,
                        "pkgName": "com.apple.missed.mobilephone",
                        "appName": "Missed calls",
                        "iconFilePath": "",
                    ], [
                        "type": 3,
                        "pkgName": "com.apple.mobilephone",
                        "appName": "Phone",
                        "iconFilePath": "",
                    ], [
                        "type": 4,
                        "pkgName": "com.apple.mobilemail",
                        "appName": "Mail",
                        "iconFilePath": "",
                    ], [
                        "type": 5,
                        "pkgName": "com.apple.mobilecal",
                        "appName": "Calendar",
                        "iconFilePath": ""
                    ], [
                        "type": 6,
                        "pkgName": "com.tencent.xin",
                        "appName": (countryCode == "CN" ? "微信" : "WeChat"),
                        "iconFilePath": ""
                    ], [
                        "type": 7,
                        "pkgName": "com.tencent.mqq",
                        "appName": "QQ",
                        "iconFilePath": ""
                    ], [
                        "type": 8,
                        "pkgName": "com.facebook.Facebook",
                        "appName": "Facebook",
                        "iconFilePath": "",
                        "need_sync_icon": 0,
                    ], [
                        "type": 9,
                        "pkgName": "com.atebits.Tweetie2",
                        "appName": "X",
                        "iconFilePath": "",
                    ], [
                        "type": 10,
                        "pkgName": "net.whatsapp.WhatsApp",
                        "appName": "WhatsApp Messenger",
                        "iconFilePath": ""
                    ], [
                        "type": 11,
                        "pkgName": "com.facebook.Messenger",
                        "appName": "Messenger",
                        "iconFilePath": ""
                    ], [
                        "type": 12,
                        "pkgName": "com.burbn.instagram",
                        "appName": "Instagram",
                        
                        "iconFilePath": ""
                    ], [
                        "type": 13,
                        "pkgName": "com.linkedin.LinkedIn",
                        "appName": "LinkedIn",
                        "iconFilePath": ""
                    ], [
                        "type": 14,
                        "pkgName": "com.skype.skype",
                        "appName": "Skype",
                        "iconFilePath": "",
                    ], [
                        "type": 15,
                        "pkgName": "com.vk.vkclient",
                        "appName": "VK",
                        "iconFilePath": ""
                    ], [
                        "type": 16,
                        "pkgName": "com.toyopagroup.picaboo",
                        "appName": "Snapchat",
                        "iconFilePath": ""
                    ], [
                        "type": 17,
                        "pkgName": "jp.naver.line",
                        "appName": "LINE",
                        "iconFilePath": ""
                    ], [
                        "type": 18,
                        "pkgName": "com.viber",
                        "appName": "Rakuten",
                        "iconFilePath": ""
                    ], [
                        "type": 19,
                        "pkgName": "com.iwilab.KakaoTalk",
                        "appName": "KakaoTalk",
                        "iconFilePath": ""
                    ], [
                        "type": 20,
                        "pkgName": "ph.telegra.Telegraph",
                        "appName": "Telegram Messenger",
                        "iconFilePath": ""
                    ], [
                        "type": 21,
                        "pkgName": "com.tumblr.tumblr",
                        "appName": "Tumblr",
                        "iconFilePath": ""
                    ], [
                        "type": 22,
                        "pkgName": "com.google.ios.youtube",
                        "appName": "YouTube",
                        "iconFilePath": "",
                    ], [
                        "type": 23,
                        "pkgName": "pinterest",
                        "appName": "Pinterest",
                        "iconFilePath": ""
                    ], [
                        "type": 24,
                        "pkgName": "com.zhiliaoapp.musically",
                        "appName": "TikTok",
                        "iconFilePath": ""
                    ], [
                        "type": 25,
                        "pkgName": "net.whatsapp.WhatsAppSMB",
                        "appName": "WhatsApp Business",
                        "iconFilePath": ""
                    ], [
                        "type": 26,
                        "pkgName": "com.google.Gmail",
                        "appName": "Gmail",
                        "iconFilePath": ""
                    ], [
                        "type": 27,
                        "pkgName": "com.eternoinfotech.newshunt",
                        "appName": "Dailyhunt",
                        "iconFilePath": ""
                    ], [
                        "type": 28,
                        "pkgName": "com.microsoft.Office.Outlook",
                        "appName": "Microsoft Outlook",
                        
                        "iconFilePath": ""
                    ], [
                        "type": 29,
                        "pkgName": "in.startv.hotstarLite",
                        "appName": "Hotstar",
                        "iconFilePath": ""
                    ], [
                        "type": 30,
                        "pkgName": "com.nis.app",
                        "appName": "Inshorts",
                        "iconFilePath": ""
                    ], [
                        "type": 31,
                        "pkgName": "com.one97.paytm",
                        "appName": "Paytm",
                        "iconFilePath": ""
                    ], [
                        "type": 32,
                        "pkgName": "com.amazon.Amazon",
                        "appName": "Amazon",
                        "iconFilePath": ""
                    ], [
                        "type": 33,
                        "pkgName": "com.appflipkart.flipkart",
                        "appName": "Flipkart",
                        "iconFilePath": ""
                    ], [
                        "type": 34,
                        "pkgName": "com.amazon.aiv.AIVApp",
                        "appName": "Amazon Prime Video",
                        "iconFilePath": ""
                    ], [
                        "type": 35,
                        "pkgName": "com.netflix.Netflix",
                        "appName": "Netflix",
                        "iconFilePath": ""
                    ], [
                        "type": 36,
                        "pkgName": "com.phonepe.PhonePeApp",
                        "appName": "PhonePe",
                        "iconFilePath": ""
                    ], [
                        "type": 37,
                        "pkgName": "bundl.swiggy",
                        "appName": "Swiggy",
                        "iconFilePath": ""
                    ], [
                        "type": 38,
                        "pkgName": "com.zomato.zomato",
                        "appName": "Zomato",
                        "iconFilePath": ""
                    ], [
                        "type": 39,
                        "pkgName": "com.Iphone.MMT",
                        "appName": "MakeMyTrip",
                        "iconFilePath": ""
                    ], [
                        "type": 40,
                        "pkgName": "com.jio.jioplay",
                        "appName": "JioTV",
                        "iconFilePath": ""
                    ], [
                        "type": 41,
                        "pkgName": "com.google.paisa",
                        "appName": "Google Pay",
                        "iconFilePath": ""
                    ], [
                        "type": 42,
                        "pkgName": "com.google.ios.youtubemusic",
                        "appName": "YouTube Music",
                        "iconFilePath": ""
                    ], [
                        "type": 43,
                        "pkgName": "com.ubercab.UberClient",
                        "appName": "Uber",
                        "iconFilePath": ""
                    ], [
                        "type": 44,
                        "pkgName": "olacabs.OlaCabs",
                        "appName": "Ola Cabs",
                        "iconFilePath": ""
                    ], [
                        "type": 45,
                        "pkgName": "com.kieslect.ks",
                        "appName": "KS OS",
                        "iconFilePath": ""
                    ],
                        [
                           "type": 46,
                           "pkgName": "com.ido.life",
                           "appName": "Veryfit",
                           "iconFilePath": ""
                       ]
        ];
    }
    
    
    func getOneAppInfo(pkgName:String)->[String:Any] {
        let list = appInfoList()
        var dic = [String:Any]()
        list.forEach { e in
            let name = e["pkgName"] as! String;
            if name == pkgName {
               dic = e
            }
        }
        return dic
    }
    
    
    func copyAppIcon(completion: @escaping (Result<Bool, Error>) -> Void) {
        NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios copy app icon == \(isFinish)", completion: {})
        if !isFinish {
            DispatchQueue.global().async { [self] in
                let bundle = Bundle(for: type(of: self))
                if let bundleURL = bundle.url(forResource: "ido_assets", withExtension: "bundle"),
                    let nestedBundle = Bundle(url: bundleURL) {
                    let fileManager = FileManager.default
                    do{
                       let files = try fileManager.contentsOfDirectory(atPath: nestedBundle.bundlePath)
                       for file in files {
                            do {
                                let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                                let folderURL = documentsURL.appendingPathComponent("ido_sdk")
                                let iconURL = folderURL.appendingPathComponent("message_icon")
                                if !fileManager.fileExists(atPath: iconURL.path) {
                                    NativeChannelPlugin.shared.tools?.getNativeLog(msg: "creat message icon directory", completion: {})
                                    try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                                    try fileManager.createDirectory(at: iconURL, withIntermediateDirectories: true, attributes: nil)
                                }
                                let filePath1 = nestedBundle.bundlePath + "/" + file
                                let fileURL = URL(fileURLWithPath: filePath1)
                                if fileURL.pathExtension != "plist" {
                                    var fileName = fileURL.deletingPathExtension().lastPathComponent
                                    let pkgName = fileName.replacingOccurrences(of: "_100", with: "")
                                    fileName = fileName + ".png"
                                    let filePath2 = iconURL.appendingPathComponent(fileName).path
                                    if !fileManager.fileExists(atPath: filePath2) {
                                        try fileManager.copyItem(at: URL(fileURLWithPath:filePath1), to: URL(fileURLWithPath:filePath2))
                                    }
                                    var dic = getOneAppInfo(pkgName: pkgName)
                                    if !dic.isEmpty {
                                      dic["iconFilePath"] = filePath2
                                      appInfo.append(dic)
                                    }
                                }
                                
                            } catch {
                                completion(.failure(error))
                                NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios file copy failed：\(error)",completion: {})
                            }
                           
                       }
                        isFinish = true
                        completion(.success(true))
                        NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios copy icons success", completion: {})
                        NativeChannelPlugin.shared.tools?.getNativeLog(msg: "app info == \(appInfo)", completion: {})
                    } catch {
                        completion(.failure(error))
                        NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios contents of directory failed：\(error)", completion: {})
                    }
                } else {
                    let error = NSError(domain: "ios not found \"ido_assets\" bundle", code: 0, userInfo: nil)
                    NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios not found \"ido_assets\" bundle",completion: {})
                    completion(.failure(error))
                }
            }
        }else {
            completion(.success(true))
        }
        
    }
    
    
    func androidAppIconDirPath(completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    
    func readInstallAppInfoList(force: Bool, completion: @escaping (Result<[[AnyHashable : Any?]], Error>) -> Void) {
        
    }
    
    func readDefaultAppList(completion: @escaping (Result<[[AnyHashable : Any?]], Error>) -> Void) {
        if isFinish {
            NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios read default app list", completion: {})
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let iconFilePath = documentDirectoryPath + "/ido_sdk/message_icon/pinterest_100.png"
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: iconFilePath) {
                NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios file not exist == pinterest_100.png", completion: {})
                isFinish = false
            }else {
                NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios file is exist == pinterest_100.png", completion: {})
            }
        }
        if !isFinish {
            copyAppIcon { res in
                DispatchQueue.main.async { [self] in
                    switch res {
                    case .success( _):
                    completion(.success(appInfo))
                    break
                    case .failure(let error):
                    completion(.failure(error))
                    break
                    }
                }
            }
        }else {
            DispatchQueue.main.async { [self] in
                completion(.success(appInfo))
            }
        }
    }
    
    func readCurrentAppInfo(type: Int64, completion: @escaping (Result<[AnyHashable : Any?]?, Error>) -> Void) {
        
    }
    
    func convertEventType2PackageName(type: Int64, completion: @escaping (Result<String?, Error>) -> Void) {
        
    }
    
    func convertEventTypeByPackageName(name: String, completion: @escaping (Result<Int64, Error>) -> Void) {
        
    }
    
    func isDefaultApp(packageName: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    var isFinish: Bool = false
    
    var appInfo: [[String: Any]] = []
    
    var countryCode: String = "US"
    
    static let shared = GetAppInfoImpl()
    private init() {
        let currentLocale = Locale.current
        if let countryCode = currentLocale.regionCode {
            self.countryCode = countryCode
        }
    }
    
}
