//
//  LoginViewModel.swift
//  Simple Chat
//
//  Created by MTMAC16 on 13/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModelImpl: LoginViewModel {
    
    // MARK: dependency
    let service: LoginService
    
    // MARK: public properties
    var isLoading: Driver<Bool> {
        get {
            return varLoading.asDriver()
        }
    }
    
    var errorMessage: Driver<String> {
        get {
            return varError.asDriver()
        }
    }
    
    var isSuccess: Driver<Bool> {
        get {
            return varSuccess.asDriver()
        }
    }
    
    // MARK: private properties
    private let varLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let varError: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let varSuccess: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    init(with service: LoginService) {
        self.service = service
    }
    
    // MARK: public func
    func login(with phoneNumber: String) {
        varLoading.accept(true)
        service
            .login(with: phoneNumber)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (success) in
                self.varLoading.accept(false)
                if success {
                    self.varSuccess.accept(true)
                }
            }, onError: { (error) in
                self.varLoading.accept(false)
                self.varError.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
