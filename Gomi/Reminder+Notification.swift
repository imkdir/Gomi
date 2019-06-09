import Foundation

extension Reminder {
    private func notificationId(weekday: Int, weekOfMonth: Int) -> String {
        return String(format: "G:%dWD:%d:WM:%d", group.rawValue, weekday, weekOfMonth)
    }
    
    private func dateComponents(weekday: Int, weekOfMonth: Int) -> DateComponents {
        var components = DateComponents()
        components.weekday = weekday
        components.weekOfMonth = weekOfMonth
        if let due = self.due {
            components.hour = due[.hour]
            components.minute = due[.minute]
        }
        return components
    }
    
    func activate() {
        for wm in weekOfMonth {
            for wd in weekday {
                let identifier = notificationId(weekday: wd, weekOfMonth: wm)
                let components = dateComponents(weekday: wd, weekOfMonth: wm)
                NotificationHelper.schedule(identifier: identifier, body: group.description, components: components)
            }
        }
    }
    
    func deactive() {
        let identifiers = weekOfMonth.flatMap({ wm in
            weekday.map({ wd in
                notificationId(weekday: wd, weekOfMonth: wm) }) })
        NotificationHelper.cancelAlert(identifiers: identifiers)
    }
}

extension Date {
    subscript(component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
}
