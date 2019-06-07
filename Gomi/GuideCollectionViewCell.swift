import UIKit

extension UINib {
    static let guide = UINib(nibName: "GuideCollectionViewCell", bundle: nil)
}

final class GuideCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelGroup: UILabel!
    @IBOutlet weak var labelSubgroup: UILabel!
    
    func configure(for guide: Guide, group: Item.Group) {
        labelTitle.text = guide.title
        labelDetail.text = guide.detail
        imageIcon.image = guide.image
        labelGroup.superview!.backgroundColor = group.color
        labelGroup.text = group.description
        labelSubgroup.superview!.backgroundColor = group.color
        labelSubgroup.superview!.isHidden = guide.subgroup.isEmpty
        labelSubgroup.text = "  \(guide.subgroup)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelSubgroup.text = nil
        
        if case .phone = UIDevice.current.userInterfaceIdiom {
            labelTitle.numberOfLines = 0
            labelDetail.numberOfLines = 0
        } else {
            labelTitle.numberOfLines = 1
            labelDetail.numberOfLines = 2
        }
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        
        if case .pad = UIDevice.current.userInterfaceIdiom {
            let minimumWidth = UIScreen.main.bounds.width * 0.3
            let constraint = contentView.widthAnchor.constraint(lessThanOrEqualToConstant: minimumWidth)
            constraint.priority = .defaultHigh
            constraint.isActive = true
            contentView.heightAnchor.constraint(equalToConstant: 192).isActive = true
        } else {
            let constraint = contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32)
            constraint.priority = .defaultHigh
            constraint.isActive = true
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        var frame = layoutAttributes.frame
        if case .pad = UIDevice.current.userInterfaceIdiom {
            frame.size.width = contentSize.width
        } else {
            frame.size.width = UIScreen.main.bounds.width - 32
            frame.size.height = contentSize.height
        }
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    private var contentSize: CGSize {
        return contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

extension Guide {
    var image: UIImage {
        return UIImage(named: "guide\(id)")!
    }
}

extension Item.Group {
    var color: UIColor {
        switch self {
        case .resource: return #colorLiteral(red: 0.1765775979, green: 0.5696728826, blue: 0.2497320771, alpha: 1)
        case .combustible: return #colorLiteral(red: 0.900148809, green: 0.03184144199, blue: 0.06868951768, alpha: 1)
        case .incombustible: return #colorLiteral(red: 0.01532619074, green: 0.2493849993, blue: 0.5993071198, alpha: 1)
        case .usedPaper: return #colorLiteral(red: 0.458291471, green: 0.07755672187, blue: 0.5188565254, alpha: 1)
        case .oversized: return #colorLiteral(red: 0.2939098179, green: 0.2860078812, blue: 0.2859160304, alpha: 1)
        case .impossible: return .clear
        }
    }
}
