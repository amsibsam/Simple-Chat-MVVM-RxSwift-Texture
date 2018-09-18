//
//  ProfileFieldCell.swift
//  Simple Chat
//
//  Created by MTMAC16 on 17/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class ProfileFieldCell: ASCellNode {
    public static let identifier: String = "ProfileFieldCell"
    let lblFieldTitle: ASTextNode
    let tfFieldValue: ASEditableTextNode
    let disposeBag: DisposeBag
    
    var menu: MenuModel
    init(with menu: MenuModel) {
        self.menu = menu
        lblFieldTitle = ASTextNode()
        tfFieldValue = ASEditableTextNode()
        disposeBag = DisposeBag()
        
        super.init()
        self.automaticallyManagesSubnodes = true
        self.lblFieldTitle.attributedText = NSAttributedString(string: self.menu.title, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)])
        self.tfFieldValue.attributedText = NSAttributedString(string: self.menu.value, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
        self.tfFieldValue.textContainerInset = UIEdgeInsets(top: 6, left: 8, bottom: 8, right: 6)
    }
    
    override func didLoad() {
        super.didLoad()
        tfFieldValue.layer.borderColor = UIColor.gray.cgColor
        tfFieldValue.layer.borderWidth = 2
        tfFieldValue.layer.cornerRadius = 8
        
        tfFieldValue.textView.rx.text.orEmpty.bind { [weak self] (text) in
            self?.menu.value = text
        }.disposed(by: disposeBag)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackSpec = ASStackLayoutSpec.vertical()
        verticalStackSpec.alignItems = .start
        verticalStackSpec.spacing = 8
        lblFieldTitle.style.flexGrow = 1.0
        tfFieldValue.style.width = ASDimensionMake("100%")
        verticalStackSpec.children = [lblFieldTitle, tfFieldValue]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30), child: verticalStackSpec)
    }
}
