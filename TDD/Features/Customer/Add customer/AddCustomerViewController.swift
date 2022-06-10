//
// Created by Mickael Belhassen on 14/03/2022.
//

import UIKit

class AddCustomerViewController: UIViewController {

    lazy var routView = AddCustomerView(delegate: self)
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

// MARK: - View delegate methods

extension AddCustomerViewController: AddCustomerViewResponder {

    func doneActionDidClick(with name: String) {
        viewModel.createCustomer(with: name)
    }

    func cancelActionDidClick() {
        dismiss(animated: true)
    }

}