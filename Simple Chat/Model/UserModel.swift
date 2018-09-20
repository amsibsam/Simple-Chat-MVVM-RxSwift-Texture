//
//  UserModel.swift
//  Simple Chat
//
//  Created by MTMAC16 on 19/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import Firebase

class UserModel {
    let userId: String?
    var displayName: String?
    var email: String?
    var phoneNumber: String?
    
    init(user: User) {
        self.userId = user.uid
        self.displayName = user.displayName
        self.email = user.email
        self.phoneNumber = user.phoneNumber
    }
}
