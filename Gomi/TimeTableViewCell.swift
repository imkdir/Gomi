import UIKit

extension UINib {
    static let hour = UINib(nibName: "TimeTableViewCell", bundle: nil)
}

final class TimeTableViewCell: UITableViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var onSelect: (Date) -> Void = {_ in }
    
    func configure(for date: Date, onSelect: @escaping (Date) -> Void) {
        self.onSelect = onSelect
        datePicker.date = date
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        onSelect(sender.date)
    }
}
