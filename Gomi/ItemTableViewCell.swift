import UIKit

extension UINib {
    static let item = UINib(nibName: "ItemTableViewCell", bundle: nil)
}

final class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelGroup: UILabel!
    
    func configure(for item: Item) {
        labelName.text = item.name
        labelGroup.text = item.group.description
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension Item.Group: CustomStringConvertible {
    var description: String {
        switch self {
        case .resource: return NSLocalizedString("資源", comment: "")
        case .combustible: return NSLocalizedString("可燃", comment: "")
        case .incombustible: return NSLocalizedString("不燃", comment: "")
        case .usedPaper: return NSLocalizedString("古紙", comment: "")
        case .oversized: return NSLocalizedString("粗大", comment: "")
        case .impossible: return NSLocalizedString("不可", comment: "")
        }
    }
}
