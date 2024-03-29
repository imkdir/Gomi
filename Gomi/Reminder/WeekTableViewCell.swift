import UIKit

extension UINib {
    static let week = UINib(nibName: "WeekTableViewCell", bundle: nil)
}

final class WeekTableViewCell: UITableViewCell {
    @IBOutlet weak var controlWeekOfMonth: UISegmentedControl!
    
    private var onSelect: (Int) -> Void = {_ in }
    
    func configure(value index: Int, onSelect: @escaping (Int) -> Void) {
        self.onSelect = onSelect
        controlWeekOfMonth.selectedSegmentIndex = index - 1
    }
    
    @IBAction func selectedIndexChanged(_ sender: UISegmentedControl) {
        onSelect(sender.selectedSegmentIndex + 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        controlWeekOfMonth.setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: [.normal])
        controlWeekOfMonth.setTitleTextAttributes([.foregroundColor: UIColor.label], for: [.selected])
    }
}
