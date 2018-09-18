//
//  EditProfileViewModelImpl.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class EditProfileViewModelImpl: EditProfileViewModel {
    var menu: BehaviorRelay<[MenuModel]> {
        get {
            return varMenu
        }
    }
    var isLoading: Driver<Bool> {
        get {
            return varLoading.asDriver()
        }
    }
    var isSuccess: Driver<User?> {
        get {
            return varSuccess.asDriver()
        }
    }
    
    // MARK: private properties
    private let varMenu: BehaviorRelay<[MenuModel]> = BehaviorRelay(value: [])
    private let varLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let varSuccess: BehaviorRelay<User?> = BehaviorRelay(value: nil)
    private var isUpdateNameComplete: Bool = false
    private var isUpdateEmailComplete: Bool = false
    
    func getMenu() {
        let menuModel = [
            MenuModel(title: "Display Name", value: Auth.auth().currentUser?.displayName ?? ""),
            MenuModel(title: "Email", value: Auth.auth().currentUser?.email ?? ""),
            MenuModel(title: "Save", value: "")
        ]
    
        varMenu.accept(menuModel)
    }
    
    func update() {
        varLoading.accept(true)
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = menu.value[0].value
        changeRequest?.commitChanges(completion: { [ weak self ] (error) in
            self?.varLoading.accept(false)
            if let errorUpdate = error {
                print("error update user \(errorUpdate))")
                self?.varSuccess.accept(nil)
            } else {
                self?.isUpdateNameComplete = true
                self?.checkUpdateStatus()
            }
        })
        Auth.auth().currentUser?.updateEmail(to: menu.value[1].value, completion: { [ weak self ] (error) in
            self?.varLoading.accept(false)
            if let errorUpdate = error {
                print("error update user \(errorUpdate))")
                self?.varSuccess.accept(nil)
            } else {
                self?.isUpdateEmailComplete = true
                self?.checkUpdateStatus()
            }
        })
    }
    
    func checkUpdateStatus() {
        if isUpdateNameComplete && isUpdateEmailComplete {
            varLoading.accept(false)
            varSuccess.accept(Auth.auth().currentUser)
        }
    }
}
