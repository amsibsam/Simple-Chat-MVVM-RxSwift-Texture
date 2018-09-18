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
    
    // MARK: private properties
    private let disposeBage: DisposeBag
    private var inputContainerHeightConstraint: NSLayoutConstraint?
    init() {
        disposeBage = DisposeBag()
        tableNode = ASTableNode()
        inputContainerNode = ASDisplayNode()
        tfInputNode = ASEditableTextNode()
        btnSend = ASButtonNode()
        
        super.init(node: ASDisplayNode())
        // MARK: node container config
        self.node.backgroundColor = .white
        
        // MARK: tableNode config
        tableNode.backgroundColor = .white
        tableNode.view.separatorStyle = .none
        
        // MARK: inputContainerNode config
        inputContainerNode.backgroundColor = .gray
        
        // MARK: tfIniputNode config
        tfInputNode.attributedPlaceholderText = NSAttributedString(string: "Type something..", attributes: [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        tfInputNode.typingAttributes = [NSAttributedStringKey.font.rawValue: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        tfInputNode.backgroundColor = .white
        tfInputNode.textContainerInset = UIEdgeInsets(top: 2, left: 15, bottom: 2, right: 8)
        tfInputNode.clipsToBounds = true
        
        // MARK: btnSend config
        btnSend.setImage(UIImage(named: "ic_send_white"), for: .normal)
        btnSend.setImage(UIImage(named: "ic_send_black"), for: .highlighted)
        btnSend.addTarget(self, action: #selector(ChatViewController.sendDidTap), forControlEvents: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: selector
    @objc func sendDidTap() {
        print("send message")
    }
    
    // MARK: private function
    private func setupUI() {
        self.title = "Conversation"
        tableNode.view.tableFooterView = UIView()
        tfInputNode.layer.cornerRadius = 10
        
        self.node.addSubnode(tableNode)
        self.node.addSubnode(inputContainerNode)
        inputContainerNode.addSubnode(tfInputNode)
        inputContainerNode.addSubnode(btnSend)
        setupConstraint()
        configureInputTextBehavior()
    }
    
    private func configureInputTextBehavior() {
        let fontHeight = tfInputNode.textView.font?.lineHeight
        tfInputNode.textView.rx.text.orEmpty.asDriver().skip(1).drive(onNext: { [unowned self] (_) in
            let line = self.tfInputNode.textView.contentSize.height / fontHeight!
            
            if line < 4 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.inputContainerHeightConstraint?.constant = self.calculateHeight().container.height
                })
            }
            
        }).disposed(by: disposeBage)
    }
    
    private func calculateHeight() -> (input: CGRect, container: CGRect) {
        var tfInputFrame = tfInputNode.frame
        tfInputFrame.size.height = tfInputNode.textView.contentSize.height + 2
        
        var inputContainerFrame = inputContainerNode.frame
        inputContainerFrame.size.height = tfInputNode.textView.contentSize.height + 10
        return (tfInputFrame, inputContainerFrame)
    }
    
    private func setupConstraint() {
        tableNode.view.translatesAutoresizingMaskIntoConstraints = false
        inputContainerNode.view.translatesAutoresizingMaskIntoConstraints = false
        tfInputNode.view.translatesAutoresizingMaskIntoConstraints = false
        btnSend.view.translatesAutoresizingMaskIntoConstraints = false
        inputContainerHeightConstraint = inputContainerNode.view.heightAnchor.constraint(equalToConstant: 35)
        
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
            inputContainerHeightConstraint!,
            
            // MARK: tfInputNode constraint
            tfInputNode.view.topAnchor.constraint(equalTo: inputContainerNode.view.topAnchor, constant: 5),
            tfInputNode.view.bottomAnchor.constraint(equalTo: inputContainerNode.view.bottomAnchor, constant: -5),
            tfInputNode.view.leadingAnchor.constraint(equalTo: inputContainerNode.view.leadingAnchor, constant: 8),
            tfInputNode.view.trailingAnchor.constraint(equalTo: btnSend.view.leadingAnchor, constant: 3),
            
            // MARK: btnSend constraint
            btnSend.view.trailingAnchor.constraint(equalTo: inputContainerNode.view.trailingAnchor, constant: 8),
            btnSend.view.centerYAnchor.constraint(equalTo: inputContainerNode.view.centerYAnchor),
            btnSend.view.heightAnchor.constraint(equalToConstant: 50),
            btnSend.view.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
