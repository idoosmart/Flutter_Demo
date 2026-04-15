//
//  IDOSportModeSelectParamModel.kt
//  protocol_channel
//
//  Created by hedongyang on 2023/10/30.
//

package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

///
/// Set sport mode select event number

open class   IDOSportModeSelectParamModel(
    flag: Int,
    sportType1: Int,
    sportType2: Int,
    sportType3: Int,
    sportType4: Int,
    sportType0Walk: Boolean,
    sportType0Run: Boolean,
    sportType0ByBike: Boolean,
    sportType0OnFoot: Boolean,
    sportType0Swim: Boolean,
    sportType0MountainClimbing: Boolean,
    sportType0Badminton: Boolean,
    sportType0Other: Boolean,
    sportType1Fitness: Boolean,
    sportType1Spinning: Boolean,
    sportType1Ellipsoid: Boolean,
    sportType1Treadmill: Boolean,
    sportType1SitUp: Boolean,
    sportType1PushUp: Boolean,
    sportType1Dumbbell: Boolean,
    sportType1Weightlifting: Boolean,
    sportType2BodybuildingExercise: Boolean,
    sportType2Yoga: Boolean,
    sportType2RopeSkipping: Boolean,
    sportType2TableTennis: Boolean,
    sportType2Basketball: Boolean,
    sportType2Football: Boolean,
    sportType2Volleyball: Boolean,
    sportType2Tennis: Boolean,
    sportType3Golf: Boolean,
    sportType3Baseball: Boolean,
    sportType3Skiing: Boolean,
    sportType3RollerSkating: Boolean,
    sportType3Dance: Boolean,
    sportType3StrengthTraining: Boolean,
    sportType3CoreTraining: Boolean,
    sportType3TidyUpRelax: Boolean
) : IDOBaseModel {

    /// 0: Invalid
    /// 1: Set quick sport type - sport_type1 & sport_type2 & sport_type3 & sport_type4
    /// 2: Set specific sport type
    @SerializedName("flag")
    var flag: Int = flag

    /// Quick sport type 1
    /// flag: 1 is valid
    @SerializedName("sport_type1")
    var sportType1: Int = sportType1

    /// Quick sport type 2
    /// flag: 1 is valid
    @SerializedName("sport_type2")
    var sportType2: Int = sportType2

    /// Quick sport type 3
    /// flag: 1 is valid
    @SerializedName("sport_type3")
    var sportType3: Int = sportType3

    /// Quick sport type 4
    /// flag: 1 is valid
    @SerializedName("sport_type4")
    var sportType4: Int = sportType4

    /// Type: Walking, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type0_walk")
    var sportType0Walk: Boolean = sportType0Walk

    /// Type: Running, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type0_run")
    var sportType0Run: Boolean = sportType0Run

    /// Type: Cycling, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type0_by_bike")
    var sportType0ByBike: Boolean = sportType0ByBike

    /// Type: Walking (on foot), 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type0_on_foot")
    var sportType0OnFoot: Boolean = sportType0OnFoot

    /// Type: Swimming, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type0_swim")
    var sportType0Swim: Boolean = sportType0Swim

    /// Type: Mountain climbing, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type0_mountain_climbing")
    var sportType0MountainClimbing: Boolean = sportType0MountainClimbing

    /// Type: Badminton, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type0_badminton")
    var sportType0Badminton: Boolean = sportType0Badminton

    /// Type: Other, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type0_other")
    var sportType0Other: Boolean = sportType0Other

    /// Type: Fitness, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type1_fitness")
    var sportType1Fitness: Boolean = sportType1Fitness

    /// Type: Spinning, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type1_spinning")
    var sportType1Spinning: Boolean = sportType1Spinning

    /// Type: Ellipsoid, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type1_ellipsoid")
    var sportType1Ellipsoid: Boolean = sportType1Ellipsoid

    /// Type: Treadmill, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type1_treadmill")
    var sportType1Treadmill: Boolean = sportType1Treadmill

    /// Type: Sit-ups, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type1_sit_up")
    var sportType1SitUp: Boolean = sportType1SitUp

    /// Type: Push-ups, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type1_push_up")
    var sportType1PushUp: Boolean = sportType1PushUp

    /// Type: Dumbbell, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type1_dumbbell")
    var sportType1Dumbbell: Boolean = sportType1Dumbbell

    /// Type: Weightlifting, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type1_weightlifting")
    var sportType1Weightlifting: Boolean = sportType1Weightlifting

    /// Type: Bodybuilding exercise, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type2_bodybuilding_exercise")
    var sportType2BodybuildingExercise: Boolean = sportType2BodybuildingExercise

    /// Type: Yoga, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type2_yoga")
    var sportType2Yoga: Boolean = sportType2Yoga

    /// Type: Rope skipping, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type2_rope_skipping")
    var sportType2RopeSkipping: Boolean = sportType2RopeSkipping

    /// Type: Table tennis, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type2_table_tennis")
    var sportType2TableTennis: Boolean = sportType2TableTennis

    /// Type: Basketball, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type2_basketball")
    var sportType2Basketball: Boolean = sportType2Basketball

    /// Type: Football, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type2_footballl")
    var sportType2Football: Boolean = sportType2Football

    /// Type: Volleyball, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type2_volleyball")
    var sportType2Volleyball: Boolean = sportType2Volleyball

    /// Type: Tennis, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type2_tennis")
    var sportType2Tennis: Boolean = sportType2Tennis

    /// Type: Golf, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type3_golf")
    var sportType3Golf: Boolean = sportType3Golf

    /// Type: Baseball, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type3_baseball")
    var sportType3Baseball: Boolean = sportType3Baseball

    /// Type: Skiing, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type3_skiing")
    var sportType3Skiing: Boolean = sportType3Skiing

    /// Type: Roller skating, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type3_roller_skating")
    var sportType3RollerSkating: Boolean = sportType3RollerSkating

    /// Type: Dance, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type3_dance")
    var sportType3Dance: Boolean = sportType3Dance

    /// Type: Strength training, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type3_strength_training")
    var sportType3StrengthTraining: Boolean = sportType3StrengthTraining

    /// Type: Core training, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type3_core_training")
    var sportType3CoreTraining: Boolean = sportType3CoreTraining

    /// Type: Tidy up and relax, 0 not supported, 1 supported
    /// flag: 2 is valid
    @SerializedName("sport_type3_tidy_up_relax")
    var sportType3TidyUpRelax: Boolean = sportType3TidyUpRelax


    

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
    