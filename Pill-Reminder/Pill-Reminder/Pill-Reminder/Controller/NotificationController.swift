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
    
    /// Function to prompt the user for permission to schedule and send notifications
    /// - Parameter completion: completion handler for the authorization request
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
    
    
    /// Function to set up timed notifications for every medication scheduled in the medications array
    /// - Parameter medicationController: The medication controller to be passed in
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
    
    /// Function to set up a notification every morning at 7am when their quantity drops below 10
    /// - Parameter medicationController: The medication controller to be passed in.
    func setupLowDosageNotifications(medicationController: MedicationController) {
        var components = DateComponents()
        components.hour = 7
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
