import Foundation

enum NorV2MessageType:UInt16 {
    case DFU_IMAGE_INIT_REQUEST_EXT = 32
    case DFU_IMAGE_INIT_RESPONSE_EXT = 33
    
    case DFU_IMAGE_INIT_COMPLETED_EXT = 34
    
    case DFU_IMAGE_START_REQUEST = 6
    case DFU_IMAGE_START_RESPONSE = 7
    
    case DFU_IMAGE_PACKET_DATA = 10
    case DFU_IMAGE_PACKET_DATA_RESPONSE = 11
    
    case DFU_IMAGE_END_REQUEST = 8
    case DFU_IMAGE_END_RESPONSE = 9
    
    case DFU_IMAGE_TRANSMISSION_END = 12
    // 根据DFU_IMAGE_START_RESPONSE返回的end mode来决定是否等待该回复
    case DFU_IMAGE_END = 13
    
    case LINK_LOSE_CHECK_REQUEST = 35 // From Device
    case LINK_LOSE_CHECK_RESPONSE = 36 // To Device
    
    case ABORT = 37
    
    case DFU_IMAGE_OFFLINE_START_REQ = 38
    case DFU_IMAGE_OFFLINE_START_RSP = 39
    
    case DFU_IMAGE_OFFLINE_PACKET_REQ = 40
    case DFU_IMAGE_OFFLINE_PACKET_RSP = 41
    
    case DFU_IMAGE_OFFLINE_END_REQ = 42
    case DFU_IMAGE_OFFLINE_END_RSP = 43
}


class NorV2MessageUtils:NSObject {
    static func IsPaired(requestType: NorV2MessageType, responseType: NorV2MessageType) -> Bool {
        let req = requestType
        let rsp = responseType
        if req == .DFU_IMAGE_INIT_REQUEST_EXT && rsp == .DFU_IMAGE_INIT_RESPONSE_EXT {
            return true
        }
        if req == .DFU_IMAGE_START_REQUEST && rsp == .DFU_IMAGE_START_RESPONSE {
            return true
        }
        
        if req == .DFU_IMAGE_PACKET_DATA && rsp == .DFU_IMAGE_PACKET_DATA_RESPONSE {
            return true
        }
        
        if req == .DFU_IMAGE_END_REQUEST && rsp == .DFU_IMAGE_END_RESPONSE {
            return true
        }
        if req == .DFU_IMAGE_TRANSMISSION_END && rsp == .DFU_IMAGE_END {
            return true
        }
        if req == .DFU_IMAGE_OFFLINE_START_REQ && rsp == .DFU_IMAGE_OFFLINE_START_RSP{
            return true
        }
        
        if req == .DFU_IMAGE_OFFLINE_PACKET_REQ && rsp == .DFU_IMAGE_OFFLINE_PACKET_RSP{
            return true
        }
        if req == .DFU_IMAGE_OFFLINE_END_REQ && rsp == .DFU_IMAGE_OFFLINE_END_RSP{
            return true
        }
        return false
    }
}
