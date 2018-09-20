//
//  ChatCellViewModelImpl.swift
//  Simple Chat
//
//  Created by MTMAC16 on 19/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ChatCellViewModelImpl: ChatCellViewModel {
    var isMyMessage: ASStackLayoutAlignSelf {
        get {
            return message.senderId == FirebaseSharedServices.shared.currentUser.userId ?? "" ? .end : .start
        }
    }
    
    var bubbleColor: UIColor {
        get {
            return message.senderId == FirebaseSharedServices.shared.currentUser.userId ?? "" ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    }
    
    var contentColor: UIColor {
        get {
            return message.senderId == FirebaseSharedServices.shared.currentUser.userId ?? "" ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.9141104294) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    var content: String {
        get {
            return message.text
        }
    }
    
    var senderName: String {
        get {
            return message.name
        }
    }
    
    private let message: MessageModel
    required init(message: MessageModel) {
        self.message = message
    }
}
