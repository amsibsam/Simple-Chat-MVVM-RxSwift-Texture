//
//  ChatViewModelImpl.swift
//  Simple Chat
//
//  Created by MTMAC16 on 18/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChatViewModelImpl: ChatViewModel {
    var messages: BehaviorRelay<[MessageModel]> {
        get {
            return varMessage
        }
    }
    
    // MARK: private properties
    private let varMessage: BehaviorRelay<[MessageModel]> = BehaviorRelay(value: [])
    
    func getMessages() {
        /*Dummy data for now*/
        FirebaseSharedServices.shared.observeMessage { [weak self] (message) in
            if let selfInstance = self {
                selfInstance.varMessage.accept(selfInstance.varMessage.value + [message])
            }
        }
    }
    
    func sendMessage(with text: String) {
        let loggedInUser = FirebaseSharedServices.shared.currentUser
        let message = MessageModel(name: loggedInUser.displayName ?? "", senderId: loggedInUser.userId ?? "", text: text)
        FirebaseSharedServices.shared.sendMessage(with: message)
    }
}
