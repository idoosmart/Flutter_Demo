//
//  IDOSchedulerReminderParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import java.io.Serializable
import com.google.gson.annotations.SerializedName

///

// MARK: - IDOSchedulerReminderParamModel
open class IDOSchedulerReminderParamModel(operate: Int, items: List<IDOSchedulerReminderItem>) :
    IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    @SerializedName("operate")
    var operate: Int = operate

    @SerializedName("num")
    private var num: Int = items.size

    @SerializedName("items")
    var items: List<IDOSchedulerReminderItem> = items

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}


// MARK: - IDOSchedulerReminderModel
open class IDOSchedulerReminderModel(
    operate: Int,
    errCode: Int,
    items: List<IDOSchedulerReminderItem>
) : IDOBaseModel {

    @SerializedName("version")
    private var version: Int = 0

    /// Operation type<br />0: Invalid<br />1: Add<br />2: Delete<br />3: Query<br />4: Modify
    @SerializedName("operate")
    var operate: Int = operate

    /// Error code. 0 if successful, non-zero if error
    @SerializedName("err_code")
    var errCode: Int = errCode

    @SerializedName("num")
    private var num: Int = items.size

    @SerializedName("items")
    var items: List<IDOSchedulerReminderItem> = items
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }


}

// MARK: - IDOSchedulerReminderItem
open class IDOSchedulerReminderItem(
    id: Int,
    year: Int,
    mon: Int,
    day: Int,
    hour: Int,
    min: Int,
    sec: Int,
    repeatType: Int,
    remindOnOff: Int,
    state: Int,
    title: String,
    note: String
) : Serializable {
    /// Reminder event ID. Incremental value sent by the app, starting from 0
    @SerializedName("id")
    var id: Int = id

    @SerializedName("year")
    var year: Int = year

    @SerializedName("mon")
    var mon: Int = mon

    @SerializedName("day")
    var day: Int = day

    @SerializedName("hour")
    var hour: Int = hour

    @SerializedName("min")
    var min: Int = min

    @SerializedName("sec")
    var sec: Int = sec

    /// Repeat time <br />Set bit1-bit7 for week-based repeat if enabled with
    /// `getSupportSetRepeatWeekTypeOnScheduleReminderV3` (Monday to Sunday, with bit 0 as the general switch)
    /// Set repeat type (0: Invalid, 1: Once, 2: Daily, 3: Weekly, 4: Monthly, 5: Yearly) if enabled with
    /// `getSupportSetRepeatTypeOnScheduleReminderV3`
    @SerializedName("repeat_type")
    var repeatType: Int = repeatType

    /// Daily reminder switch<br />0: Off, 1: On
    @SerializedName("remind_on_off")
    var remindOnOff: Int = remindOnOff

    /// State code <br />0: Invalid, 1: Deleted, 2: Enabled
    @SerializedName("state")
    var state: Int = state

    /// Title content. Maximum 74 bytes
    @SerializedName("title")
    var title: String = title

    /// Reminder content. Maximum 149 bytes
    @SerializedName("note")
    var note: String = note

}
