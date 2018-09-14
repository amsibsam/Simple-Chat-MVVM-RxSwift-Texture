//
//  LoginService.swift
//  Simple Chat
//
//  Created by MTMAC16 on 13/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

enum LoginError: Error {
    case failedToGetId
}

class LoginService {
    
    func login(with phoneNumber: String) -> Single<Bool> {
        return Single.create(subscribe: { (emitter) -> Disposable in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
                if let id = verificationId {
                    UserDefaults.standard.saveVerificationId(id)
                    emitter(.success(true))
                } else if let err = error {
                    emitter(.error(err))
                }
            }
            
            return Disposables.create()
        })
        
    }
}
