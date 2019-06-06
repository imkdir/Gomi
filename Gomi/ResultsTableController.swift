import UIKit

class ResultsTableController: BaseTableViewController {
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.cellReuseIdentifier, for: indexPath) as! ItemTableViewCell
        configureCell(cell, forItem: filteredItems[indexPath.row])
        return cell
    }
}
