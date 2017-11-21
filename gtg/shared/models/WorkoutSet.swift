//
//  Set.swift
//  gtg
//
//  Created by Karson Braaten on 2017-10-24.
//  Copyright © 2017 Star Barrel Studios. All rights reserved.
//

import Foundation

struct WorkoutSet {
    
    let exercises: [Exercise]
    let timestamp: Date
    let workoutId: String
    
    var dictionary: [String: Any] {
        return [
            "exercises": exercises.map { $0.dictionary },
            "timestamp": timestamp,
            "workoutId": workoutId,
            "movements": self.movementKeys(for: exercises)
        ]
    }
    
    private func movementKeys(for exercises: [Exercise]) -> [String: Bool] {
        let keys = exercises.reduce(Dictionary<String, Bool>()) { acc, cur in
            var dict: [String: Bool] = acc
            dict[cur.movement] = true
            return dict
        }
        return keys
    }
    
    var description: String {
        return "\(exercises.map { $0.description }.joined(separator: ", "))"
    }

}

extension WorkoutSet: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard
            let timestamp = dictionary["timestamp"] as? Date,
            let workoutId = dictionary["workoutId"] as? String,
            let exercisesData = dictionary["exercises"] as? [NSDictionary]
            else { return nil }
        
        let exercises = exercisesData.flatMap { Exercise(dictionary: $0 as! [String : Any]) }
        
        self.init(exercises: exercises, timestamp: timestamp, workoutId: workoutId)
    }
    
}
