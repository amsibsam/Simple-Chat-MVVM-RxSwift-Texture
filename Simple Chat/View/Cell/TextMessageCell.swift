//
//  TextMessageCell.swift
//  Simple Chat
//
//  Created by MTMAC16 on 18/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class TextMessageCell: ASCellNode {
    let lblContentNode: ASEditableTextNode
    let lblNameNode: ASTextNode
    
    // MARK: private properties
    let message: ChatCellViewModel
    
    init(with message: ChatCellViewModel) {
        lblContentNode = ASEditableTextNode()
        lblNameNode = ASTextNode()
        self.message = message
        
        super.init()
        self.automaticallyManagesSubnodes = true
        lblContentNode.attributedText = NSAttributedString(string: self.message.content, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        lblContentNode.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        lblContentNode.clipsToBounds = true
        lblContentNode.backgroundColor = message.bubbleColor
        lblNameNode.attributedText = NSAttributedString(string: self.message.senderName, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
    }
    
    override func didLoad() {
        lblContentNode.layer.cornerRadius = 8
        lblContentNode.textView.isEditable = false
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalSpec = ASStackLayoutSpec.vertical()
        lblNameNode.style.alignSelf = message.isMyMessage
        lblContentNode.style.maxWidth = ASDimensionMake(UIScreen.main.bounds.width * (80/100))
        lblContentNode.style.alignSelf = message.isMyMessage
        lblContentNode.style.minWidth = ASDimensionMake(80)

        verticalSpec.children = [lblNameNode, lblContentNode]
    
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10), child: verticalSpec)
    }
}
