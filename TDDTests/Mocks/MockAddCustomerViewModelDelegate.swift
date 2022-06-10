//
// Created by Mickael Belhassen on 16/03/2022.
//

import Foundation

class MockAddCustomerViewModelDelegate {
    var isErrorCalled = false

    func didError(_ error: Error) {
        isErrorCalled = true
    }

}
