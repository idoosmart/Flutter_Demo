import Foundation
//import Zip
import ZIPFoundation


enum ZipLoadError: Error {
    case LoadOrderFileFailed
    case DecodeUTF8Failed
    case LoadResourceFileFailed
    case EncodeFileNameFailed
}

class ResourceZipLoader{
    
    private static let orderFileName = "ota_file_list_order.txt"
    
    static func loadSorted(path:URL) throws -> [NandResFile]  {
        var unzipDirectory:URL
        let isZipFile = isZipFile(rootPath: path)
        if isZipFile {
            
            // !!!: 思澈原始代码（存在打包完，解压带韩语文件的内嵌zip包会失败）
//            unzipDirectory = try Zip.quickUnzipFile(path)
//           OLog("ℹ️UnzipedDirecotry: \(unzipDirectory)")
            
            // ------- begin 替换第三方zip库 ------
            do {
                // 使用 ZIPFoundation
                let fileManager = FileManager.default
                let fileExtension = path.pathExtension
                let fileName = path.lastPathComponent
                let directoryName = fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
                let documentsUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                unzipDirectory = documentsUrl.appendingPathComponent(directoryName, isDirectory: true)
                if fileManager.fileExists(atPath: unzipDirectory.path) {
                    try fileManager.removeItem(at: unzipDirectory)
                }
                try FileManager.default.unzipItem(at: path, to: unzipDirectory)
                OLog("ℹ️UnzipedDirecotry: \(unzipDirectory)")
            }catch {
                OLog("❌UnzipedDirecotry: \(error.localizedDescription)")
                throw ZipLoadError.LoadOrderFileFailed
            }
            // ------- end 替换第三方zip库 ------
            
        }else{
            let isDirectory = isDirectory(rootPath: path)
            if isDirectory {
                unzipDirectory = path
            }else{
                OLog("❌resource path is not a zip file nor a directory at path\(path.path)")
                throw ZipLoadError.LoadOrderFileFailed
            }
        }
        
        
        // 索引文件文件名和位置为固定的
        let orderFilePath = unzipDirectory.appendingPathComponent(orderFileName, isDirectory: false)
        do {
            let fileManager = FileManager.default;
            let exist = fileManager.fileExists(atPath: orderFilePath.path)
            if !exist {
                OLog("orderFile:\(orderFilePath) is not exist")
                let hasAnyBinFile = hasAnyBinFileAtPath(rootPath: unzipDirectory)
                if hasAnyBinFile {
                    OLog("❌orderFile missing,but exist bin file at path\(unzipDirectory.path)")
                    throw ZipLoadError.LoadOrderFileFailed
                }else{
                    OLog("warning:orderFile missing,and no bin file there,will continue.")
                    return Array<NandResFile>.init();
                }

            }
            let orderFileDataBinary = try Data.init(contentsOf: orderFilePath)
            if(orderFileDataBinary.count <= 4){
                OLog("❌orderFile length error.len=\(orderFileDataBinary.count)")
                throw ZipLoadError.LoadOrderFileFailed
            }
            let orderFileData = orderFileDataBinary.subdata(in: 0..<orderFileDataBinary.count - 4)
            
            let lineBreak = "\n".data(using: .utf8)!
            let lineBreakValue = lineBreak[0]

            let lineDatas = orderFileData.split { byte in
                return byte == lineBreakValue
            }
            var fileArray = Array<NandResFile>.init()
            
            
            /// order file需要第一个发送
            var completedFileName = orderFileName
            if !completedFileName.hasPrefix("/") {
                completedFileName = "/" + completedFileName
            }
            let completedFileNameData = completedFileName.data(using: .utf8)!
            let orderFile = NandResFile.init(nameWithPath: completedFileName, nameDataWithPath: completedFileNameData,data: orderFileDataBinary)
            fileArray.append(orderFile)
            
            for index in 0..<lineDatas.count {
                var lineData = lineDatas[index]
//                if index == lineDatas.count - 1 {
//                    // 最后一行为校验行
//                    OLog("ℹ️ResourceZip校验值: \(NSData.init(data: lineData))")
//                    continue
//                }
                if let last = lineData.last, last == 0x0d {
                    // 去掉0x0d的换行符
                    lineData.removeLast()
                }
                guard let content = String.init(data: lineData, encoding: .utf8) else {
                    OLog("❌未能utf8解码的OrderList行: \(NSData.init(data: lineData))")
                    throw ZipLoadError.DecodeUTF8Failed
                }
               
                
                if !content.contains("/") {
                    OLog("⚠️忽略不含斜杠Resource文件:'\(index+1)'行内容:'\(content)'")
                    OLog("---")
                    continue
                }
                OLog("ℹ️OrderFile第'\(index+1)'行内容:'\(content)'")
                if content.hasSuffix("_") {
                    // 需要忽略的文件
                    OLog("⚠️忽略Resource文件:\(content)")
                    continue
                }
                let filePath = unzipDirectory.appendingPathComponent(content)

                guard let fileData = try? Data.init(contentsOf: filePath) else {
                    OLog("❌加载Resource文件失败:path='\(filePath)'")
                    throw ZipLoadError.LoadResourceFileFailed
                }
                
                /// 将content再进行UTF8编码
                guard let nameDataWithPath = content.data(using: .utf8) else {
                    OLog("❌对FileName进行UTF8编码失败: fileName='\(content)'")
                    throw ZipLoadError.EncodeFileNameFailed
                }
                
                let file = NandResFile.init(nameWithPath: content,nameDataWithPath: nameDataWithPath, data: fileData)
                fileArray.append(file)

                
            }
            
            return fileArray

        } catch {
            OLog("❌加载order文件内容失败, orderFilePath = \(orderFilePath.absoluteString)")
            throw ZipLoadError.LoadOrderFileFailed
        }
    }
    
    
    
    static func RelativeFilePaths(rootPath:URL) -> [String]?{
        
        let fileManager = FileManager.default
        var filePathArray = Array<String>.init()
        let contents = fileManager.enumerator(atPath: rootPath.path)!
        while let content = contents.nextObject(){
            guard let s =  content as? String else{
                QPrint("unzip failed: could not convert '\(content)' to String")
                return nil
            }
            var isDir = ObjCBool.init(false)
            fileManager.fileExists(atPath: rootPath.appendingPathComponent(s).path, isDirectory: &isDir)
            if isDir.boolValue == false{
                filePathArray.append(s)
            }
        }
        return filePathArray
    }
    
    
    /// 检查一个路径之下是否存在.bin文件
    /// - Parameter rootPath: 根目录
    /// - Returns: true/false
    static func hasAnyBinFileAtPath(rootPath:URL) -> Bool{
        
        let fileManager = FileManager.default
        
        let contents = fileManager.enumerator(atPath: rootPath.path)!
        while let content = contents.nextObject(){
            guard let s =  content as? String else{
                QPrint("unzip failed: could not convert '\(content)' to String")
                return false
            }
            var isDir = ObjCBool.init(false)
            fileManager.fileExists(atPath: rootPath.appendingPathComponent(s).path, isDirectory: &isDir)
            if isDir.boolValue == false{
                if s.hasSuffix(".bin") {
                    return true
                }
            }
        }
        return false
    }
    
    static func isZipFile(rootPath:URL) -> Bool{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath:rootPath.path) {
            if(rootPath.pathExtension.lowercased() == "zip"){
                return true
            }
        }
        return false
    }
    
    static func isDirectory(rootPath:URL) -> Bool{
        let fileManager = FileManager.default
        var isDir = ObjCBool.init(false)
        let dirExist = fileManager.fileExists(atPath: rootPath.path, isDirectory: &isDir)
        
        return dirExist && isDir.boolValue
    }
    
    
}
