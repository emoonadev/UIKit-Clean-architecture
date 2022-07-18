//
// Created by Mickael Belhassen on 21/05/2022.
//

import UIKit

class CustomerListView: UIView {

    weak var viewState: CustomerListViewState?

    var tableView: UITableView = .init(frame: .zero)
    lazy var addCustomerBtn: UIBarButtonItem = .init(systemItem: .add, primaryAction: .init { [weak self] _ in self?.viewState?.$addBtnDidClick.notify() })
    var tableViewDatasource: (UITableViewDelegate & UITableViewDataSource)?

    required init(viewState: CustomerListViewState) {
        self.viewState = viewState
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

}

// MARK: - Building view

extension CustomerListView: ViewCodeConfiguration {

    func buildHierarchy() {
        addSubview(tableView)
    }

    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func configureViews() {
        setTableView()
    }

    func setTableView() {
        guard let viewState = viewState else { return }
        tableViewDatasource = TableViewDataSourceProvider(items: viewState.customers, cell: CustomerTableViewCell.self) { _, item, cell in
            cell.customer = item
        }
        .didSelectedItemAt { _, _, _, customer in
            self.viewState?.lastSelectedCustomer = customer
        }

        tableView.dataSource = tableViewDatasource
        tableView.delegate = tableViewDatasource
    }
}
