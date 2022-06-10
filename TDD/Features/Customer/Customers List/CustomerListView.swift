//
// Created by Mickael Belhassen on 21/05/2022.
//

import UIKit

protocol CustomerListViewResponsder: AnyObject {
    func addDidClick()
    func customerDidClick(_ customer: Customer)
}

class CustomerListView: UIView {

    weak var delegate: CustomerListViewResponsder?
    weak var viewState: CustomerListViewState?

    var tableView: UITableView = UITableView(frame: .zero)
    lazy var addCustomerBtn: UIBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: .init { [weak self] _ in self?.delegate?.addDidClick() })
    var tableViewDatasource: (UITableViewDelegate & UITableViewDataSource)?

    required init(delegate: CustomerListViewResponsder, viewState: CustomerListViewState) {
        self.delegate = delegate
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
                    self.delegate?.customerDidClick(customer)
                }

        tableView.dataSource = tableViewDatasource
        tableView.delegate = tableViewDatasource
    }
}