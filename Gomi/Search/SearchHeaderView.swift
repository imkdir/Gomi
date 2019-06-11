import UIKit

final class SearchHeaderView: UITableViewHeaderFooterView {
    let label = UILabel()
    let button = UIButton(type: .system)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        addSubview(button)
        
        label.text = NSLocalizedString("Recent", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle(NSLocalizedString("Clear", comment: ""), for: [.normal])
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        bottomAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 1).isActive = true
        
        trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 15).isActive = true
        button.firstBaselineAnchor.constraint(equalTo: label.firstBaselineAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
