//
//  LoginViewModelProtocol.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModel: class {
    // MARK: binding variable
    
    /// login loading status binding
    var isLoading: Driver<Bool> { get }
    
    /// login error message binding
    var errorMessage: Driver<String> { get }
    
    /// login success status binding
    var isSuccess: Driver<Bool> { get }
    
    // MARK: public function
    
    /// login with phone number
    ///
    /// - Parameter phoneNumber: user's phone number
    func login(with phoneNumber: String)
}
