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
        case .resource: return NSLocalizedString("Recyclables", comment: "")
        case .combustible: return NSLocalizedString("Combustible", comment: "")
        case .incombustible: return NSLocalizedString("Non-combustible", comment: "")
        case .usedPaper: return NSLocalizedString("Used paper", comment: "")
        case .oversized: return NSLocalizedString("Large-sized waste", comment: "")
        case .impossible: return NSLocalizedString("Impossible", comment: "")
        case .containMercury: return NSLocalizedString("Products containing mercury", comment: "")
        }
    }
}
