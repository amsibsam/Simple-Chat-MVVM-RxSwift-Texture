//
//  File.swift
//  Simple Chat
//
//  Created by MTMAC16 on 19/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func dismissKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
