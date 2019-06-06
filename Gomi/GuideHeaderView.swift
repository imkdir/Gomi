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
        
        containerView.backgroundColor = group.color
        containerView.layer.borderColor = group.color.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
