import Foundation

enum NandMessageType:UInt16 {
    case DFU_FILE_INIT_START = 21
    case DFU_FILE_INIT_RESPONSE = 22 // From Device
    
    case DFU_FILE_INIT_COMLETED = 23
    
    case DFU_FILE_START_REQUEST = 24
    case DFU_FILE_START_RESPONSE = 25 // From Device
    
    case DFU_FILE_PACKET_DATA = 26
    case DFU_FILE_PACKET_DATA_RESPONSE = 27 // From Device
    
    case DFU_FILE_END_REQUEST = 28
    case DFU_FILE_END_RESPONSE = 29 // From Device
    
    case DFU_FILE_TOTAL_END_REQUEST = 30
    case DFU_FILE_TOTAL_END_RESPONSE = 31 // From Device
    
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
    case DFU_IMAGE_TRANSMISSION_END_RESPONSE = 13
    
    case LINK_LOSE_CHECK_REQUEST = 35 // From Device
    case LINK_LOSE_CHECK_RESPONSE = 36 // To Device
    
    case ABORT = 37 // From Device
}


class NandMessageUtils:NSObject {
    static func IsPaired(requestType: NandMessageType, responseType: NandMessageType) -> Bool {
        let req = requestType
        let rsp = responseType
        if req == .DFU_FILE_INIT_START && rsp == .DFU_FILE_INIT_RESPONSE {
            return true
        }
        if req == .DFU_FILE_START_REQUEST && rsp == .DFU_FILE_START_RESPONSE{
            return true
        }
        if req == .DFU_FILE_PACKET_DATA && rsp == .DFU_FILE_PACKET_DATA_RESPONSE {
            return true
        }
        if req == .DFU_FILE_END_REQUEST && rsp == .DFU_FILE_END_RESPONSE{
            return true
        }
        if req == .DFU_FILE_TOTAL_END_REQUEST && rsp == .DFU_FILE_TOTAL_END_RESPONSE {
            return true
        }
        if req == .DFU_IMAGE_INIT_REQUEST_EXT && rsp == .DFU_IMAGE_INIT_RESPONSE_EXT{
            return true
        }
        if req == .DFU_IMAGE_START_REQUEST && rsp == .DFU_IMAGE_START_RESPONSE{
            return true
        }
        if req == .DFU_IMAGE_PACKET_DATA && rsp == .DFU_IMAGE_PACKET_DATA_RESPONSE {
            return true
        }
        if req == .DFU_IMAGE_END_REQUEST && rsp == .DFU_IMAGE_END_RESPONSE {
            return true
        }
        if req == .DFU_IMAGE_TRANSMISSION_END && rsp == .DFU_IMAGE_TRANSMISSION_END_RESPONSE{
            return true
        }
        return false
    }
}
