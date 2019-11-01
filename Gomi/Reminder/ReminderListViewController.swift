import UIKit

private let reuseIdentifier = "Reminder"

final class ReminderListViewController: UITableViewController {
    
    private var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(
            title: NSLocalizedString("Reminder", comment: ""), image: UIImage(systemName: "alarm"), tag: 1)
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
        
        if userDefaults.reminders.isEmpty {
            let group: [Item.Group] = [.resource, .combustible, .incombustible, .containMercury, .usedPaper]
            userDefaults.reminders = group.map(Reminder.init(group:))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationHelper.registerSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleContentsUpdate), name: .reminderContentsDidUpdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .reminderContentsDidUpdate, object: nil)
    }
    
    @objc private func handleContentsUpdate() {
        tableView.reloadData()
    }
}

extension ReminderListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefaults.reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ReminderTableViewCell
        let reminder = userDefaults.reminders[indexPath.row]
        cell.configure(source: userDefaults, reminder: reminder)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = userDefaults.reminders[indexPath.row]
        let vc = EditReminderViewController(source: userDefaults, reminder: reminder)
        navigationController?.pushViewController(vc, animated: true)
    }
}
