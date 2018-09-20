//
//  VerificationServiceImpl.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class VerificationServiceImpl: VerificationService {
    
    func verifyLogin(with code: String) -> Single<UserModel?> {
        return Single.create(subscribe: { (emitter) -> Disposable in
            FirebaseSharedServices.shared.verify(with: code, completion: { (user, error) in
                if let loggedInUser = user {
                    emitter(.success(loggedInUser))
                } else if let errorVerify = error {
                    emitter(.error(errorVerify))
                }
            })
            return Disposables.create()
        })
        
    }
}
