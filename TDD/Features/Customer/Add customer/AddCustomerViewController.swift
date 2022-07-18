//
// Created by Mickael Belhassen on 14/03/2022.
//

import UIKit

class AddCustomerViewController: UIViewController {

    lazy var routView = AddCustomerView(state: viewModel.viewState)
    @Resolve var viewModel: AddCustomerViewModel

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func loadView() {
        super.loadView()
        view = routView
    }

}

// MARK: - Setup

extension AddCustomerViewController {

    func setup() {
        view.backgroundColor = .white
        handleNavigation(viewModel.router())
        viewModel.$error.observe(on: self) { (self, error) in self.showAlert(error: error) }
    }

}
