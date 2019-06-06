import UIKit

private let cellIdentifier = "Cell"
private let headerIdentifier = "Header"

final class GuideCollectionViewController: UICollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .init(width: UIScreen.main.bounds.width - 32, height: 192)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 117)
        
        super.init(collectionViewLayout: layout)
        
        tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Guide", comment: "")

        self.collectionView.backgroundColor = #colorLiteral(red: 0.937263906, green: 0.9370692968, blue: 0.9586113095, alpha: 1)
        self.collectionView.contentInset = .init(top: 20, left: 16, bottom: 20, right: 16)
        self.collectionView!.register(.guide, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView!.register(.header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionViewLayout.invalidateLayout()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Store.shared.guides.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Store.shared.guides[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GuideCollectionViewCell
        let guide = Store.shared.guides[indexPath.section][indexPath.row]
        cell.configure(for: guide, group: Item.Group(rawValue: indexPath.section)!)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! GuideHeaderView
        header.configure(for: Item.Group(rawValue: indexPath.section)!)
        return header
    }
}
