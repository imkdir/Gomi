import UIKit

private let headerReuseIdentifier = "SearchHeader"

final class MainTableViewController: BaseTableViewController {
    
    /// NSPredicate expression keys.
    private enum ExpressionKeys: String {
        case name
    }
    
    // MARK: - Properties
    
    /// Data model for the table view.
    var items: [Item] = []
    
    /** The following 2 properties are set in viewDidLoad(),
     They are implicitly unwrapped optionals because they are used in many other places
     throughout this view controller.
     */
    
    /// Search controller to help us with filtering.
    private var searchController: UISearchController!
    
    /// Secondary search results table view.
    private var resultsTableController: ResultsTableController!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("ごみ", comment: "")
        
        resultsTableController = ResultsTableController()
        
        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        navigationItem.searchController = searchController
        
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // The default is true.
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        definesPresentationContext = true
        
        tableView.sectionHeaderHeight = 60
        tableView.separatorInset = .init(top: 0, left: 15, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
    }
    
    @objc
    private func clearSearch() {
        SearchHistory.clear()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Check to see which table view cell was selected.
        if tableView === self.tableView {
            let term = SearchHistory.read[indexPath.row]
            searchController.isActive = true
            searchController.searchBar.text = term
        } else {
            let selectedItem = resultsTableController.filteredItems[indexPath.row]
            // TODO: Set up the detail view controller to show.
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchHistory.read.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel!.text = SearchHistory.read[indexPath.row]
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView === self.tableView else { return nil }
        guard !SearchHistory.read.isEmpty else { return nil }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as! SearchHeaderView
        header.button.addTarget(self, action: #selector(clearSearch), for: [.touchUpInside])
        return header
    }
}

// MARK: - UISearchBarDelegate

extension MainTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text!.trimmingCharacters(in: .whitespaces)
        guard !searchTerm.isEmpty else { return }
        
        searchBar.resignFirstResponder()
        SearchHistory.log(term: searchTerm)
    }
    
}

// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension MainTableViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
        tableView.reloadData()
    }
    
}

// MARK: - UISearchResultsUpdating

extension MainTableViewController: UISearchResultsUpdating {
    
    private func findMatches(searchString: String) -> NSPredicate {
        let nameExpression = NSExpression(forKeyPath: ExpressionKeys.name.rawValue)
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        return NSComparisonPredicate(leftExpression: nameExpression,
                                  rightExpression: searchStringExpression,
                                  modifier: .direct,
                                  type: .contains,
                                  options: [.caseInsensitive, .diacriticInsensitive])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Update the filtered array based on the search text.
        let searchResults = Store.shared.items
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        
        let filteredResults = searchResults.filter { findMatches(searchString: strippedString).evaluate(with: $0) }
        
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            resultsController.filteredItems = filteredResults
            resultsController.tableView.reloadData()
        }
    }
    
}
