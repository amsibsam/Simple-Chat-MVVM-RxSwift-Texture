//
//  LoginViewController.swift
//  Simple Chat
//
//  Created by MTMAC16 on 13/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import RxCocoa
import RxSwift

class LoginViewController: ASViewController<ASDisplayNode> {
    // MARK: UI element
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let activituIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activituIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activituIndicator
    }()
    let tfPhoneNumber: ASEditableTextNode
    let lblError: ASTextNode
    let btnLogin: ASButtonNode
    
    // MARK: properties
    let viewModel: LoginViewModel
    let disposeBag: DisposeBag
    
    init() {
        tfPhoneNumber = ASEditableTextNode()
        btnLogin = ASButtonNode()
        lblError = ASTextNode()
        viewModel = LoginViewModelImpl(with: LoginService())
        disposeBag = DisposeBag()
        super.init(node: ASDisplayNode())
        
        //MARK: tfPhoneNumber config
        tfPhoneNumber.clipsToBounds = true
        tfPhoneNumber.backgroundColor = .white
        tfPhoneNumber.keyboardType = .phonePad
        tfPhoneNumber.typingAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        tfPhoneNumber.attributedPlaceholderText = NSAttributedString(string: "+62 Phone Number..", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        tfPhoneNumber.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 3, right: 10)
        
        //MARK: btnLogin config
        btnLogin.setTitle("Login", with: UIFont.systemFont(ofSize: 12), with: .blue, for: .normal)
        btnLogin.setTitle("Login", with: UIFont.systemFont(ofSize: 12), with: .white, for: .highlighted)
        btnLogin.setTitle("", with: nil, with: .white, for: .disabled)
        btnLogin.addTarget(self, action: #selector(LoginViewController.loginDidTap), forControlEvents: ASControlNodeEvent.touchUpInside)
        btnLogin.backgroundColor = .white
        btnLogin.clipsToBounds = true
        
        //MARK: lblError config
        lblError.attributedText = NSAttributedString(string: "", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), NSAttributedStringKey.paragraphStyle: NSTextAlignment.center])
    }
    
    //MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindModelToView()
    }
    
    //MARK: selector
    @objc func loginDidTap() {
        viewModel.login(with: tfPhoneNumber.textView.text!)
    }
    
    //MARK: private
    fileprivate func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        
        tfPhoneNumber.layer.cornerRadius = 8
        tfPhoneNumber.layer.borderWidth = 1
        tfPhoneNumber.layer.borderColor = UIColor.gray.cgColor
        
        btnLogin.layer.cornerRadius = 8
        btnLogin.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btnLogin.layer.borderWidth = 2
        
        setupGradientColor()
        self.node.addSubnode(tfPhoneNumber)
        self.node.addSubnode(btnLogin)
        self.node.addSubnode(lblError)
        self.node.view.addSubview(loadingIndicator)
        
        setupConstraint()
    }
    
    fileprivate func bindModelToView() {
        viewModel.isLoading.drive(onNext: { [unowned self] isLoading in
            isLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            self.btnLogin.isEnabled = !isLoading
        }).disposed(by: disposeBag)
        
        viewModel.errorMessage.drive(onNext: { [unowned self] error in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            self.lblError.attributedText = NSAttributedString(string: error, attributes: [NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), NSAttributedStringKey.paragraphStyle: paragraphStyle])
        }).disposed(by: disposeBag)
        
        viewModel.isSuccess.drive(onNext: { [unowned self] isSuccess in
            if isSuccess {
                self.navigationController?.pushViewController(VerificatoinViewController(), animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    fileprivate func setupGradientColor() {
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        layer.colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor, #colorLiteral(red: 0.09469399931, green: 0.9547344689, blue: 0.9686274529, alpha: 1).cgColor]
        self.view.layer.insertSublayer(layer, at: 0)
    }
    
    fileprivate func setupConstraint() {
        btnLogin.view.translatesAutoresizingMaskIntoConstraints = false
        tfPhoneNumber.view.translatesAutoresizingMaskIntoConstraints = false
        lblError.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //MARK: tfPhoneNumber constraint
            tfPhoneNumber.view.centerYAnchor.constraint(equalTo: self.node.view.centerYAnchor),
            tfPhoneNumber.view.centerXAnchor.constraint(equalTo: self.node.view.centerXAnchor),
            tfPhoneNumber.view.heightAnchor.constraint(equalToConstant: 35),
            tfPhoneNumber.view.widthAnchor.constraint(equalToConstant: 250),
            
            //MARK: btnLogin constraint
            btnLogin.view.centerXAnchor.constraint(equalTo: self.node.view.centerXAnchor),
            btnLogin.view.centerYAnchor.constraint(equalTo: self.node.view.centerYAnchor, constant: 50),
            btnLogin.view.heightAnchor.constraint(equalToConstant: 35),
            btnLogin.view.widthAnchor.constraint(equalTo: tfPhoneNumber.view.widthAnchor),
            
            //MARK: loadingIndicator constraint
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: btnLogin.view.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 30),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 30),
            
            //MARK: lblError constraint
            lblError.view.centerXAnchor.constraint(equalTo: self.node.view.centerXAnchor),
            lblError.view.centerYAnchor.constraint(equalTo: tfPhoneNumber.view.centerYAnchor, constant: -50),
            lblError.view.heightAnchor.constraint(equalToConstant: 30),
            lblError.view.leadingAnchor.constraint(equalTo: self.node.view.leadingAnchor, constant: 10),
            lblError.view.trailingAnchor.constraint(equalTo: self.node.view.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
