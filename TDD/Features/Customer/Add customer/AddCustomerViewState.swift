
//
//  AddCustomerViewState.swift
//  TDD
//
//  Created by Mickael Belhassen on 18/07/2022.
//

import Foundation

protocol AddCustomerViewStateService {
    var customerNameToCreate: Observable<String?> { get }
    var cancelActionDidClick: Observable<(() -> Void)?> { get }
}

struct AddCustomerViewState: AddCustomerViewStateService {
    let customerNameToCreate: Observable<String?> = .init(nil)
    let cancelActionDidClick: Observable<(() -> Void)?> = .init(nil)
}
