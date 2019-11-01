import Foundation

struct Store: Codable {
    var items: [Item]
}

extension Store {
    init?(path name: String, type: String = "plist") {
        let decoder = PropertyListDecoder()
        guard let tablePath = Bundle.main.path(forResource: name, ofType: type),
            let tableData = try? Data(contentsOf: URL(fileURLWithPath: tablePath)),
            let items = try? decoder.decode([Item].self, from: tableData) else {
            return nil
        }
        self.init(items: items)
    }
}

class Item: NSObject, Codable {
    @objc let name: String
    let group: Group
    
    enum Group: Int, Codable {
        case resource, combustible, incombustible, usedPaper, oversized, impossible, containMercury
    }
}
