import UIKit

extension UINib {
    static let guide = UINib(nibName: "GuideCollectionViewCell", bundle: nil)
}

final class GuideCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    func configure(for guide: Guide) {
        labelTitle.text = guide.title
        labelDetail.text = guide.detail
        imageIcon.image = guide.image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        
        if case .pad = UIDevice.current.userInterfaceIdiom {
            let minimumWidth = UIScreen.main.bounds.width * 0.3
            let constraint = contentView.widthAnchor.constraint(lessThanOrEqualToConstant: minimumWidth)
            constraint.priority = .defaultHigh
            constraint.isActive = true
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        var frame = layoutAttributes.frame
        frame.size.width = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}

extension Guide {
    var image: UIImage {
        return UIImage(named: "guide\(id)")!
    }
}
