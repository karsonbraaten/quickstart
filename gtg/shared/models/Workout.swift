//
//  Workout.swift
//  gtg
//
//  Created by Karson Braaten on 2017-10-23.
//  Copyright © 2017 Star Barrel Studios. All rights reserved.
//

import Foundation

struct Workout: Codable {
    let date: Date
    let goal: Int
    let totalSets: Int
    let exercises: [Exercise]

    var dictionary: [String: Any] {
        return [
            "date": date,
            "goal": goal,
            "totalSets": totalSets,
            "exercises": exercises.map { $0.dictionary },
        ]
    }
    
    var goalMet: Bool {
        return totalSets >= goal
    }
    
    var description: String {
        return exercises.isEmpty
            ? "No exercises yet"
            : "\(exercises.map { $0.movement }.joined(separator: ", "))"
    }
    
    var summary: String {
        return exercises.isEmpty
            ? "No exercises yet"
            : "\(goal) x \(exercises.map { "\($0.reps) \($0.movement.lowercased())" }.joined(separator: ", "))"
    }
}

extension Workout: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard
            let date = dictionary["date"] as? Date,
            let goal = dictionary["goal"] as? Int,
            let exercisesData = dictionary["exercises"] as? [NSDictionary]
            else { return nil }
        
        let totalSets = (dictionary["totalSets"] as? Int) ?? 0
        let exercises = exercisesData.flatMap { Exercise(dictionary: $0 as! [String : Any]) }
        
        self.init(date: date, goal: goal, totalSets: totalSets, exercises: exercises)
    }
    
}

extension Workout: Comparable {
    
    static func <(lhs: Workout, rhs: Workout) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func ==(lhs: Workout, rhs: Workout) -> Bool {
        return
            Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .day) == .orderedSame &&
                lhs.goal == rhs.goal &&
                lhs.exercises == rhs.exercises
    }
    
}

//extension Workout: Streakable {
//    var passes: Bool {
//        return goalMet
//    }
//}

