//
//  AppDelegate+Instance.swift
//  Simple Chat
//
//  Created by MTMAC16 on 17/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static var app: AppDelegate? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate
    }
}
