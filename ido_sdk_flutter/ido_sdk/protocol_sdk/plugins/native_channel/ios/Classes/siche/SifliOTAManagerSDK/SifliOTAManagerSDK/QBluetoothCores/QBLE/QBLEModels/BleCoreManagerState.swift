import UIKit

@objc public enum BleCoreManagerState: Int {
    case unknown = 0

    case resetting = 1

    case unsupported = 2

    case unauthorized = 3

    case poweredOff = 4

    case poweredOn = 5
}
