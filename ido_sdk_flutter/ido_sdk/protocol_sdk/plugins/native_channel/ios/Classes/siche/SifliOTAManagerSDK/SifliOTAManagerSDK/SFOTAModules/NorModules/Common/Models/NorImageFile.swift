@objc public enum NorImageID: UInt8 {
    case HCPU = 0
    case LCPU = 1
    case PATCH = 2
    case RES = 3
    case FONT_OR_MAX = 4
    case EX = 5
    case OTA_MANAGER = 6
    case TINY_FONT = 7
    case BOOT_LOADER = 11
    
    case NONE = 0xff
}

import UIKit

class NorImageFile: NSObject {

    static let SliceLength = 548
    
    let imageID:NorImageID
    
    let data:Data
    
    let dataSliceArray:Array<Data>

    
    init(imageID: NorImageID, data: Data) {
        self.imageID = imageID
        self.data = data
        self.dataSliceArray = QDataTools.SplitData(data: data, upperlimit: NorImageFile.SliceLength)
        super.init()
    }
}
