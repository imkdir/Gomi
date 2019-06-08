import UIKit

extension UINib {
    static let hour = UINib(nibName: "HourTableViewCell", bundle: nil)
}

final class HourTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var controlTime: UISegmentedControl!
    
    var onSelect: (Int) -> Void = {_ in }
    
    func configure(for hour: Int, onSelect: @escaping (Int) -> Void) {
        self.onSelect = onSelect
        labelTime.text = String(format:"%02d:00", hour % 24)
        controlTime.selectedSegmentIndex = hour > 11 ? 1 : 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func selectedIndexChanged(_ sender: UISegmentedControl) {
        onSelect(sender.selectedSegmentIndex)
    }
}
