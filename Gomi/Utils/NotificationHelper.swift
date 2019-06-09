import UIKit
import UserNotifications

struct NotificationHelper {
    
    static func registerSettings(completion: @escaping (() -> Void) = {}) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else {
                completion()
                return
            }
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                completion()
            }
        }
    }
    
    static func schedule(identifier: String, body: String, components: DateComponents, sound: UNNotificationSound = .default) {
        checkPermission {
            scheduleAlert(identifier: identifier, body: body, components: components, sound: sound)
        }
    }
    
    static func cancelAlert(identifiers: [String]) {
        print(#function, "identifiers:", identifiers)
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    private static func checkPermission(enabledHandler: @escaping () -> Void) {
        isEnabled({ isEnabled in
            guard isEnabled else { return }
            enabledHandler()
        })
    }
    
    private static func isEnabled(_ handler: @escaping (Bool) -> Void) {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    handler(settings.alertSetting == .enabled)
                }
            } else {
                DispatchQueue.main.async {
                    handler(false)
                }
            }
        }
    }
    
    private static func scheduleAlert(identifier: String, body: String, components: DateComponents, sound: UNNotificationSound = .default) {
        let content = UNMutableNotificationContent()
        content.body = body
        content.sound = sound
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier:identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if error != nil {
                print(error?.localizedDescription ?? #function)
            } else {
                print(#function, "identifier:", identifier)
            }
        }
    }
    
    private static func presentPopupAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: NSLocalizedString("OK. Got it.", comment: ""), style: .default))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
}
