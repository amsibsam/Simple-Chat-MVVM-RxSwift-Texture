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
    let tableNode: ASTableNode
    let inputContainer: ASDisplayNode
    let viewModel: EditProfileViewModel
    let disposeBag: DisposeBag
    
    init() {
        disposeBag = DisposeBag()
        viewModel = EditProfileViewModelImpl()
        tableNode = ASTableNode(style: UITableViewStyle.plain)
        inputContainer = ASDisplayNode()
        super.init(node: ASDisplayNode())
        
        inputContainer.backgroundColor = .blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindModelToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: selector
    @objc func signOut() {
        viewModel.signOut()
    }
    
    // MARK: private func
    private func setupUI() {
        setupNavigation()
        self.title = "Edit Profile"
        self.node.backgroundColor = .white
        self.node.addSubnode(tableNode)
        self.node.addSubnode(inputContainer)
        setupConstraint()
        configureTableView()
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(EditProfileViewController.signOut))
    }
    
    private func bindModelToView() {
        viewModel.getMenu()
        viewModel.menu.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                print("MODEL:::\(model)")
                self?.tableNode.reloadData()
            }).disposed(by: disposeBag)
        viewModel.isSuccess.drive(onNext: { (user) in
            if let updatedUser = user {
                UIApplication.app?.setupAfterLoginWindow(user: updatedUser)
            } else {
                print("error complete profile ")
            }
        }).disposed(by: disposeBag)
        viewModel.isLoggedOut.drive(onNext: { (success) in
            if success {
                UIApplication.app?.setupPreloginWindow()
            }
        }).disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.separatorStyle = .none
        tableNode.view.tableFooterView = UIView()
    }
    
    private func setupConstraint() {
        tableNode.view.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // MARK: tableView constraint
            tableNode.view.leadingAnchor.constraint(equalTo: self.node.view.leadingAnchor),
            tableNode.view.trailingAnchor.constraint(equalTo: self.node.view.trailingAnchor),
            tableNode.view.topAnchor.constraint(equalTo: self.node.view.topAnchor),
            tableNode.view.bottomAnchor.constraint(equalTo: self.node.view.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension EditProfileViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menu.value.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        if indexPath.row == viewModel.menu.value.count - 1 {
            let cell = SaveCell()
            viewModel.isLoading.drive(cell.loadingIndicator.rx.isAnimating).disposed(by: disposeBag)
            cell.tap.skip(1).drive(onNext: { [unowned self] (_) in
                self.viewModel.update()
            }).disposed(by: disposeBag)
            return cell
        } else {
            return ProfileFieldCell(with: viewModel.menu.value[indexPath.row])
        }
        
    }
}

extension EditProfileViewController: ASTableDelegate {
    
}
