//
//  NotificationController.swift
//  Pill-Reminder
//
//  Created by mac on 19/5/2022.
//

import UIKit

class NotificationController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    static let current = NotificationController()
    let center = UNUserNotificationCenter.current()
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// grant user permission send notifications
    ///
    func notificationRequest(completion: @escaping () -> Void) {
        center.getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            switch settings.authorizationStatus {
            case .authorized:
                break
            case .notDetermined:
                self.center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        completion()
                    }
                }
            default:
                break
            }
        }
    }
    
    
    ///  set up timed notifications

    func setupTimeNotifications(medicationController: MedicationController) {
        for medication in medicationController.medications {
            for (index, time) in medication.times.enumerated() {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Medication Alert", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "It's time to take your \(self.dateFormatter.string(from: time)) \(medication.name)", arguments: nil)
                
                let request = UNNotificationRequest(identifier: medication.timesId[index], content: content, trigger: UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: time), repeats: true))
                self.center.add(request) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    /// notification every morning at 7am

    func setupLowDosageNotifications(medicationController: MedicationController) {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        for medication in medicationController.medications {
            if medication.quantity <= 10 {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Medication Low Alert", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "You have 10 or less \(medication.name) left. Time for a refill", arguments: nil)
                let request = UNNotificationRequest(identifier: medication.lowDoseId, content: content, trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: true))
                center.add(request) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
