//
//  GetAppInfoImpl.swift
//  app_info
//
//  Created by hedongyang on 2023/9/8.
//

import Foundation

class GetAppInfoImpl: ApiGetAppInfo {

    // 确保资源只复制一次，若只是更换资源里图片（包名、列表不变），需要改动该值
    private let pkgNameFlagKey = "B27B33C3D2271EAA-01"
    private var pkgNameTotalSize = 0

    //Google Pay 应用已经在app store下架
    //Hotstar 在英国发布应用，暂时无法获取到scheme url
    private lazy var _defaultPkgList = [
        [
            "type": 1,
            "pkgName": "com.apple.MobileSMS",
            "appName": "SMS",
            "iconFilePath": "",
            "scheme":"sms://"
        ], [
            "type": 2,
            "pkgName": "com.apple.missed.mobilephone",
            "appName": "Missed calls",
            "iconFilePath": "",
            "scheme":"missed://"
        ], [
            "type": 3,
            "pkgName": "com.apple.mobilephone",
            "appName": "Phone",
            "iconFilePath": "",
            "scheme":"tel://"
        ], [
            "type": 4,
            "pkgName": "com.apple.mobilemail",
            "appName": "Mail",
            "iconFilePath": "",
            "scheme":"mailto://"
        ], [
            "type": 5,
            "pkgName": "com.apple.mobilecal",
            "appName": "Calendar",
            "iconFilePath": "",
            "scheme":"calendar://"
        ], [
            "type": 6,
            "pkgName": "com.tencent.xin",
            "appName": (countryCode == "CN" ? "微信" : "WeChat"),
            "iconFilePath": "",
            "scheme":"weixin://"
        ], [
            "type": 7,
            "pkgName": "com.tencent.mqq",
            "appName": "QQ",
            "iconFilePath": "",
            "scheme":"mqq://"
        ], [
            "type": 8,
            "pkgName": "com.facebook.Facebook",
            "appName": "Facebook",
            "iconFilePath": "",
            "scheme":"fb://"
        ], [
            "type": 9,
            "pkgName": "com.atebits.Tweetie2",
            "appName": "X",
            "iconFilePath": "",
            "scheme":"twitter://"
        ], [
            "type": 10,
            "pkgName": "net.whatsapp.WhatsApp",
            "appName": "WhatsApp Messenger",
            "iconFilePath": "",
            "scheme":"whatsapp://"
        ], [
            "type": 11,
            "pkgName": "com.facebook.Messenger",
            "appName": "Messenger",
            "iconFilePath": "",
            "scheme":"fb-messenger://"
        ], [
            "type": 12,
            "pkgName": "com.burbn.instagram",
            "appName": "Instagram",
            "iconFilePath": "",
            "scheme":"instagram://"
        ], [
            "type": 13,
            "pkgName": "com.linkedin.LinkedIn",
            "appName": "LinkedIn",
            "iconFilePath": "",
            "scheme":"linkedin://"
        ], [
            "type": 14,
            "pkgName": "com.skype.skype",
            "appName": "Skype",
            "iconFilePath": "",
            "scheme":"skype://"
        ], [
            "type": 15,
            "pkgName": "com.vk.vkclient",
            "appName": "VK",
            "iconFilePath": "",
            "scheme":"vk://"
        ], [
            "type": 16,
            "pkgName": "com.toyopagroup.picaboo",
            "appName": "Snapchat",
            "iconFilePath": "",
            "scheme":"snapchat://"
        ], [
            "type": 17,
            "pkgName": "jp.naver.line",
            "appName": "LINE",
            "iconFilePath": "",
            "scheme":"line://"
        ], [
            "type": 18,
            "pkgName": "com.viber",
            "appName": "Rakuten",
            "iconFilePath": "",
            "scheme":"rakuten://"
        ], [
            "type": 19,
            "pkgName": "com.iwilab.KakaoTalk",
            "appName": "KakaoTalk",
            "iconFilePath": "",
            "scheme":"kakaolink://"
        ], [
            "type": 20,
            "pkgName": "ph.telegra.Telegraph",
            "appName": "Telegram Messenger",
            "iconFilePath": "",
            "scheme":"telegram://"
        ], [
            "type": 21,
            "pkgName": "com.tumblr.tumblr",
            "appName": "Tumblr",
            "iconFilePath": "",
            "scheme":"tumblr://"
        ], [
            "type": 22,
            "pkgName": "com.google.ios.youtube",
            "appName": "YouTube",
            "iconFilePath": "",
            "scheme":"youtube://"
        ], [
            "type": 23,
            "pkgName": "pinterest",
            "appName": "Pinterest",
            "iconFilePath": "",
            "scheme":"pinterest://"
        ], [
            "type": 24,
            "pkgName": "com.zhiliaoapp.musically",
            "appName": "TikTok",
            "iconFilePath": "",
            "scheme":"tiktok://"
        ], [
            "type": 25,
            "pkgName": "net.whatsapp.WhatsAppSMB",
            "appName": "WhatsApp Business",
            "iconFilePath": "",
            "scheme":"whatsapp-smb://"
        ], [
            "type": 26,
            "pkgName": "com.google.Gmail",
            "appName": "Gmail",
            "iconFilePath": "",
            "scheme":"googlegmail://"
        ], [
            "type": 27,
            "pkgName": "com.microsoft.Office.Outlook",
            "appName": "Microsoft Outlook",
            "iconFilePath": "",
            "scheme":"ms-outlook://"
        ],  [
            "type": 28,
            "pkgName": "com.nis.app",
            "appName": "Inshorts",
            "iconFilePath": "",
            "scheme":"nis://"
        ], [
            "type": 29,
            "pkgName": "com.one97.paytm",
            "appName": "Paytm",
            "iconFilePath": "",
            "scheme":"paytm://"
        ], [
            "type": 30,
            "pkgName": "com.amazon.Amazon",
            "appName": "Amazon Shopping",
            "iconFilePath": "",
            "scheme":"amazonpay://"
        ], [
            "type": 31,
            "pkgName": "com.appflipkart.flipkart",
            "appName": "Flipkart",
            "iconFilePath": "",
            "scheme":"flipkart://"
        ], [
            "type": 32,
            "pkgName": "com.amazon.aiv.AIVApp",
            "appName": "Amazon Prime Video",
            "iconFilePath": "",
            "scheme":"aiv://"
        ], [
            "type": 33,
            "pkgName": "com.netflix.Netflix",
            "appName": "Netflix",
            "iconFilePath": "",
            "scheme":"nflx://"
        ], [
            "type": 34,
            "pkgName": "com.phonepe.PhonePeApp",
            "appName": "PhonePe",
            "iconFilePath": "",
            "scheme":"phonepe://"
        ], [
            "type": 35,
            "pkgName": "bundl.swiggy",
            "appName": "Swiggy",
            "iconFilePath": "",
            "scheme":"swiggy://"
        ], [
            "type": 36,
            "pkgName": "com.zomato.zomato",
            "appName": "Zomato",
            "iconFilePath": "",
            "scheme":"zomato://"
        ], [
            "type": 37,
            "pkgName": "com.Iphone.MMT",
            "appName": "MakeMyTrip",
            "iconFilePath": "",
            "scheme":"mmyt://"
        ], [
            "type": 38,
            "pkgName": "com.jio.jioplay",
            "appName": "JioTV",
            "iconFilePath": "",
            "scheme":"jioplay://"
        ], [
            "type": 39,
            "pkgName": "com.google.ios.youtubemusic",
            "appName": "YouTube Music",
            "iconFilePath": "",
            "scheme":"youtubemusic://"
        ], [
            "type": 40,
            "pkgName": "com.ubercab.UberClient",
            "appName": "Uber",
            "iconFilePath": "",
            "scheme":"uber://"
        ], [
            "type": 41,
            "pkgName": "olacabs.OlaCabs",
            "appName": "Ola Cabs",
            "iconFilePath": "",
            "scheme":"olacabs://"
        ],
        [
            "type": 42,
            "pkgName": "com.eternoinfotech.newshunt",
            "appName": "Dailyhunt",
            "iconFilePath": "",
            "scheme":"fb131285656905938://"
        ],
        [
            "type": 43,
            "pkgName": "in.startv.hotstarLite",
            "appName": "Hotstar",
            "iconFilePath": "",
            "scheme":""
        ],
        [
            "type": 44,
            "pkgName": "com.google.paisa",
            "appName": "Google Pay",
            "iconFilePath": "",
            "scheme":""
        ],
        [
            "type": 45,
            "pkgName": "com.kieslect.ks",
            "appName": "KS OS",
            "iconFilePath": "",
            "scheme":""
        ],
        [
            "type": 46,
            "pkgName": "com.ido.life",
            "appName": "Veryfit",
            "iconFilePath": "",
            "scheme":""
        ],
        [
            "type": 47,
            "pkgName": "com.aiwatch.aiwa",
            "appName": "Aiwa Connect Plus",
            "iconFilePath": "",
            "scheme":""
        ],
        [
            "type": 48,
            "pkgName": "com.icewatch.icefit",
            "appName": "ICE fit",
            "iconFilePath": "",
            "scheme":""
        ]
    ]
    
    func appInfoList() -> [[String: Any]] {
        let list = _defaultPkgList
        if (pkgNameTotalSize == 0) {
            list.forEach { pkgNameTotalSize += ($0["pkgName"] as! String).count }
        }
        return list
    }

    
    func getOneAppInfo(pkgName:String)->[String:Any] {
        let list = appInfoList()
        var dic: [String:Any]?
        for e in list {
            if let name = e["pkgName"] as? String, name == pkgName {
                dic = e
                break
            }
        }
        return dic ?? [:]
    }
    
    
    func copyAppIcon(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard !isBusy else {
            NativeChannelPlugin.shared.tools?.getNativeLog(msg: "copyAppIcon method is working... return", completion: {})
            return
        }
        NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios copy app icon == \(isFinish)", completion: {})
        if !isFinish {
            isBusy = true
            DispatchQueue.global().async { [self] in
                let bundle = Bundle(for: type(of: self))
                if let bundleURL = bundle.url(forResource: "icon_assets", withExtension: "bundle"),
                    let nestedBundle = Bundle(url: bundleURL) {
                    let fileManager = FileManager.default
                    do{
                       let files = try fileManager.contentsOfDirectory(atPath: nestedBundle.bundlePath)
                        var hasErr = false
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
                                DispatchQueue.main.async {
                                    completion(.failure(error))
                                }
                                NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios file copy failed：\(error)",completion: {})
                                hasErr = true
                                break
                            }
                           
                       }
                        if (hasErr) {
                            isBusy = false
                            return
                        }
                        isFinish = true
                        isBusy = false
                        DispatchQueue.main.async {
                            completion(.success(true))
                        }
                        NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios copy icons success", completion: {})
                        NativeChannelPlugin.shared.tools?.getNativeLog(msg: "app info == \(appInfo)", completion: {})
                    } catch {
                        isBusy = false
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios contents of directory failed：\(error)", completion: {})
                    }
                } else {
                    isFinish = true
                    isBusy = false
                    let error = NSError(domain: "ios not found \"icon_assets\" bundle", code: 0, userInfo: nil)
                    NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios not found \"icon_assets\" bundle",completion: {})
                    DispatchQueue.main.async {
                        //completion(.failure(error))
                        completion(.success(true))
                    }
                }
            }
        }else {
            isBusy = false
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }
        
    }
    
    // TODO: 需要验证，暂未启用
    func copyAppIcon2(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard _needCopyBundleResource() else {
            isBusy = false
            completion(.success(true))
            return
        }
        
        if isBusy {
            _log("copyAppIcon method is working... return")
            return
        }
        
        isBusy = true
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            isBusy = false
            _log("copyAppIcon document dir 获取失败")
            let error = NSError(domain: "document dir 获取失败", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let destinationDirectory = documentDirectory.appendingPathComponent("ido_sdk/message_icon")
        // 如果目录不存在，则创建
        if !FileManager.default.fileExists(atPath: destinationDirectory.path),
            (try? FileManager.default.createDirectory(at: destinationDirectory, withIntermediateDirectories: true)) == nil {
            isBusy = false
            _log("ido_sdk/message_icon 创建失败")
            let error = NSError(domain: "copyAppIcon ido_sdk/message_icon 创建失败", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        // 获取 Bundle 中的图片目录 URL
        guard let bundleURL = Bundle.main.url(forResource: "icon_assets", withExtension: "bundle") else {
            isBusy = false
            _log("找不到 icon_assets.bundle")
            let error = NSError(domain: "找不到 icon_assets.bundle", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        // 获取 Bundle 中的所有 .jpg 图片文件
        guard let allJpeg = FileManager.default.enumerator(at: bundleURL, includingPropertiesForKeys: nil) else {
            isBusy = false
            _log("无法枚举 icon_assets.bundle 中的文件")
            let error = NSError(domain: "无法枚举 icon_assets.bundle 中的文件", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        // 异步线程中复制文件
        DispatchQueue.global().async { [weak self] in
            var allSuccess = true
            for case let fileURL as URL in allJpeg {
                let ext = fileURL.pathExtension.lowercased()
                if ext == "jpg" || ext == "png" {
                    let fileName = fileURL.deletingPathExtension().lastPathComponent
                    let destinationURL = destinationDirectory.appendingPathComponent("\(fileName).png")
                    do {
                        try FileManager.default.copyItem(at: fileURL, to: destinationURL)
                        self?._log("copy \(fileURL.lastPathComponent) -> \(fileName).png, successful")
                        if var dic = self?.getOneAppInfo(pkgName: (fileName.replacingOccurrences(of: "_100", with: ""))), !dic.isEmpty {
                            dic["iconFilePath"] = destinationURL.absoluteString
                            self?.appInfo.append(dic)
                        }
                    } catch {
                        self?._log("copy \(fileURL.lastPathComponent) -> \(fileName).png, error：\(error)")
                        allSuccess = false
                    }
                }
            }
            if (allSuccess) {
                self?._savePkgNameTotalSize()
            }
            self?._safeOnMainThread {
                self?.isFinish = true
                self?.isBusy = false
                completion(.success(true))
            }
        }
    }
    
    
    func androidAppIconDirPath(completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    
    func readInstallAppInfoList(force: Bool, completion: @escaping (Result<[[AnyHashable : Any?]], Error>) -> Void) {
        
    }
    
    func readDefaultAppList(completion: @escaping (Result<[[AnyHashable : Any?]], Error>) -> Void) {
        
        // 不存在资源
        guard let bundleURL = Bundle.main.url(forResource: "icon_assets", withExtension: "bundle"),
        let nestedBundle = Bundle(url: bundleURL) else {
            isBusy = false
            isFinish = true
            _log("readDefaultAppList not found icon_assets.bundle, return default pkg list")
            completion(.success(_defaultPkgList))
            return
        }
        
        if isFinish {
            NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios read default app list", completion: {})
            if let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                let iconFilePath = documentDirectoryPath + "/ido_sdk/message_icon/pinterest_100.png"
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: iconFilePath) {
                    NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios file not exist == pinterest_100.png", completion: {})
                    isFinish = false
                }else {
                    NativeChannelPlugin.shared.tools?.getNativeLog(msg: "ios file is exist == pinterest_100.png", completion: {})
                }
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
    private var isBusy: Bool = false
    
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

// TODO: 需要验证，暂未启用
private extension GetAppInfoImpl {
    
    func _safeOnMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    func _log(_ msg: String) {
        _safeOnMainThread {
            NativeChannelPlugin.shared.tools?.getNativeLog(msg: "msg_icon: \(msg)", completion: {})
        }
    }
    
    func _savePkgNameTotalSize() {
        UserDefaults.standard.setValue(pkgNameTotalSize, forKey: pkgNameFlagKey)
        UserDefaults.standard.synchronize()
    }
    
    func _needCopyBundleResource() -> Bool {
        if (pkgNameTotalSize == 0) {
            appInfoList().forEach { pkgNameTotalSize += ($0["pkgName"] as! String).count }
        }
        return pkgNameTotalSize != UserDefaults.standard.integer(forKey: pkgNameFlagKey)
    }
    
}
