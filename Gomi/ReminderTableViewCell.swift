import UIKit

extension UINib {
    static let reminder = UINib(nibName: "ReminderTableViewCell", bundle: nil)
}

final class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var controlOn: UISwitch!
    
    func configure(for reminder: Reminder) {
        labelName.text = reminder.group.description
        controlOn.isOn = reminder.isOn
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
