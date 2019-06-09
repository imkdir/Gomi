import UIKit

extension UINib {
    static let reminder = UINib(nibName: "ReminderTableViewCell", bundle: nil)
}

final class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSummary: UILabel!
    @IBOutlet weak var controlOn: UISwitch!
    
    private var reminder: Reminder!
    
    func configure(for reminder: Reminder) {
        self.reminder = reminder
        labelName.text = reminder.group.description
        labelSummary.text = reminder.summary
        controlOn.isOn = reminder.isOn
    }
    
    @IBAction func userToggledReminderIsOn(_ sender: UISwitch) {
        reminder.isOn = sender.isOn
        var reminders = UserDefaults.standard.reminders
        if let index = reminders.firstIndex(where: { $0.group == reminder.group }) {
            reminders[index].deactive()
            reminders[index] = reminder
            if sender.isOn { reminders[index].activate() }
            UserDefaults.standard.reminders = reminders
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension Reminder {
    fileprivate var summary: String {
        let separator = NSLocalizedString(" & ", comment: "")
        print(weekdaySymbols)
        let weekdays = weekday.sorted().map({ weekdaySymbols[$0 - 1] }).joined(separator: separator)
        if weekOfMonth.isEmpty {
            return weekdays
        } else {
            let weeks = weekOfMonth.sorted().map({ weekOfMonths[$0 - 1] }).joined(separator: separator)
            return weeks.appending(" \(weekdays)")
        }
    }
}

private var weekdaySymbols: [String] {
    return DateFormatter().shortWeekdaySymbols
}
private var weekOfMonths: [String] {
    return [
        NSLocalizedString("1st", comment: ""),
        NSLocalizedString("2nd", comment: ""),
        NSLocalizedString("3rd", comment: ""),
        NSLocalizedString("4th", comment: ""),
        NSLocalizedString("5th", comment: "")
    ]
}
