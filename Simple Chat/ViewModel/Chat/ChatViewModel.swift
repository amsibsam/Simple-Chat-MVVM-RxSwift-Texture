//
//  ChatViewModel.swift
//  Simple Chat
//
//  Created by MTMAC16 on 18/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxCocoa

protocol ChatViewModel: class {
    var messages: BehaviorRelay<[MessageModel]> { get }
    
    func getMessages()
    func sendMessage(with text: String)
}
