//
//  VerificationServiceImpl.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import FirebaseAuth

class VerificationServiceImpl: VerificationService {
    
    func verifyLogin(with code: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.getVerificationId(), verificationCode: code)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            print("result \(result?.additionalUserInfo?.providerID)")
        }
    }
}
