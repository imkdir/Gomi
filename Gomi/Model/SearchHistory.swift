import Foundation

struct SearchHistory {
    let userDefaults: UserDefaults
    
    mutating func log(term: String) {
        store.append(term)
    }
    
    var length: Int {
        set {
            userDefaults.set(newValue, forKey: #function)
            userDefaults.synchronize()
        }
        get {
            userDefaults.integer(forKey: #function)
        }
    }
    
    var read: [String] {
        store.reversed()
    }
    
    mutating func clear() {
        store.removeAll()
    }
    
    fileprivate var store: [String] {
        set {
            var newValue = newValue
            if length != 0, newValue.count > length {
                newValue.removeLast(length - newValue.count)
            }
            userDefaults.set(newValue, forKey: #function)
            userDefaults.synchronize()
        }
        get {
            return userDefaults.value(forKey: #function) as? [String] ?? []
        }
    }
}
