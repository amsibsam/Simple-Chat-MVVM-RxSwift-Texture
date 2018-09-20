//
//  VerificationService.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift

protocol VerificationService: class {
    func verifyLogin(with code: String) -> Single<UserModel?>
}
