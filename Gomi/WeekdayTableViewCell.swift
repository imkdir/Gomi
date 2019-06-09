import UIKit

extension UINib {
    static let weekday = UINib(nibName: "WeekdayTableViewCell", bundle: nil)
}

final class WeekdayTableViewCell: UITableViewCell {
    @IBOutlet weak var controlWeekday: UISegmentedControl!
    
    private var onSelect: (Int) -> Void = {_ in }
    
    func configure(value: Int, onSelect: @escaping (Int) -> Void) {
        self.onSelect = onSelect
        controlWeekday.selectedSegmentIndex = value - 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        controlWeekday.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: [.normal])
        controlWeekday.setTitleTextAttributes([.foregroundColor: UIColor.black], for: [.selected])
    }
    
    @IBAction func selecedIndexChanged(_ sender: UISegmentedControl) {
        onSelect(sender.selectedSegmentIndex + 1)
    }
}
