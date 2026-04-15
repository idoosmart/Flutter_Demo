//
//  IDOWallpaperDialReplyV3ParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set wallpaper dial list event number
@objcMembers
public class IDOWallpaperDialReplyV3ParamModel: NSObject, IDOBaseModel {
    /// Operation: 0 for query, 1 for setting, 2 for deleting the wallpaper dial
    public var operate: Int
    /// Set location information, reference to the 9-grid layout
    public var location: Int
    /// Hide type: 0 for showing all, 1 for hiding sub-controls (icons and numbers)
    public var hideType: Int
    /// Color of time control (1 byte reserved + R (1 byte) + G (1 byte) + B (1 byte))
    public var timeColor: Int
    /// Control type: 1 for week/date, 2 for steps, 3 for distance, 4 for calories, 5 for heart rate, 6 for battery
    public var widgetType: Int
    /// Color of widget icons (1 byte reserved + R (1 byte) + G (1 byte) + B (1 byte))
    public var widgetIconColor: Int
    /// Color of widget numbers (1 byte reserved + R (1 byte) + G (1 byte) + B (1 byte)) 
    public var widgetNumColor: Int
    
    enum CodingKeys: String, CodingKey {
        case operate = "operate"
        case location = "location"
        case hideType = "hide_type"
        case timeColor = "time_color"
        case widgetType = "widget_type"
        case widgetIconColor = "widget_icon_color"
        case widgetNumColor = "widget_num_color"
    }
    
    public init(operate: Int,location: Int,hideType: Int,timeColor: Int,widgetType: Int,widgetIconColor: Int,widgetNumColor: Int) {
        self.operate = operate
        self.location = location
        self.hideType = hideType
        self.timeColor = timeColor
        self.widgetType = widgetType
        self.widgetIconColor = widgetIconColor
        self.widgetNumColor = widgetNumColor
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

