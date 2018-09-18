//
//  MessageModel.swift
//  Simple Chat
//
//  Created by MTMAC16 on 18/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation

class MessageModel {
    let name: String
    let senderId: String
    let text: String
    
    init(name: String, senderId: String, text: String) {
        self.name = name
        self.senderId = senderId
        self.text = text
    }
}
