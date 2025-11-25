import UIKit

enum BleEvent {
    case searchingTimeout
    case failedToConnect
    case shakedHands
    case disconnected
    case updateState
}

class SFOTAModuleBase: NSObject {
    
    let name:String
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    /// 蓝牙相关的事件处理。在Manager中获取的蓝牙事件，通过该函数告知Module，由Module进行处理。
    /// 必须在子类进行重写
    /// - Parameters:
    ///   - bleCore: 蓝牙核心
    ///   - event: 蓝牙事件
    ///   - object: 事件携带的外信息。event为updateState时，携带CBManagerState类型的对象；
    func bleEventHandler(bleCore:QBleCore, event:BleEvent, object:Any?){
        fatalError("OTAModuleBase.bleEventHandler Not Implement")
    }
    
    
    
    /// 处理蓝牙接收的数据
    /// - Parameters:
    ///   - bleCore: 蓝牙核心
    ///   - data: 蓝牙收到的数据
    func bleDataHandler(bleCore:QBleCore, data:Data) {
        fatalError("OTAModuleBase.bleDataHandler Not Implement !")
    }
    
    
    
    ///  OTA结束（失败或成功），在这里进行清除Module内所有缓存和状态的操作
    func clear() {
        fatalError("OTAModuleBase.clearWorks Not Implement !")
    }

}
