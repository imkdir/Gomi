import UIKit

extension UINib {
    static let week = UINib(nibName: "WeekTableViewCell", bundle: nil)
}

final class WeekTableViewCell: UITableViewCell {
    @IBOutlet weak var controlWeekOfMonth: UISegmentedControl!
    
    private var onSelect: (Int) -> Void = {_ in }
    
    func configure(value index: Int, onSelect: @escaping (Int) -> Void) {
        self.onSelect = onSelect
        controlWeekOfMonth.selectedSegmentIndex = index
    }
    
    @IBAction func selectedIndexChanged(_ sender: UISegmentedControl) {
        onSelect(sender.selectedSegmentIndex)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        controlWeekOfMonth.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: [.normal])
        controlWeekOfMonth.setTitleTextAttributes([.foregroundColor: UIColor.black], for: [.selected])
    }
}
