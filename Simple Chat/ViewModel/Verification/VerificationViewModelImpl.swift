//
//  VerificationViewModelImpl.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class VerificationViewModelImpl: VerificationViewModel {
    var isLoading: Driver<Bool> {
        get {
            return varLoading.asDriver()
        }
    }
    var errorMessage: Driver<String> {
        get {
            return varErrorMessage.asDriver()
        }
    }
    var isSuccess: Driver<Bool> {
        get {
            return varSuccess.asDriver()
        }
    }
    
    //MARK: private properties
    fileprivate let varLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    fileprivate let varErrorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    fileprivate let varSuccess: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    //MARK: public func
    func verify(with code: String) {
        
    }
}
