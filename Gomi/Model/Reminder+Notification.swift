import Foundation

extension Reminder {

    func activate() {
        guard let due = self.due else { return }
        
        for wm in weekOfMonth {
            for wd in weekday {
                let identifier = nid(weekday: wd, weekOfMonth: wm)
                var components = DateComponents()
                components.weekday = wd
                components.weekOfMonth = wm
                components.hour = due[.hour]
                components.minute = due[.minute]
                let body = String(format: NSLocalizedString("%@ are collected on today.", comment: ""), group.description)
                NotificationHelper.schedule(identifier: identifier, body: body, components: components)
            }
        }
    }
    
    func deactive() {
        let identifiers = weekOfMonth
            .flatMap { wm in
                weekday.map { wd in nid(weekday: wd, weekOfMonth: wm) }
            }
        NotificationHelper.cancelAlert(identifiers: identifiers)
    }
    
    private func nid(weekday: Int, weekOfMonth: Int) -> String {
        String(format: "G:%dWD:%d:WM:%d", group.rawValue, weekday, weekOfMonth)
    }
}

extension Date {
    subscript(component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
}
