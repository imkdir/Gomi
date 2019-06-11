import Foundation

struct Reminder: Codable {
    let group: Item.Group
    var weekday: [Int]
    var weekOfMonth: [Int]
    var due: Date?
    var isOn: Bool
}

extension Reminder {
    init(group: Item.Group) {
        self.init(group: group, weekday: [], weekOfMonth: [], due: nil, isOn: true)
    }
}

extension UserDefaults {
    var reminders: [Reminder] {
        set {
            do {
                let data = try PropertyListEncoder().encode(newValue)
                self.setValue(data, forKey: #function)
                synchronize()
            } catch {
                print(#function, newValue, "save failed")
            }
        }
        get {
            guard let data = value(forKey: #function) as? Data else { return [] }
            do {
                return try PropertyListDecoder().decode([Reminder].self, from: data)
            } catch {
                return []
            }
        }
    }
}
