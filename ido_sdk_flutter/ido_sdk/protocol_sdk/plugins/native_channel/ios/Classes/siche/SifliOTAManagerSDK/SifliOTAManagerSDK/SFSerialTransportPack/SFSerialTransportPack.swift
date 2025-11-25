import Foundation

class SFSerialTransportPack: NSObject{
    private static let CateID:UInt8 = 0x01
    static func Packs(mtu:Int, msgData:Data) -> [SFSerialTransportPack]{
        
        var dataArray = Array<Data>.init()//QDataTools.SplitData(data: msgData, upperlimit: maxDataLength)
        
        let firstDataMaxLength = mtu - 3 - 4
        let restDataMaxLength = mtu - 3 - 2
        var firstData:Data = Data.init()
        var restData = Data.init()
        if msgData.count < firstDataMaxLength {
            firstData = msgData
        }else{
            firstData = msgData[0..<firstDataMaxLength]
            restData = msgData[firstDataMaxLength..<msgData.count]
        }
        
        dataArray.append(firstData)
        
        if restData.count > 0 {
            let restDataArray = QDataTools.SplitData(data: restData, upperlimit: restDataMaxLength)
            dataArray.append(contentsOf: restDataArray)
        }
        
        var packs = Array<SFSerialTransportPack>.init()
        if dataArray.count == 1 || dataArray.count == 0 {
            let p = SFSerialTransportPack.init(cateID: CateID, flag: 0x00)
            if dataArray.count > 0 {
                p.payloadData = dataArray[0]
            }
            packs.append(p)
        }else{
            for i in 0..<dataArray.count {
                var flag:UInt8 = 0
                if i == 0 {
                    flag = 0x01
                }else if i == dataArray.count - 1 {
                    flag = 0x03
                } else {
                    flag = 0x02
                }
                
                let p = SFSerialTransportPack.init(cateID: CateID, flag: flag)
                p.payloadData = dataArray[i]
                packs.append(p)
            }
        }
        // packs的长度至少为1，第一个包中，始终会携带同组包中的data长度之和，即msgData的长度
        packs[0].serialDataLength = UInt16(msgData.count)
        
        return packs
        
    }
    
    
    var cateID:UInt8
    var flag:UInt8
    /// 同一组的包中，所有包的data部分的总长度（同一组的包中，只有第一个包才携带此字段）
    var serialDataLength:UInt16?
    var payloadData:Data
    init(cateID:UInt8,flag:UInt8,serialDataLength:UInt16? = nil,payloadData:Data = Data.init()) {
        self.cateID = cateID
        self.flag = flag
        self.serialDataLength = serialDataLength
        self.payloadData = payloadData
        super.init()
    }
    
    public func marshal()->Data{
        
        let packData = NSMutableData.init()
        packData.append(&(self.cateID), length: 1)
        packData.append(&(self.flag), length: 1)
        if let length = serialDataLength {
            var l = length
            packData.append(&l, length: 2)
        }
        packData.append(self.payloadData)
        return Data.init(referencing: packData)
    }
    
    public override var description: String{
        return String.init(format: "cateID=0x%.2x,flag=0x%.2x,payloadData=%@", cateID,flag,NSData.init(data: payloadData).debugDescription)
    }
}
