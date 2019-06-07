import Foundation

struct Store: Codable {
    var items: [Item]
    var guides: [[Guide]]
    
    func guides(for group: Item.Group) -> [Guide] {
        return guides[group.rawValue]
    }
    
    static var shared: Store! {
        let decoder = PropertyListDecoder()
        guard let tablePath = Bundle.main.path(forResource: "table", ofType: "plist"),
            let tableData = try? Data(contentsOf: URL(fileURLWithPath: tablePath)),
            let items = try? decoder.decode([Item].self, from: tableData) else {
            return nil
        }
        guard let guidePath = Bundle.main.path(forResource: "guide", ofType: "plist"),
            let guideData = try? Data(contentsOf: URL(fileURLWithPath: guidePath)),
            let guides = try? decoder.decode([[Guide]].self, from: guideData) else {
                return nil
        }
        return .init(items: items, guides: guides)
    }
}

class Item: NSObject, Codable {
    @objc let name: String
    let group: Group
    
    enum Group: Int, Codable {
        case resource, combustible, incombustible, usedPaper, oversized, impossible
    }
}

struct Guide: Codable {
    let id: Int
    let title: String
    let detail: String
    let subgroup: String
    let dispose: String
}
