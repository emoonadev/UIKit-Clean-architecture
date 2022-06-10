//
// Created by Mickael Belhassen on 24/03/2022.
//

import UIKit

class CustomerProfileViewController: UIViewController {

    @Resolve var viewModel: CustomerProfileViewModel


    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Setup

extension CustomerProfileViewController {

    func setup() {
        setUI()
    }

    func setUI() {
        navigationController?.title = viewModel.customer?.name()
    }

}
