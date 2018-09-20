//
//  EditProfileService.swift
//  Simple Chat
//
//  Created by MTMAC16 on 19/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation

protocol EditProfileService {
    func editProfile(user: UserModel, completion: @escaping (UserModel?) -> Void)
    func getCurrentUser() -> UserModel
}
