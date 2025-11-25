import Foundation
///1.2.22 增加nand image id7,8,9,10
///1.2.24 低于13.0系统不检查ctrl file.
///1.2.25 ota norv1 最后一包必须回复。处理failToConnect事件。
///1.2.26 ota norv1 无回复发送增加5毫秒间隔，发送数据超时降低到40秒,可触发超时重传
///1.2.27 ota norv1 延迟发送提交到主线程串行队列
///1.2.28 ota norv1 norv2 修复续传问题
///1.2.29 ota nand 优化
///1.2.30 ota nor offline
///1.2.31 ota nand
///1.2.32 ota nand order najumber 改为UInt16,增加文件超过范围检查
let Const_SDKVersion = "1.2.32"
