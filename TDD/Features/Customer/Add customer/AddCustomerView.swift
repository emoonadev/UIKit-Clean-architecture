//
// Created by Mickael Belhassen on 20/05/2022.
//

import UIKit
import SnapKit

protocol AddCustomerViewResponder: AnyObject {
    func doneActionDidClick(with name: String)
    func cancelActionDidClick()
}

class AddCustomerView: UIView {
    weak var delegate: AddCustomerViewResponder?

    var nameTextField: UITextField = UITextField(frame: .zero)
    lazy var doneBtn: UIButton = UIButton(configuration: .plain(), primaryAction: .init { [weak self] _ in self?.doneAction() })
    lazy var dismissBtn: UIButton = UIButton(configuration: .plain(), primaryAction: .init { [weak self] _ in self?.cancelAction() })

    required init(delegate: AddCustomerViewResponder) {
        self.delegate = delegate
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
        delegate?.doneActionDidClick(with: nameTextField.text ?? "")
    }

    func cancelAction() {
        delegate?.cancelActionDidClick()
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
