//
//  AuthService.swift
//  weave
//
//  Created by Karson Braaten on 2017-08-28.
//  Copyright © 2017 Karson Braaten. All rights reserved.
//

import UIKit

import FirebaseAuth

final class AuthService {
    
    static let shared = AuthService()
    
    private init() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.authState(auth, user)
        }
    }
    
    var currentUser: User? {
        get {
            return Auth.auth().currentUser
        }
    }
    
    var currentUserFirstName: String? {
        get {
            return Auth.auth().currentUser?.displayName?.components(separatedBy: " ").first
        }
    }
    
    var authState: (_ auth: Auth, _ user: User?) -> () = {_, _ in }
    
    func create(withEmail email: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (_ user: User?, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }
    
    func logout() {
        try! Auth.auth().signOut()
    }

}
