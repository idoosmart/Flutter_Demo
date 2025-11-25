import Foundation

extension NSData{
    
    private static let HeadDisplayBytesCount = 20
    private static let TailDisplayBytesCount = 8
    
    public var customDescription: String {
        var content = ""
        if self.length <= NSData.HeadDisplayBytesCount + NSData.TailDisplayBytesCount {
            let d = Data.init(referencing: self)
            let des = groupedByteContent(data: d)
            content.append(des)
        }else{
            let headData = self.subdata(with: NSRange.init(location: 0, length: NSData.HeadDisplayBytesCount))

            let tailData = self.subdata(with: NSRange.init(location: self.count-NSData.TailDisplayBytesCount, length: NSData.TailDisplayBytesCount))

            let headBytesDes = groupedByteContent(data: headData)
            let tailBytesDes = groupedByteContent(data: tailData)
            content.append(headBytesDes)
            content.append(" ... ")
            content.append(tailBytesDes)
        }
        return "{length = \(self.count), bytes = <\(content)>}"
    }
    
    private func groupedByteContent(data:Data) -> String {
        let d = NSData.init(data: data)
        var content = ""
        for i in 0..<d.length{
            var v:UInt8 = 0
            d.getBytes(&v, range: NSRange.init(location: i, length: 1))
            if i>0 && i%4 == 0{
                content.append(" ")
            }
            content.append(String.init(format: "%.2x", v))
        }
        return content
    }
}
