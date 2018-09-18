//
//  ChatViewController.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

class ChatViewController: ASViewController<ASDisplayNode> {
    let tableNode: ASTableNode
    let inputContainerNode: ASDisplayNode
    let tfInputNode: ASEditableTextNode
    let btnSend: ASButtonNode
    
    init() {
        tableNode = ASTableNode()
        inputContainerNode = ASDisplayNode()
        tfInputNode = ASEditableTextNode()
        btnSend = ASButtonNode()
        
        super.init(node: ASDisplayNode())
        self.node.backgroundColor = .white
        tableNode.backgroundColor = .white
        inputContainerNode.backgroundColor = .gray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.title = "Conversation"
        setupConstraint()
    }
    
    private func setupConstraint() {
        tableNode.view.translatesAutoresizingMaskIntoConstraints = false
        inputContainerNode.view.translatesAutoresizingMaskIntoConstraints = false
        tfInputNode.view.translatesAutoresizingMaskIntoConstraints = false
        btnSend.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // MARK: tableNode constraint
            tableNode.view.topAnchor.constraint(equalTo: self.node.view.topAnchor),
            tableNode.view.leftAnchor.constraint(equalTo: self.node.view.leftAnchor),
            tableNode.view.rightAnchor.constraint(equalTo: self.node.view.rightAnchor),
            tableNode.view.bottomAnchor.constraint(equalTo: inputContainerNode.view.topAnchor),
            
            // MARK: inputContainer constaint
            inputContainerNode.view.leftAnchor.constraint(equalTo: self.node.view.leftAnchor),
            inputContainerNode.view.rightAnchor.constraint(equalTo: self.node.view.rightAnchor),
            inputContainerNode.view.bottomAnchor.constraint(equalTo: self.node.view.bottomAnchor),
            inputContainerNode.view.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
