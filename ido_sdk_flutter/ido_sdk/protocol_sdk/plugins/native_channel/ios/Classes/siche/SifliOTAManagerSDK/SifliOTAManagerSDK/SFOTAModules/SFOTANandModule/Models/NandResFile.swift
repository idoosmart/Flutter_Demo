import UIKit

class NandResFile: NSObject {
    public static let sliceLengthMtuMoreThan190 = 10240
    public static let sliceLengthMtuLessThan190 = 1024
    public static var sliceLength = 10240
    
    
    let nameWithPath:String
    /// 冗余设计
    let nameDataWithPath:Data
    
    let data:Data
    var dataSliceArray:Array<Data>
    
    init(nameWithPath: String, nameDataWithPath:Data, data: Data) {
        self.nameWithPath = nameWithPath
        self.nameDataWithPath = nameDataWithPath
        self.data = data
        //        let ary = QDataTools.SplitData(data: data, upperlimit: NandResFile.sliceLength)
        self.dataSliceArray = Array.init()
        super.init()
    }
    
    public func makeSlice(){
        self.dataSliceArray.removeAll()
        let ary = QDataTools.SplitData(data: data, upperlimit: NandResFile.sliceLength)
        self.dataSliceArray.append(contentsOf: ary)
    }
}
