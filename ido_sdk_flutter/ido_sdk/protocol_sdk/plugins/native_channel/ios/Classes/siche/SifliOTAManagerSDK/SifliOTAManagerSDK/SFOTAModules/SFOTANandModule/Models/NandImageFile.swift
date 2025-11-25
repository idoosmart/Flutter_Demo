@objc public enum NandImageID: UInt16 {
    case HCPU = 0
    case LCPU = 1
    case PATCH = 2
    case RES = 3
    case LCPU_PATCH = 4
    case DYN = 5
    case MUSIC = 6
    case PIC = 7
    case FONT = 8
    case RING = 9
    case LANG = 10
}


import UIKit

class NandImageFile: NSObject {
    
    static let SliceLength = 2084
    
    let imageID:NandImageID
    
    let data:Data
    
    let dataSliceArray:Array<Data>

    
    init(imageID: NandImageID, data: Data) {
        self.imageID = imageID
        self.data = data
        self.dataSliceArray = QDataTools.SplitData(data: data, upperlimit: NandImageFile.SliceLength)
        super.init()
    }
}
