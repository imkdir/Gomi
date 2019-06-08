import UIKit

private let reuseIdentifier = "Reminder"

final class ReminderListViewController: UITableViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Reminder", comment: "")
        tableView.rowHeight = 80
        tableView.register(.reminder, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        
        if UserDefaults.standard.reminders.isEmpty {
            let group: [Item.Group] = [.resource, .combustible, .incombustible, .containMercury, .usedPaper]
            UserDefaults.standard.reminders = group.map(Reminder.init(group:))
        }
    }
}

extension ReminderListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.standard.reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ReminderTableViewCell
        let reminder = UserDefaults.standard.reminders[indexPath.row]
        cell.configure(for: reminder)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = UserDefaults.standard.reminders[indexPath.row]
        let vc = EditReminderViewController(reminder: reminder)
        navigationController?.pushViewController(vc, animated: true)
    }
}