//
//  LoginService.swift
//  Simple Chat
//
//  Created by MTMAC16 on 13/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift

enum LoginError: Error {
    case failedToGetId
}

class LoginService {
    
    func login(with phoneNumber: String) -> Single<Bool> {
        return Single.create(subscribe: { (emitter) -> Disposable in
            FirebaseSharedServices.shared.login(with: phoneNumber, completion: { (isSuccess) in
                if isSuccess {
                    emitter(.success(true))
                } else {
                    emitter(.error(LoginError.failedToGetId))
                }
            })
            return Disposables.create()
        })
        
    }
}
