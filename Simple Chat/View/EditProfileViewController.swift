//
//  EditProfileViewController.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

class EditProfileViewController: ASViewController<ASDisplayNode> {
    let tableView: ASTableNode
    let inputContainer: ASDisplayNode
    
    init() {
        tableView = ASTableNode(style: UITableViewStyle.plain)
        inputContainer = ASDisplayNode()
        super.init(node: ASDisplayNode())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: private func
    fileprivate func setupUI() {
        self.node.addSubnode(tableView)
        self.node.addSubnode(inputContainer)
        setupConstraint()
    }
    
    fileprivate func setupConstraint() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
