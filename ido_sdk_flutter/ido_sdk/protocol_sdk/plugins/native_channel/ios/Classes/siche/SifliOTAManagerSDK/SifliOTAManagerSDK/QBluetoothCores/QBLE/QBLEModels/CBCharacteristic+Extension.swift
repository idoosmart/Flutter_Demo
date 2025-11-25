import Foundation
import CoreBluetooth

extension CBCharacteristic {
    func briefDes() -> String {
        let p = String.init(format: "0x%.2x", self.properties.rawValue)
        return "<UUID=\(self.uuid.uuidString),properties=\(p),isNotifying=\(self.isNotifying)>"
    }
}
