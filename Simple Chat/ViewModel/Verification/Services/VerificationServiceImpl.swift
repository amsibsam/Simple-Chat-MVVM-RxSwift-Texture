//
//  VerificationServiceImpl.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa

class VerificationServiceImpl: VerificationService {
    
    func verifyLogin(with code: String) -> Single<User?> {
        return Single.create(subscribe: { (emitter) -> Disposable in
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.getVerificationId(), verificationCode: code)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
                print("result \(result?.additionalUserInfo?.providerID)")
                if let errorVerify = error {
                    emitter(.error(errorVerify))
                } else {
                    emitter(.success(result?.user))
                }
            }
            
            return Disposables.create()
        })
        
    }
}
