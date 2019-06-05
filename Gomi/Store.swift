import Foundation

struct Store: Codable {
    var items: [Item]
    
    static var shared: Store! {
        let decoder = PropertyListDecoder()
        guard let path = Bundle.main.path(forResource: "table", ofType: "plist"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let items = try? decoder.decode([Item].self, from: data) else {
            return nil
        }
        return .init(items: items)
    }
}

class Item: NSObject, Codable {
    @objc let name: String
    let group: Group
    
    enum Group: Int, Codable {
        case resource, combustible, incombustible, usedPaper, oversized, impossible
    }
}
