//
//  IDOSportModeSelectParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set sport mode select event number
@objcMembers
public class IDOSportModeSelectParamModel: NSObject, IDOBaseModel {
    /// 0: Invalid
    /// 1: Set quick sport type - sport_type1 & sport_type2 & sport_type3 & sport_type4
    /// 2: Set specific sport type
    public var flag: Int
    /// Quick sport type 1
    /// flag: 1 is valid
    public var sportType1: Int
    /// Quick sport type 2
    /// flag: 1 is valid
    public var sportType2: Int
    /// Quick sport type 3
    /// flag: 1 is valid
    public var sportType3: Int
    /// Quick sport type 4
    /// flag: 1 is valid
    public var sportType4: Int
    /// Type: Walking, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType0Walk: Bool
    /// Type: Running, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType0Run: Bool
    /// Type: Cycling, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType0ByBike: Bool
    /// Type: Walking (on foot), 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType0OnFoot: Bool
    /// Type: Swimming, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType0Swim: Bool
    /// Type: Mountain climbing, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType0MountainClimbing: Bool
    /// Type: Badminton, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType0Badminton: Bool
    /// Type: Other, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType0Other: Bool
    /// Type: Fitness, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType1Fitness: Bool
    /// Type: Spinning, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType1Spinning: Bool
    /// Type: Ellipsoid, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType1Ellipsoid: Bool
    /// Type: Treadmill, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType1Treadmill: Bool
    /// Type: Sit-ups, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType1SitUp: Bool
    /// Type: Push-ups, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType1PushUp: Bool
    /// Type: Dumbbell, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType1Dumbbell: Bool
    /// Type: Weightlifting, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType1Weightlifting: Bool
    /// Type: Bodybuilding exercise, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType2BodybuildingExercise: Bool
    /// Type: Yoga, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType2Yoga: Bool
    /// Type: Rope skipping, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType2RopeSkipping: Bool
    /// Type: Table tennis, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType2TableTennis: Bool
    /// Type: Basketball, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType2Basketball: Bool
    /// Type: Football, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType2Football: Bool
    /// Type: Volleyball, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType2Volleyball: Bool
    /// Type: Tennis, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType2Tennis: Bool
    /// Type: Golf, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType3Golf: Bool
    /// Type: Baseball, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType3Baseball: Bool
    /// Type: Skiing, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType3Skiing: Bool
    /// Type: Roller skating, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType3RollerSkating: Bool
    /// Type: Dance, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType3Dance: Bool
    /// Type: Strength training, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType3StrengthTraining: Bool
    /// Type: Core training, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType3CoreTraining: Bool
    /// Type: Tidy up and relax, 0 not supported, 1 supported
    /// flag: 2 is valid
    public var sportType3TidyUpRelax: Bool
    
    enum CodingKeys: String, CodingKey {
        case flag = "flag"
        case sportType1 = "sport_type1"
        case sportType2 = "sport_type2"
        case sportType3 = "sport_type3"
        case sportType4 = "sport_type4"
        case sportType0Walk = "sport_type0_walk"
        case sportType0Run = "sport_type0_run"
        case sportType0ByBike = "sport_type0_by_bike"
        case sportType0OnFoot = "sport_type0_on_foot"
        case sportType0Swim = "sport_type0_swim"
        case sportType0MountainClimbing = "sport_type0_mountain_climbing"
        case sportType0Badminton = "sport_type0_badminton"
        case sportType0Other = "sport_type0_other"
        case sportType1Fitness = "sport_type1_fitness"
        case sportType1Spinning = "sport_type1_spinning"
        case sportType1Ellipsoid = "sport_type1_ellipsoid"
        case sportType1Treadmill = "sport_type1_treadmill"
        case sportType1SitUp = "sport_type1_sit_up"
        case sportType1PushUp = "sport_type1_push_up"
        case sportType1Dumbbell = "sport_type1_dumbbell"
        case sportType1Weightlifting = "sport_type1_weightlifting"
        case sportType2BodybuildingExercise = "sport_type2_bodybuilding_exercise"
        case sportType2Yoga = "sport_type2_yoga"
        case sportType2RopeSkipping = "sport_type2_rope_skipping"
        case sportType2TableTennis = "sport_type2_table_tennis"
        case sportType2Basketball = "sport_type2_basketball"
        case sportType2Football = "sport_type2_football"
        case sportType2Volleyball = "sport_type2_volleyball"
        case sportType2Tennis = "sport_type2_tennis"
        case sportType3Golf = "sport_type3_golf"
        case sportType3Baseball = "sport_type3_baseball"
        case sportType3Skiing = "sport_type3_skiing"
        case sportType3RollerSkating = "sport_type3_roller_skating"
        case sportType3Dance = "sport_type3_dance"
        case sportType3StrengthTraining = "sport_type3_strength_training"
        case sportType3CoreTraining = "sport_type3_core_training"
        case sportType3TidyUpRelax = "sport_type3_tidy_up_relax"
    }
    
    public init(flag: Int,sportType1: Int,sportType2: Int,sportType3: Int,sportType4: Int,sportType0Walk: Bool,sportType0Run: Bool,sportType0ByBike: Bool,sportType0OnFoot: Bool,sportType0Swim: Bool,sportType0MountainClimbing: Bool,sportType0Badminton: Bool,sportType0Other: Bool,sportType1Fitness: Bool,sportType1Spinning: Bool,sportType1Ellipsoid: Bool,sportType1Treadmill: Bool,sportType1SitUp: Bool,sportType1PushUp: Bool,sportType1Dumbbell: Bool,sportType1Weightlifting: Bool,sportType2BodybuildingExercise: Bool,sportType2Yoga: Bool,sportType2RopeSkipping: Bool,sportType2TableTennis: Bool,sportType2Basketball: Bool,sportType2Football: Bool,sportType2Volleyball: Bool,sportType2Tennis: Bool,sportType3Golf: Bool,sportType3Baseball: Bool,sportType3Skiing: Bool,sportType3RollerSkating: Bool,sportType3Dance: Bool,sportType3StrengthTraining: Bool,sportType3CoreTraining: Bool,sportType3TidyUpRelax: Bool) {
        self.flag = flag
        self.sportType1 = sportType1
        self.sportType2 = sportType2
        self.sportType3 = sportType3
        self.sportType4 = sportType4
        self.sportType0Walk = sportType0Walk
        self.sportType0Run = sportType0Run
        self.sportType0ByBike = sportType0ByBike
        self.sportType0OnFoot = sportType0OnFoot
        self.sportType0Swim = sportType0Swim
        self.sportType0MountainClimbing = sportType0MountainClimbing
        self.sportType0Badminton = sportType0Badminton
        self.sportType0Other = sportType0Other
        self.sportType1Fitness = sportType1Fitness
        self.sportType1Spinning = sportType1Spinning
        self.sportType1Ellipsoid = sportType1Ellipsoid
        self.sportType1Treadmill = sportType1Treadmill
        self.sportType1SitUp = sportType1SitUp
        self.sportType1PushUp = sportType1PushUp
        self.sportType1Dumbbell = sportType1Dumbbell
        self.sportType1Weightlifting = sportType1Weightlifting
        self.sportType2BodybuildingExercise = sportType2BodybuildingExercise
        self.sportType2Yoga = sportType2Yoga
        self.sportType2RopeSkipping = sportType2RopeSkipping
        self.sportType2TableTennis = sportType2TableTennis
        self.sportType2Basketball = sportType2Basketball
        self.sportType2Football = sportType2Football
        self.sportType2Volleyball = sportType2Volleyball
        self.sportType2Tennis = sportType2Tennis
        self.sportType3Golf = sportType3Golf
        self.sportType3Baseball = sportType3Baseball
        self.sportType3Skiing = sportType3Skiing
        self.sportType3RollerSkating = sportType3RollerSkating
        self.sportType3Dance = sportType3Dance
        self.sportType3StrengthTraining = sportType3StrengthTraining
        self.sportType3CoreTraining = sportType3CoreTraining
        self.sportType3TidyUpRelax = sportType3TidyUpRelax
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

