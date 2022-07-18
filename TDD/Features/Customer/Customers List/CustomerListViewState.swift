//
// Created by Mickael Belhassen on 21/05/2022.
//

import Foundation

class CustomerListViewState {
    let customers: Observable<[Customer]> = Observable([])
    @Observable(nil) var addBtnDidClick: (() -> ())?
    @Observable(nil) var lastSelectedCustomer: Customer?
    
}
