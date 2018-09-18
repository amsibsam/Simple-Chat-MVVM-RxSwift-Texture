//
//  Constant.swift
//  Simple Chat
//
//  Created by MTMAC16 on 13/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import Firebase

class Constant {
    static let rootDB: DatabaseReference = Database.database().reference()
    
    static var chatDB: DatabaseReference = rootDB.child("chats")
}
