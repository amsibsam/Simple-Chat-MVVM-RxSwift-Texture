//
//  SaveCell.swift
//  Simple Chat
//
//  Created by MTMAC16 on 17/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxCocoa
import RxSwift

class SaveCell: ASCellNode {
    let btnSave: ASButtonNode
    let loadingIndicator: UIActivityIndicatorView
    var tap: Driver<()> {
        get {
            return behaviorTap.asDriver()
        }
    }
    private let behaviorTap: BehaviorRelay<()> = BehaviorRelay(value: ())
    
    override init() {
        btnSave = ASButtonNode()
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        super.init()
        self.automaticallyManagesSubnodes = true
        btnSave.setTitle("Save", with: UIFont.boldSystemFont(ofSize: 14), with: .white, for: .normal)
        btnSave.setTitle("Save", with: UIFont.boldSystemFont(ofSize: 12), with: .gray, for: .highlighted)
        btnSave.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btnSave.clipsToBounds = true
        btnSave.addTarget(self, action: #selector(SaveCell.saveDidTap), forControlEvents: .touchUpInside)
    }
    
    override func didLoad() {
        btnSave.layer.cornerRadius = 8
        loadingIndicator.frame.origin = CGPoint(x: btnSave.view.frame.origin.x, y: btnSave.view.frame.origin.y)
        btnSave.view.addSubview(loadingIndicator)
        configureConstrain()
        
    }
    
    fileprivate func configureConstrain() {
        NSLayoutConstraint.activate([
            //MARK: loadingIndicator constraint
            loadingIndicator.centerYAnchor.constraint(equalTo: btnSave.view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: btnSave.view.centerXAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 30),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalLayout = ASStackLayoutSpec.vertical()
        verticalLayout.alignItems = .start
        verticalLayout.spacing = 8
        btnSave.style.height = ASDimensionMake(40)
        btnSave.style.width = ASDimensionMake("100%")
        verticalLayout.children = [btnSave]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 30, bottom: 8, right: 30), child: verticalLayout)
    }
    
    //MARK: selector
    @objc func saveDidTap() {
        behaviorTap.accept(())
    }
}
