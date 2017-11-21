//
//  Exercise.swift
//  gtg
//
//  Created by Karson Braaten on 2017-10-23.
//  Copyright © 2017 Star Barrel Studios. All rights reserved.
//

import Foundation

struct Exercise: Codable {
    let movement: String
    let reps: Int
    
    var dictionary: [String: Any] {
        return [
            "movement": movement,
            "reps": reps
        ]
    }
    
    var description: String {
        return "\(reps) \(movement.lowercased())"
    }
}

extension Exercise: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard
            let movement = dictionary["movement"] as? String,
            let reps = dictionary["reps"] as? Int
            else { return nil }
        
        self.init(movement: movement, reps: reps)
    }
    
}

extension Exercise: Comparable {
    
    static func <(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.reps < rhs.reps
    }
    
    static func ==(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.movement == rhs.movement && lhs.reps == rhs.reps
    }
    
}
