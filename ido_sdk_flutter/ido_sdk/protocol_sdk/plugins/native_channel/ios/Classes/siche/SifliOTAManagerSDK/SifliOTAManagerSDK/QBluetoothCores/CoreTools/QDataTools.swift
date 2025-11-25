

import Foundation

public class QDataTools {
//    public static func SplitData(data:Data,upperlimit:Int) -> Array<Data> {
//        if upperlimit <= 0{
//            return [data]
//        }else{
//            var dataArray = Array<Data>.init()
//            var restData = data
//            while restData.count > upperlimit {
//                let sliceData = NSData.init(data: restData).subdata(with: NSMakeRange(0, upperlimit))
//                dataArray.append(sliceData)
//                restData = NSData.init(data: restData).subdata(with: NSMakeRange(sliceData.count, restData.count - sliceData.count))
//            }
//
//            dataArray.append(restData)
//
//            return dataArray
//        }
//    }
    
    public static func SplitData(data:Data,upperlimit:Int) -> Array<Data>{
        if upperlimit <= 0{
            return [data]
        }else{
            let tempData = NSData.init(data: data)
            var dataArray = Array<Data>.init()
            let count = tempData.count/upperlimit + (tempData.count%upperlimit == 0 ? 0:1 )
            for i in 0..<count {
                let location = i*upperlimit
                let length = i == count - 1 ? data.count - location:upperlimit
                let slice = tempData.subdata(with: NSRange.init(location: location, length: length))//data.subdata(in: range)
                dataArray.append(slice)
            }
            
            return dataArray
        }
    }
    
    public static func Reverse(srcData:Data) -> Data {
        var data = Data.init()
        for i in (0..<srcData.count).reversed() {
            data.append(srcData[i])
        }
        return data
    }
}
