import UIKit

extension UINib {
    static let header = UINib(nibName: "GuideHeaderView", bundle: nil)
}

final class GuideHeaderView: UICollectionReusableView {

    @IBOutlet weak var containerView: IBView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    
    func configure(for group: Item.Group) {
        
        labelTitle.text = group.description
        labelDetail.attributedText = attributed(group.headerDetail)
        
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
            return NSLocalizedString("Remove stains from recyclables and classify them into each category.", comment: "")
        case .combustible, .incombustible:
            return NSLocalizedString("Place combustible wastes into either a garbage can with a lid or a transparent bag.", comment: "")
        case .usedPaper:
            return NSLocalizedString("Bundle items in each category and tie them up with strings.", comment: "")
        default:
            return nil
        }
    }
}
