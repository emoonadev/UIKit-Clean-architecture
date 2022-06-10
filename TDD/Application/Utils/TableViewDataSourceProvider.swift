//
// Created by Mickael Belhassen on 14/03/2022.
//

import UIKit

protocol ObservableSearchBar {
    var textDidChange: Observable<String> { get }
    var text: String? { get set }
}

class TableViewDataSourceProvider<Item, Cell: UITableViewCell & NibLoadableView>: NSObject, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    typealias CellConfigurator = (_ indexPath: IndexPath, _ item: Item, _ cell: Cell) -> Void
    typealias HeightConfigurator = (_ indexPath: IndexPath, _ item: Item) -> CGFloat
    typealias ContextMenuConfigurator = (_ indexPath: IndexPath, _ item: Item) -> UIMenu
    typealias SwipeConfigurator = (_ rowAction: UIContextualAction, _ item: Item) -> Void
    typealias SimpleConfigurator = (_ items: [Item], _ filteredItems: [Item], _ indexPath: IndexPath, _ item: Item) -> Void

    private var items: [Item]
    private var observedItems = Observable([Item]())
    private let cell: Cell.Type
    private var isCellRegistered = false
    private let cellConfigurator: CellConfigurator
    private var heightConfigurator: HeightConfigurator?
    private var didSelectedItemAt: SimpleConfigurator?
    private var contextMenu: ContextMenuConfigurator?
    private var destructiveSwipe: (String, SwipeConfigurator)?
    private let isAutomaticDimension: Bool
    private var registeredSearchBar: (searchBar: ObservableSearchBar, keyPath: KeyPath<Item, String>)?
    private var registeredSearchController: (searchController: UISearchController, keyPath: KeyPath<Item, String>)?
    private var registeredTableView: UITableView?

    var filteredItems = [Item]()

    init(items: [Item], cell: Cell.Type, isAutomaticDimension: Bool = true, cellConfigurator: @escaping CellConfigurator) {
        self.items = items
        self.cell = cell
        self.isAutomaticDimension = isAutomaticDimension
        self.cellConfigurator = cellConfigurator
    }

    init(items: Observable<[Item]>, cell: Cell.Type, isAutomaticDimension: Bool = true, cellConfigurator: @escaping CellConfigurator) {
        self.items = items.value
        self.cell = cell
        self.isAutomaticDimension = isAutomaticDimension
        self.cellConfigurator = cellConfigurator
        observedItems = items
        super.init()
        setObserver()
    }

    private func setObserver() {
        observedItems.observe(on: self) { (self, items) in
            self.reloadData(with: items)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isCellRegistered {
            isCellRegistered = true
            tableView.register(Cell.self)
            registeredTableView = tableView
        }

        return isFiltering() ? filteredItems.count : items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = items[indexPath.row]
        let cell = loadNIB()

        return heightConfigurator?(indexPath, model) ?? (isAutomaticDimension ? UITableView.automaticDimension : cell.frame.height)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectedItemAt?(items, filteredItems, indexPath, items[indexPath.row])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = isFiltering() ? filteredItems[indexPath.row] : items[indexPath.row]
        let cell: Cell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        cellConfigurator(indexPath, model, cell)
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []

        if let destructive = destructiveSwipe {
            let destructive = UIContextualAction(style: .destructive, title: destructive.0) { action, _, _ in
                let model = self.isFiltering() ? self.filteredItems[indexPath.row] : self.items[indexPath.row]
                destructive.1(action, model)
            }

            actions.append(destructive)
        }

        return UISwipeActionsConfiguration(actions: actions)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let model = isFiltering() ? filteredItems[indexPath.row] : items[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            self.contextMenu?(indexPath, model)
        })
    }

    private func loadNIB() -> Cell {
        return Bundle(for: Cell.self as AnyClass).loadNibNamed(String(describing: Cell.self), owner: nil, options: nil)![0] as! Cell
    }

    public func updateSearchResults(for searchController: UISearchController) {
        guard let keyPath = registeredSearchController?.keyPath, let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterTableView(by: keyPath, and: searchText)
    }
}

// MARK: - Configurators

extension TableViewDataSourceProvider {
    func heightForRow(config: @escaping HeightConfigurator) -> Self {
        heightConfigurator = config
        return self
    }

    func didSelectedItemAt(config: @escaping SimpleConfigurator) -> Self {
        didSelectedItemAt = config
        return self
    }

    func contextMenu(config: @escaping ContextMenuConfigurator) -> Self {
        contextMenu = config
        return self
    }

    func destructiveSwipe(title: String, config: @escaping SwipeConfigurator) -> Self {
        destructiveSwipe = (title, config)
        return self
    }

    func reloadData(with items: [Item]) {
        self.items = items
        observedItems.setValue(items)
        registeredTableView?.reloadData()
    }

    private func filterTableView(by keyPath: KeyPath<Item, String>, and searchText: String) {
        filteredItems = items.filter { $0[keyPath: keyPath].lowercased().contains(searchText.lowercased()) }
        registeredTableView?.reloadData()
    }
}

// MARK: - Filter logic

extension TableViewDataSourceProvider {
    func registerSearchBar(_ searchBar: (searchBar: ObservableSearchBar, keyPath: KeyPath<Item, String>)) -> TableViewDataSourceProvider {
        registeredSearchBar = searchBar

        searchBar.searchBar.textDidChange.observe(on: self) { _, searchText in
            guard let keyPath = self.registeredSearchBar?.keyPath else { return }
            self.filterTableView(by: keyPath, and: searchText)
        }

        return self
    }

    func registerSearchController(_ searchController: (searchController: UISearchController, keyPath: KeyPath<Item, String>)) -> TableViewDataSourceProvider {
        registeredSearchController = searchController
        registeredSearchController?.searchController.searchResultsUpdater = self
        return self
    }

    func searchBarIsEmpty() -> Bool {
        registeredSearchBar?.searchBar.text?.isEmpty ?? registeredSearchController?.searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool { !searchBarIsEmpty() }
}

