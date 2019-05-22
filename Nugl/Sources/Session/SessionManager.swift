//
//  SessionManager.swift
//  Nugl
//
//  Created by Diego Pais on 4/29/18.
//  Copyright © 2018 Nugl. All rights reserved.
//

import Foundation
import FirebaseAuth

class SessionManager{

    static var shared = SessionManager()
    
    private init() {
        
        Auth.auth().addStateDidChangeListener { (aut: Auth, user: User?) in
            NotificationCenter.default.post(name: NSNotification.Name.Session.userSessionDidChange, object: nil)
        }
    }
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    func signIn(with email: String, password: String, onCompltion: @escaping (User?, Error?) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user: User?, error: Error?) in
            onCompltion(user, error)
        }
    }
    
    func signUp(with email: String, password: String, onCompletion: @escaping (User?, Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            onCompletion(user, error)
        }
    }
    
    func signOut() {
        try! Auth.auth().signOut()
    }
    
    func resetPassword(for email: String, onCompletion: @escaping (Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: onCompletion)
    }
}

