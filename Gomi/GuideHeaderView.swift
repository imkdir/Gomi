import UIKit

extension UINib {
    static let header = UINib(nibName: "GuideHeaderView", bundle: nil)
}

final class GuideHeaderView: UICollectionReusableView {

    @IBOutlet weak var containerView: IBView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    func configure(for group: Item.Group) {
        
        labelTitle.text = group.description
        labelDetail.attributedText = attributed(group.headerDetail)
        imageIcon.image = group.headerImage
        
        containerView.backgroundColor = group.color
        containerView.layer.borderColor = group.color.cgColor
    }
    
    private func attributed(_ text: String?) -> NSAttributedString? {
        guard let str = text else { return nil }
        let components = str.components(separatedBy: .newlines)
        let mutable = NSMutableAttributedString(attributedString: .init(string: components[0] + "\n"))
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10)]
        for each in components.dropFirst() {
            mutable.append(.init(string: each, attributes: attrs))
        }
        return mutable
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension Item.Group {
    var headerDetail: String? {
        switch self {
        case .resource:
            return NSLocalizedString("请清除污渍，分门别类后投放\n种类不同，回收时间与回收车辆也不同", comment: "")
        case .combustible, .incombustible:
            return NSLocalizedString("装入带盖垃圾桶内或可视内容物等塑料袋里\n边长超过30cm的物品作为大件垃圾投放", comment: "")
        case .usedPaper:
            return NSLocalizedString("请分门别类用绳带捆绑好\n杂纸除去纸以外的部分，夹在杂志里，或装入纸袋里投放", comment: "")
        default:
            return nil
        }
    }
    var headerImage: UIImage? {
        return UIImage(named: "header\(rawValue)")
    }
}
