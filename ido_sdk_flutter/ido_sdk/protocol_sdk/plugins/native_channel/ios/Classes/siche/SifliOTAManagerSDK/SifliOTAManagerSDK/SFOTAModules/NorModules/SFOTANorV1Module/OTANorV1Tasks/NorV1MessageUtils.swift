import UIKit

enum NorV1MessageType:UInt16 {
    case Init_Request = 0
    case Init_Response = 1
    case Init_Completed = 2
    case Resume_Request = 3
    case Resume_Response = 4
    case Resume_Completed = 5
    case Image_Send_Start = 6
    case Image_Send_Start_Response = 7
    case Image_Send_End = 8
    case Image_Send_End_Response = 9
    case Image_Send_Packet = 10
    case Image_Send_Packet_Response = 11
    case Transmission_End = 12
    case Transmission_End_Response = 13
    case Force_Init_Request = 14
    case Retransmit_Request = 16
    case Retransmit_Response = 17
    
    case Link_Lose_Check_Request = 35 // From Device
    case Link_Lose_Check_Response = 36 // To Device
}

class NorV1MessageUtils: NSObject {
    
    static func IsPaired(request:NorV1MessageType,response:NorV1MessageType) -> Bool{
        let req = request
        let rsp = response
        if (req == .Init_Request || req == .Force_Init_Request) && rsp == .Init_Response {
            return true
        }
        
        if  req == .Resume_Request && rsp == .Resume_Response {
            return true
        }
        
        if  req == .Image_Send_Start && rsp == .Image_Send_Start_Response{
            return true
        }
        
        if  req == .Image_Send_End && rsp == .Image_Send_End_Response {
            return true
        }
        
        if  req == .Image_Send_Packet && rsp == .Image_Send_Packet_Response{
            return true
        }
        
        if req == .Retransmit_Request && rsp == .Retransmit_Response{
            return true
        }
        if req == .Transmission_End && rsp == .Transmission_End_Response {
            return true
        }
        return false
        
    }
}
