//
//  VerificationViewController.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AsyncDisplayKit

class VerificatoinViewController: ASViewController<ASDisplayNode> {
    //MARK: View component
    let tfCode: ASEditableTextNode
    let btnVerify: ASButtonNode
    let lblTitle: ASTextNode
    
    //MARK: properties
    let disposeBag: DisposeBag
    
    fileprivate let viewModel: VerificationViewModel
    
    init() {
        viewModel = VerificationViewModelImpl(with: VerificationServiceImpl())
        disposeBag = DisposeBag()
        tfCode = ASEditableTextNode()
        btnVerify = ASButtonNode()
        lblTitle = ASTextNode()
        super.init(node: ASDisplayNode())
        
        //MARK: tfCode initial config
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        tfCode.attributedPlaceholderText = NSAttributedString(string: "Verification Code", attributes: [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), NSAttributedStringKey.paragraphStyle: paragraphStyle])
        tfCode.typingAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white, NSAttributedStringKey.paragraphStyle.rawValue: paragraphStyle]
        tfCode.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 3, right: 10)
        tfCode.clipsToBounds = true
        tfCode.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        //MARK: btnVerify initial config
        btnVerify.setTitle("Verify", with: UIFont.systemFont(ofSize: 14), with: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .disabled)
        btnVerify.setTitle("Verify", with: UIFont.systemFont(ofSize: 14), with: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btnVerify.setTitle("Verify", with: UIFont.systemFont(ofSize: 14), with: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), for: .highlighted)
        btnVerify.isUserInteractionEnabled = true
        btnVerify.isEnabled = false
        btnVerify.addTarget(self, action: #selector(VerificatoinViewController.verifyDidTap), forControlEvents: .touchUpInside)
        
        //MARK: lblTitle initial config
        lblTitle.attributedText = NSAttributedString(string: "Please enter verification code that has been sent to your phone number", attributes: [
            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)
            ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindModelToView()
        
    }
    
    //MARK: selector
    @objc func verifyDidTap() {
        print("verify did tap")
        viewModel.verify(with: tfCode.textView.text!)
    }
    
    //MARK: private func
    
    fileprivate func setupUI() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.node.backgroundColor = .white
        self.node.addSubnode(tfCode)
        self.node.addSubnode(lblTitle)
        self.node.addSubnode(btnVerify)
        
        
        tfCode.layer.cornerRadius = 8
        
        btnVerify.layer.cornerRadius = 8
        btnVerify.layer.borderWidth = 2
        btnVerify.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).cgColor
        
        
        setupConstraint()
    }
    
    fileprivate func bindModelToView() {
        tfCode.textView.rx.text.orEmpty.map { $0.count > 3 }.bind { [unowned self] (isValid) in
            UIView.animate(withDuration: 0.3, animations: {
                self.btnVerify.backgroundColor = isValid ? #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.btnVerify.isEnabled = isValid
            })
        }.disposed(by: disposeBag)
    }
    
    fileprivate func setupConstraint() {
        tfCode.view.translatesAutoresizingMaskIntoConstraints = false
        btnVerify.view.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //MARK: tfCode constraint
            tfCode.view.centerXAnchor.constraint(equalTo: self.node.view.centerXAnchor),
            tfCode.view.centerYAnchor.constraint(equalTo: self.node.view.centerYAnchor),
            tfCode.view.widthAnchor.constraint(equalToConstant: 250),
            tfCode.view.heightAnchor.constraint(equalToConstant: 35),
            
            //MARK: btnVerify constraint
            btnVerify.view.centerXAnchor.constraint(equalTo: self.node.view.centerXAnchor),
            btnVerify.view.centerYAnchor.constraint(equalTo: self.node.view.centerYAnchor, constant: 50),
            btnVerify.view.widthAnchor.constraint(equalTo: tfCode.view.widthAnchor),
            btnVerify.view.heightAnchor.constraint(equalTo: tfCode.view.heightAnchor),
            
            //MARK: lblTitle constraint
            lblTitle.view.centerXAnchor.constraint(equalTo: self.node.view.centerXAnchor),
            lblTitle.view.centerYAnchor.constraint(equalTo: self.node.view.centerYAnchor, constant: -100),
            lblTitle.view.widthAnchor.constraint(equalTo: self.tfCode.view.widthAnchor),
            lblTitle.view.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
