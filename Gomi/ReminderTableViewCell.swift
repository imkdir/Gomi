import UIKit

extension UINib {
    static let reminder = UINib(nibName: "ReminderTableViewCell", bundle: nil)
}

final class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var controlOn: UISwitch!
    
    private var reminder: Reminder!
    
    func configure(for reminder: Reminder) {
        self.reminder = reminder
        labelName.text = reminder.group.description
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
