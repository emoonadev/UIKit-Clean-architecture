//
// Created by Mickael Belhassen on 20/05/2022.
//

import UIKit
import SnapKit

class AddCustomerView: UIView {
    var state: AddCustomerViewStateService?

    var nameTextField: UITextField = UITextField(frame: .zero)
    lazy var doneBtn: UIButton = UIButton(configuration: .plain(), primaryAction: .init { [weak self] _ in self?.doneAction() })
    lazy var dismissBtn: UIButton = UIButton(configuration: .plain(), primaryAction: .init { [weak self] _ in self?.cancelAction() })

    required init(state: AddCustomerViewStateService) {
        self.state = state
        super.init(frame: .zero)
        applyViewCode()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyViewCode()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyViewCode()
    }

    func doneAction() {
        state?.customerNameToCreate.value = nameTextField.text ?? ""
    }

    func cancelAction() {
        state?.cancelActionDidClick.notify()
    }
}

// MARK: Configure code

extension AddCustomerView: ViewCodeConfiguration {

    func buildHierarchy() {
        addSubview(nameTextField)
        addSubview(doneBtn)
        addSubview(dismissBtn)
    }

    func setupConstraints() {
        dismissBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(dismissBtn.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(-32)
        }

        doneBtn.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
    }

    func configureViews() {
        doneBtn.tintColor = .systemBlue
        doneBtn.setTitle("Create", for: .normal)

        dismissBtn.setTitle("Cancel", for: .normal)

        nameTextField.borderStyle = .roundedRect
    }

}
