import UIKit

private let weekdayIdentifier = "Weekday"
private let weekIdentifier = "WeekOfMonth"
private let hourIdentifier = "Hour"

final class EditReminderViewController: UITableViewController {
    
    private var reminder: Reminder
    private var source: UserDefaults
    
    init(source: UserDefaults, reminder: Reminder) {
        self.source = source
        self.reminder = reminder
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = reminder.group.description
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAndDismiss))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 47
        tableView.register(.weekday, forCellReuseIdentifier: weekdayIdentifier)
        tableView.register(.week, forCellReuseIdentifier: weekIdentifier)
        tableView.register(.hour, forCellReuseIdentifier: hourIdentifier)
        setEditing(true, animated: false)
    }
    
    @objc
    private func saveAndDismiss() {
        var reminders = source.reminders
        if let index = reminders.firstIndex(where: { $0.group == reminder.group }) {
            reminders[index].deactive()
            reminders[index] = reminder
            if reminder.isOn { reminders[index].activate() }
            source.reminders = reminders
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
        case .due:
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
                self.reminder.weekday[indexPath.row] = $0
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
        case .due:
            if let date = reminder.due {
                let cell = tableView.dequeueReusableCell(withIdentifier: hourIdentifier, for: indexPath) as! TimeTableViewCell
                cell.configure(for: date) { [unowned self] in
                    self.reminder.due = $0
                }
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = NSLocalizedString("Add Reminder", comment: "")
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
        case .due:
            return reminder.due == nil ? .insert : .delete
        default:
            return .delete
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var shouldReload: Bool = false
            switch Section.allCases[indexPath.section] {
            case .weekday:
                shouldReload = reminder.weekday.count == 7
                reminder.weekday.remove(at: indexPath.row)
            case .weekOfMonth:
                shouldReload = reminder.weekOfMonth.count == 5
                reminder.weekOfMonth.remove(at: indexPath.row)
            case .due:
                reminder.due = nil
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
                shouldReload = reminder.weekOfMonth.count == 5
            case .due:
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
        case weekday, weekOfMonth, due
        
        var description: String {
            switch self {
            case .weekday: return NSLocalizedString("Weekday", comment: "")
            case .weekOfMonth: return NSLocalizedString("Week of Month", comment: "")
            case .due: return NSLocalizedString("Reminder", comment: "")
            }
        }
    }
}
