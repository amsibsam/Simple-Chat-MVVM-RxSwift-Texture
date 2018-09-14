//
//  DataCache.swift
//  Simple Chat
//
//  Created by MTMAC16 on 13/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation

extension UserDefaults {
    func saveVerificationId(_ id: String) {
        self.set(id, forKey: "verification_id")
    }
    
    func getVerificationId() -> String {
        return self.string(forKey: "verification_id") ?? ""
    }
}
