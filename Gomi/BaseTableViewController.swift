import UIKit

class BaseTableViewController: UITableViewController {

    var filteredItems: [Item] = []
    
    static let cellReuseIdentifier = "Item"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 81
        tableView.register(.item, forCellReuseIdentifier: BaseTableViewController.cellReuseIdentifier)
    }

    func configureCell(_ cell: ItemTableViewCell, forItem item: Item) {
        cell.configure(for: item)
    }
}
