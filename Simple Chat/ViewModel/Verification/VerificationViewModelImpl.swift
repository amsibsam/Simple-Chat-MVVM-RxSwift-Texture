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
import Firebase

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
    var isSuccess: Driver<User?> {
        get {
            return varSuccess.asDriver()
        }
    }
    
    //MARK: private properties
    fileprivate let varLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    fileprivate let varErrorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    fileprivate let varSuccess: BehaviorRelay<User?> = BehaviorRelay(value: nil)
    fileprivate let service: VerificationService
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    init(with service: VerificationService) {
        self.service = service
    }
    
    //MARK: public func
    func verify(with code: String) {
        varLoading.accept(true)
        service.verifyLogin(with: code)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (user) in
                self?.varLoading.accept(false)
                self?.varSuccess.accept(user)
            }) { [weak self] (error) in
                self?.varLoading.accept(false)
                self?.varErrorMessage.accept(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}
