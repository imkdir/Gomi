import UIKit

private let weekdayIdentifier = "Weekday"
private let weekIdentifier = "WeekOfMonth"
private let hourIdentifier = "Hour"

final class EditReminderViewController: UITableViewController {
    
    private var reminder: Reminder
    
    init(reminder: Reminder) {
        self.reminder = reminder
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Edit", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAndDismiss))
        
        tableView.register(.weekday, forCellReuseIdentifier: weekdayIdentifier)
        tableView.register(.week, forCellReuseIdentifier: weekIdentifier)
        tableView.register(.hour, forCellReuseIdentifier: hourIdentifier)
        setEditing(true, animated: false)
    }
    
    @objc
    private func saveAndDismiss() {
        var reminders = UserDefaults.standard.reminders
        if let index = reminders.firstIndex(where: { $0.group == reminder.group }) {
            reminders[index] = reminder
            UserDefaults.standard.reminders = reminders
        }
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allCases[section] {
        case .weekday:
            let count = reminder.weekday.count
            return count < 7 ? count + 1 : count
        case .weekOfMonth:
            let count = reminder.weekOfMonth.count
            return count < 4 ? count + 1 : count
        case .time:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section.allCases[indexPath.section] {
        case .weekday where indexPath.row == reminder.weekday.count:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = NSLocalizedString("Add Weekday", comment: "")
            return cell
        case .weekday:
            let cell = tableView.dequeueReusableCell(withIdentifier: weekdayIdentifier, for: indexPath) as! WeekdayTableViewCell
            cell.configure(value: reminder.weekday[indexPath.row]) { [unowned self] in
                self.reminder.weekday[indexPath.row] = $0 + 1
            }
            return cell
        case .weekOfMonth where indexPath.row == reminder.weekOfMonth.count:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = NSLocalizedString("Add Week of Month", comment: "")
            return cell
        case .weekOfMonth:
            let cell = tableView.dequeueReusableCell(withIdentifier: weekIdentifier, for: indexPath) as! WeekTableViewCell
            cell.configure(value: reminder.weekOfMonth[indexPath.row]) { [unowned self] in
                self.reminder.weekOfMonth[indexPath.row] = $0
            }
            return cell
        case .time:
            if let hour = reminder.hour {
                let cell = tableView.dequeueReusableCell(withIdentifier: hourIdentifier, for: indexPath) as! HourTableViewCell
                cell.configure(for: hour) { [unowned self] in
                    self.reminder.hour = $0 == 0 ? hour : hour + 12
                }
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = NSLocalizedString("Set Hour", comment: "")
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].description
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch Section.allCases[indexPath.section] {
        case .weekday where indexPath.row == reminder.weekday.count:
            return .insert
        case .weekOfMonth where indexPath.row == reminder.weekOfMonth.count:
            return .insert
        case .time:
            return reminder.hour == nil ? .insert : .delete
        default:
            return .delete
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var shouldReload: Bool = false
            switch Section.allCases[indexPath.section] {
            case .weekday:
                reminder.weekday.remove(at: indexPath.row)
            case .weekOfMonth:
                reminder.weekOfMonth.remove(at: indexPath.row)
            case .time:
                reminder.hour = nil
                shouldReload = true
            }
            if shouldReload {
                tableView.reloadRows(at: [indexPath], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            var shouldReload: Bool = false
            switch Section.allCases[indexPath.section] {
            case .weekday:
                reminder.weekday.append(0)
                shouldReload = reminder.weekday.count == 7
            case .weekOfMonth:
                reminder.weekOfMonth.append(-1)
                shouldReload = reminder.weekOfMonth.count == 4
            case .time:
                reminder.hour = 8
                shouldReload = true
            }
            if shouldReload {
                tableView.reloadRows(at: [indexPath], with: .fade)
            } else {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        }
    }

    enum Section: Int, CaseIterable, CustomStringConvertible {
        case weekday, weekOfMonth, time
        
        var description: String {
            switch self {
            case .weekday: return NSLocalizedString("Weekday", comment: "")
            case .weekOfMonth: return NSLocalizedString("Week of Month", comment: "")
            case .time: return NSLocalizedString("Hour", comment: "")
            }
        }
    }
}
