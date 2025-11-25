import Foundation

enum NorEndMode:UInt8 {
    case noSend = 0
    case waitRsp = 1
    case sendCmd = 2
}
