import UIKit

private let reuseIdentifier = "Cell"

final class GuideCollectionViewController: UICollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        if case .pad = UIDevice.current.userInterfaceIdiom {
            layout.estimatedItemSize = .init(width: 200, height: 158)
        } else {
            let width = UIScreen.main.bounds.width - 32
            layout.itemSize = .init(width: width, height: 158)
        }
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        
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
        self.collectionView!.register(.guide, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Store.shared.guides.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Store.shared.guides[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GuideCollectionViewCell
        let guide = Store.shared.guides[indexPath.section][indexPath.row]
        cell.configure(for: guide)
        return cell
    }
}
