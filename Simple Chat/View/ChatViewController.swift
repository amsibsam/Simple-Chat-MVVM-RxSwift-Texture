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
import IQKeyboardManager

class ChatViewController: ASViewController<ASDisplayNode> {
    let tableNode: ASTableNode
    let inputContainerNode: ASDisplayNode
    let tfInputNode: ASEditableTextNode
    let btnSend: ASButtonNode
    
    // MARK: private properties
    private let disposeBag: DisposeBag
    private var inputContainerHeightConstraint: NSLayoutConstraint?
    private var inputContainerBottomConstraint: NSLayoutConstraint?
    private var inputContainerUpperBottomConstraint: NSLayoutConstraint?
    private let viewModel: ChatViewModel
    private var keyboardHeight: CGFloat = 0.0
    
    init() {
        disposeBag = DisposeBag()
        viewModel = ChatViewModelImpl()
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
        tableNode.delegate = self
        tableNode.dataSource = self
        
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
    
    // MARK: life cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        enableIQKeyboard(enable: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableIQKeyboard(enable: false)
    }
    
    // MARK: selector
    @objc func sendDidTap() {
        viewModel.sendMessage(with: tfInputNode.textView.text!)
        tfInputNode.textView.text = ""
    }
    
    @objc func editDidTap() {
        self.navigationController?.pushViewController(EditProfileViewController(), animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if self.inputContainerBottomConstraint?.constant == 0 {
            if keyboardHeight == 0 {
                keyboardHeight = keyboardSize.height
            }
            
            UIView.animate(withDuration: 1) { [unowned self] in
                self.inputContainerBottomConstraint?.isActive = false
                self.inputContainerUpperBottomConstraint?.isActive = true
                self.inputContainerUpperBottomConstraint?.constant -= self.keyboardHeight
                self.node.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 1) { [unowned self] in
            self.inputContainerUpperBottomConstraint?.constant = 0
            self.inputContainerUpperBottomConstraint?.isActive = false
            self.inputContainerBottomConstraint?.isActive = true
            self.node.view.layoutIfNeeded()
        }
    }
    
    // MARK: private function
    private func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.dismissKeyboardWhenTappedAround()
        self.title = "Conversation"
        tableNode.view.tableFooterView = UIView()
        tfInputNode.layer.cornerRadius = 10
        self.node.view.backgroundColor = .gray

        
        self.node.addSubnode(tableNode)
        self.node.addSubnode(inputContainerNode)
        inputContainerNode.addSubnode(tfInputNode)
        inputContainerNode.addSubnode(btnSend)
        setupNavigation()
        setupConstraint()
        setupInputTextBehavior()
        bindModelToView()
    }
    
    private func setupNavigation() {
        let settingButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(ChatViewController.editDidTap))
        
        self.navigationItem.rightBarButtonItems = [settingButton]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func bindModelToView() {
        viewModel.messages.asDriver().drive(onNext: { [weak self] (_) in
            if let chatVc = self {
                let newItemIndex = IndexPath(row: chatVc.viewModel.messages.value.count - 1, section: 0)
                chatVc.tableNode.insertRows(at: [newItemIndex], with: .right)
                chatVc.tableNode.scrollToRow(at: newItemIndex, at: .bottom, animated: true)
            }
        }).disposed(by: disposeBag)
        
        viewModel.getMessages()
    }
    
    private func enableIQKeyboard(enable: Bool) {
        IQKeyboardManager.shared().isEnabled = enable
        IQKeyboardManager.shared().isEnableAutoToolbar = enable
    }
    
    private func setupInputTextBehavior() {
        let fontHeight = tfInputNode.textView.font?.lineHeight
        tfInputNode.textView.rx.text.orEmpty.asDriver().skip(1).drive(onNext: { [unowned self] (_) in
            let line = self.tfInputNode.textView.contentSize.height / fontHeight!
            
            if line < 4 {
                UIView.animate(withDuration: 0.1, animations: {
                    self.inputContainerHeightConstraint?.constant = self.calculateHeight().container.height
                })
            }
            
        }).disposed(by: disposeBag)
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
        
        // MARK: configurable constraint
        inputContainerHeightConstraint = inputContainerNode.view.heightAnchor.constraint(equalToConstant: 35)
        inputContainerBottomConstraint = inputContainerNode.view.bottomAnchor.constraint(equalTo: self.node.view.safeAreaLayoutGuide.bottomAnchor)
        inputContainerUpperBottomConstraint = inputContainerNode.view.bottomAnchor.constraint(equalTo: self.node.view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            // MARK: tableNode constraint
            tableNode.view.topAnchor.constraint(equalTo: self.node.view.topAnchor),
            tableNode.view.leftAnchor.constraint(equalTo: self.node.view.leftAnchor),
            tableNode.view.rightAnchor.constraint(equalTo: self.node.view.rightAnchor),
            tableNode.view.bottomAnchor.constraint(equalTo: inputContainerNode.view.topAnchor),
            
            // MARK: inputContainer constaint
            inputContainerNode.view.leftAnchor.constraint(equalTo: self.node.view.leftAnchor),
            inputContainerNode.view.rightAnchor.constraint(equalTo: self.node.view.rightAnchor),
            inputContainerBottomConstraint!,
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

extension ChatViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.value.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = TextMessageCell(with: ChatCellViewModelImpl(message: viewModel.messages.value[indexPath.row]))
        
        return cell
    }
}

extension ChatViewController: ASTableDelegate {
    
}
