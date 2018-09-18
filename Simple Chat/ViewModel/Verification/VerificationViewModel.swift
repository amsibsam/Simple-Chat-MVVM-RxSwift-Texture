//
//  VerificationViewModel.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxCocoa
import Firebase

protocol VerificationViewModel: class {
    // MARK: binding variable
    
    /// verification loading status binding
    var isLoading: Driver<Bool> { get }
    
    /// verification error message binding
    var errorMessage: Driver<String> { get }
    
    /// verification success status binding
    var isSuccess: Driver<User?> { get }
    
    // MARK: public function
    
    /// verify login with code
    ///
    /// - Parameter code: code that has been sent to user's phone number
    func verify(with code: String)
    
}
