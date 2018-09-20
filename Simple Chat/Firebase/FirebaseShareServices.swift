//
//  FirebaseShareServices.swift
//  Simple Chat
//
//  Created by MTMAC16 on 19/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class FirebaseSharedServices {
    static let shared: FirebaseSharedServices = FirebaseSharedServices()
    
    private let rootDB: DatabaseReference
    private let chatDB: DatabaseReference
    
    private var isUpdateNameComplete: Bool = false
    private var isUpdateEmailComplete: Bool = false
    
    // MARK: public properties
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
//    var message: BehaviorRelay
    
    var currentUser: UserModel {
        if let loggedInUser = Auth.auth().currentUser {
            return UserModel(user: loggedInUser)
        }
        fatalError("User are not logged in or something went wrong, please check isLoggedIn first")
    }
    
    init() {
        FirebaseApp.configure()
        rootDB = Database.database().reference()
        chatDB = rootDB.child("chats")
    }
    
    // MARK: public function
    func observeMessage(completion: @escaping (MessageModel) -> Void) {
        chatDB.observe(.childAdded) { (snapshot) in
            print("data added \(snapshot)")
            
            if let snapshotData = snapshot.value as? [String: Any] {
                let senderName = snapshotData["name"] as? String ?? ""
                let text = snapshotData["text"] as? String ?? ""
                let senderId = snapshotData["sender_id"] as? String ?? ""
                
                completion(MessageModel(name: senderName, senderId: senderId, text: text))
            }
        }
    }
    
    func sendMessage(with message: MessageModel) {
        let message = [
            "name": message.name,
            "sender_id": message.senderId,
            "text": message.text
        ]
        
        let chatRef = chatDB.childByAutoId()
        chatRef.setValue(message)
    }
    
    func editProfile(editedUser user: UserModel, completion: @escaping (UserModel?) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = user.displayName
        changeRequest?.commitChanges(completion: { [ weak self ] (error) in
            if let errorUpdate = error {
                print("error update user \(errorUpdate))")
                completion(nil)
            } else {
                self?.isUpdateNameComplete = true
                self?.checkUpdateStatus(completion: completion)
            }
        })
        Auth.auth().currentUser?.updateEmail(to: user.email ?? "", completion: { [ weak self ] (error) in
            if let errorUpdate = error {
                print("error update user \(errorUpdate))")
                completion(nil)
            } else {
                self?.isUpdateEmailComplete = true
                self?.checkUpdateStatus(completion: completion)
            }
        })
    }
    
    func verify(with code: String, completion: @escaping (UserModel?, Error?) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.getVerificationId(), verificationCode: code)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if let errorVerify = error {
                completion(nil, errorVerify)
            } else {
                if let loggedInUser = result?.user {
                    completion(UserModel(user: loggedInUser), nil)
                } else {
                    completion(nil, NSError(domain: "cant find user", code: 1, userInfo: nil))
                }
            }
        }
    }
    
    func login(with phoneNumber: String, completion: @escaping(Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if let id = verificationId {
                UserDefaults.standard.saveVerificationId(id)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let error as NSError {
            print("failed to logout \(error), \(error.userInfo)")
            completion(false)
        }
    }
    
    // MARK: private function
    private func checkUpdateStatus(completion: @escaping (UserModel?) -> Void) {
        if isUpdateNameComplete && isUpdateEmailComplete {
            if let loggedInUser = Auth.auth().currentUser {
                completion(UserModel(user: loggedInUser))
            } else {
                completion(nil)
            }
        }
    }
}
