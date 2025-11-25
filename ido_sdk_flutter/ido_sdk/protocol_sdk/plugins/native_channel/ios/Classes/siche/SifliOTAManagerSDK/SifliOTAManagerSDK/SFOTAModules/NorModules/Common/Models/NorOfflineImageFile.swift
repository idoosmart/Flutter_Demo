//
//  NorOfflineImageFile.swift
//  SifliOTAManagerSDK
//
//  Created by Sean on 2024/12/25.
//

import UIKit

class NorOfflineImageFile: NSObject {
    static let SliceLength = 2048
    let crc32:UInt32
    let data:Data
    let dataSliceArray:Array<Data>
    init(crc32: UInt32, data: Data) {
        self.crc32 = crc32
        self.data = data
        self.dataSliceArray = QDataTools.SplitData(data: data, upperlimit: NorOfflineImageFile.SliceLength)
        super.init()
    }
}
