//
//  BaseViewModel.swift
//  iOSBaseSource
//

import RxSwift
import RxCocoa

class BaseViewModel: ViewModel {
    internal var apiError = PublishSubject<Error>()
    
    override init() {
        super.init()
    }
}
