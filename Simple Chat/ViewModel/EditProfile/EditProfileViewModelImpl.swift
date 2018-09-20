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
    var isSuccess: Driver<UserModel?> {
        get {
            return varSuccess.asDriver()
        }
    }
    var isLoggedOut: Driver<Bool> {
        get {
            return varLoggedOut.asDriver()
        }
    }
    
    // MARK: private properties
    private let varMenu: BehaviorRelay<[MenuModel]> = BehaviorRelay(value: [])
    private let varLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let varSuccess: BehaviorRelay<UserModel?> = BehaviorRelay(value: nil)
    private let varLoggedOut: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var service: EditProfileService = EditProfileServiceImpl()
    
    func getMenu() {
        let menuModel = [
            MenuModel(title: "Display Name", value: service.getCurrentUser().displayName ?? ""),
            MenuModel(title: "Email", value: service.getCurrentUser().email ?? ""),
            MenuModel(title: "Save", value: "")
        ]
    
        varMenu.accept(menuModel)
    }
    
    func update() {
        varLoading.accept(true)
        let updatedUser: UserModel = FirebaseSharedServices.shared.currentUser
        updatedUser.displayName = varMenu.value[0].value
        updatedUser.email = varMenu.value[1].value
        
        service.editProfile(user: updatedUser) { [weak self] (updatedUser) in
            self?.varLoading.accept(false)
            self?.varSuccess.accept(updatedUser)
        }
    }
    
    func signOut() {
        FirebaseSharedServices.shared.logout { [weak self] (success) in
            self?.varLoggedOut.accept(success)
        }
    }
}
