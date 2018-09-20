//
//  ChatCellViewModel.swift
//  Simple Chat
//
//  Created by MTMAC16 on 19/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol ChatCellViewModel {
    var isMyMessage: ASStackLayoutAlignSelf { get }
    var content: String { get }
    var senderName: String { get }
    var bubbleColor: UIColor { get }
    var contentColor: UIColor { get }
    
    init(message: MessageModel)
}
