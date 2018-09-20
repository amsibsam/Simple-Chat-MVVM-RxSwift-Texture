//
//  EditProfileViewModel.swift
//  Simple Chat
//
//  Created by MTMAC16 on 14/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditProfileViewModel: class {
    var menu: BehaviorRelay<[MenuModel]> { get }
    var isLoading: Driver<Bool> { get }
    var isSuccess: Driver<UserModel?> { get }
    
    func getMenu()
    func update()
}
