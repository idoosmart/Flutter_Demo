package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

open class IDOMenuListParamModel(
    items: List<Int>
) : IDOBaseModel {

    /**List of applications that cannot be deleted
     * 0 invalid
     * 1 step
     * 2 Heart rate
     * 3 Sleep
     * 4 Take Pictures
     * 5 Alarm Clock
     * 6 Music
     * 7 stopwatch
     * 8 Timer
     * 9 Exercise mode
     * 10 Weather
     * 11 Breathing Exercises
     * 12 Finding your Phone
     * 13 pressure
     * 14 Data three rings
     * 15 time interface
     * 16 Last activity
     * 17 Health Data
     * 18 blood oxygen
     * 19 Menu Settings
     * 20 (20)aleax Voices are displayed in sequence
     * 21 X screen (New on gt01pro-X)
     * 22 calories (added by Doro Watch)
     * 23 distance (added by Doro Watch)
     * 24 One-touch measurement (Added in IDW05)
     * 25 renpho health(Added in IDW12)
     * 26 Compass (new on mp01)
     * 27 Barometric altimeter (new on mp01)
     */
    @SerializedName("items")
    var items: List<Int> = items

    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}