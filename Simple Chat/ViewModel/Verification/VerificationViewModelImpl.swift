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
    var isSuccess: Driver<UserModel?> {
        get {
            return varSuccess.asDriver()
        }
    }
    
    // MARK: private properties
    private let varLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let varErrorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let varSuccess: BehaviorRelay<UserModel?> = BehaviorRelay(value: nil)
    private let service: VerificationService
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(with service: VerificationService) {
        self.service = service
    }
    
    // MARK: public func
    func verify(with code: String) {
        varLoading.accept(true)
        service.verifyLogin(with: code)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (user) in
                self?.varLoading.accept(false)
                self?.varSuccess.accept(user)
                }, onError: { [weak self] (error) in
                    self?.varLoading.accept(false)
                    self?.varErrorMessage.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
