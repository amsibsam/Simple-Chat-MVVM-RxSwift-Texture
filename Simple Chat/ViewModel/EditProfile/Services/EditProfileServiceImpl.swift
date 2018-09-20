//
//  EditProfileServiceImpl.swift
//  Simple Chat
//
//  Created by MTMAC16 on 19/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation

class EditProfileServiceImpl: EditProfileService {

    func editProfile(user: UserModel, completion: @escaping (UserModel?) -> Void) {
        FirebaseSharedServices.shared.editProfile(editedUser: user, completion: completion)
    }
    
    func getCurrentUser() -> UserModel {
        return FirebaseSharedServices.shared.currentUser
    }
}
