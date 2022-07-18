//
//  ViewController.swift
//  TDD
//
//  Created by Mickael Belhassen on 14/03/2022.
//

import UIKit

class CustomersListViewController: UIViewController {

    lazy var rootView = CustomerListView(viewState: viewModel.viewState)
    @Resolve var viewModel: CustomersListViewModel

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func loadView() {
        super.loadView()
        view = rootView
        navigationItem.rightBarButtonItem = rootView.addCustomerBtn
    }

}

// MARK: - Setup

private extension CustomersListViewController {

    func setup() {
        handleNavigation(viewModel.router())
        viewModel.initVC()
    }

}
